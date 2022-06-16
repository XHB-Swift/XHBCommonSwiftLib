//
//  CustomTransitioning.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/16.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#if os(iOS)

import UIKit

open class CustomTransitioningAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    open var forward = true //true正向动画，false反向动画
    open var duration: TimeInterval = 0
    open var isTransitioning = true
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isTransitioning ? (transitionContext?.isAnimated ?? false) ? duration : 0 : duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let dstViewController = transitionContext.viewController(forKey: .to)
        let srcViewController = transitionContext.viewController(forKey: .from)
        guard let dstView = dstViewController?.view,
              let srcView = srcViewController?.view else {
            return
        }
        if forward {
            containerView.insertSubview(dstView, aboveSubview: srcView)
        } else {
            if dstView.superview == nil {
                containerView.insertSubview(dstView, belowSubview: srcView)
            }
        }
        doAnimation(srcView, dstView, transitionContext)
    }
    
    open func doAnimation(_ from: UIView,
                          _ to: UIView,
                          _ transitionContext: UIViewControllerContextTransitioning?,
                          _ completion:(()->Void)? = nil) {}
    open func animationWillBegin(_ from: UIView, _ to: UIView) {}
    open func animationDidBegin(_ from: UIView, _ to: UIView) {}
}

public protocol CustomPresentationControllerDelegate : AnyObject {
    
    func frameOfPresetedViewInContainerView(_ containerView: UIView?) -> CGRect
}

open class CustomPresentationController : UIPresentationController {
    
    private(set) lazy var dimmingView = { () -> UIView in
        let view = UIView(frame: .zero)
        view.alpha = 0.5
        view.backgroundColor = .black
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDimmingViewAction(_:))))
        return view
    }()
    
    open var enableDimming = false
    
    open weak var customPresetationDelegate: CustomPresentationControllerDelegate?
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    open override func presentationTransitionWillBegin() {
        if !enableDimming { return }
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
        containerView?.addSubview(dimmingView)
        let tmpAlpha = dimmingView.alpha
        dimmingView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = tmpAlpha
        }, completion: nil)
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            if !enableDimming { return }
            dimmingView.removeFromSuperview()
        }
    }
    
    open override func dismissalTransitionWillBegin() {
        if !enableDimming { return }
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            if !enableDimming { return }
            dimmingView.removeFromSuperview()
        }
    }
    
    open override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container.isEqual(presentedViewController) {
            containerView?.setNeedsLayout()
        }
    }
    
    open override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container.isEqual(presentedViewController) {
            return frameOfPresentedViewInContainerView.size
        }else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if enableDimming {
            dimmingView.frame = containerView?.bounds ?? .zero
        }
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        return customPresetationDelegate?.frameOfPresetedViewInContainerView(containerView) ?? super.frameOfPresentedViewInContainerView
    }
    
    @objc private func tapDimmingViewAction(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismissCustomModal(animated: true, completion: nil)
    }
    
}

open class CustomTransitioning : NSObject {
    
    open var interactionTransition: UIViewControllerInteractiveTransitioning?
}

open class CustomModalTransitioningConfiguration : CustomPresentationControllerDelegate {
    
    //自定义转场默认生效
    open var effect = true
    open var displaySize = CGSize.zero
    open var enableDimmingView = true
    open var duration: TimeInterval = 0.5
    //是否为系统的转场方式
    open var isTransitioning = true
    
    private(set) lazy var presentAnimation: CustomTransitioningAnimator? = { () -> CustomTransitioningAnimator in
        let animate = CustomTransitioningAnimator()
        animate.forward = true
        animate.duration = duration
        animate.isTransitioning = isTransitioning
        return animate
    }()
    
    private(set) lazy var dismissAnimation: CustomTransitioningAnimator? = { () -> CustomTransitioningAnimator in
        let animate = CustomTransitioningAnimator()
        animate.forward = false
        animate.duration = duration
        animate.isTransitioning = isTransitioning
        return animate
    }()
    
    open func frameOfPresetedViewInContainerView(_ containerView: UIView?) -> CGRect {
        if self.displaySize.width == 0 ||
            self.displaySize.height == 0 ||
            self.displaySize.height >= (containerView?.height ?? 0) {
            return containerView?.bounds ?? .zero
        }else {
            return CGRect(origin: .zero, size: self.displaySize)
        }
    }
}

open class CustomModalTransitioning : CustomTransitioning, UIViewControllerTransitioningDelegate {
    
    open var presentationController: CustomPresentationController?
    open var configuration: CustomModalTransitioningConfiguration?
    
    public init(configuration: CustomModalTransitioningConfiguration?,
                presentationController: CustomPresentationController?) {
        
        self.configuration = configuration
        self.presentationController = presentationController
    }
    
    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        configuration?.presentAnimation?.forward = true
        return configuration?.presentAnimation
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimate = configuration?.dismissAnimation ?? configuration?.presentAnimation
        dismissAnimate?.forward = false
        return dismissAnimate
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
}

open class CustomNavigationTransitioning : CustomTransitioning, UINavigationControllerDelegate {
    
    open var pushAnimation: CustomTransitioningAnimator?
    open var popAnimation: CustomTransitioningAnimator?
    
    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return pushAnimation
        case .pop:
            return popAnimation
        default:
            return nil
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionTransition
    }
}

open class CustomTabTransitioning : CustomTransitioning, UITabBarControllerDelegate {
    
    open var switchAnimation: CustomTransitioningAnimator?
    
    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return switchAnimation
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactionTransition
    }
}

fileprivate final class CustomTransitioningManager {
    
    private var transitionings = Dictionary<String, CustomTransitioning>()
    public static let shared = CustomTransitioningManager()
    
    private init() {}
    
    public func setTransitioning(_ transitioning: CustomTransitioning, for key: String) {
        transitionings[key] = transitioning
    }
    
    public func removeTransitioning(for key: String) {
        _ = transitionings.removeValue(forKey: key)
    }
}

fileprivate final class CustomModalAnimationManager {
    
    private var animations = Dictionary<String, CustomModalTransitioningConfiguration>()
    public static let shared = CustomModalAnimationManager()
    
    private init() {}
    
    public func setAnimation(_ animation: CustomModalTransitioningConfiguration, for key: String) {
        animations[key] = animation
    }
    
    public func animation(for key: String) -> CustomModalTransitioningConfiguration? {
        return animations[key]
    }
    
    public func removeAnimation(for key: String) {
        _ = animations.removeValue(forKey: key)
    }
}

extension UIViewController {
    
    open func presentCustomModal(viewController: UIViewController,
                                 configuration: CustomModalTransitioningConfiguration?,
                                 completion: (()->Void)?) {
        
        if let config = configuration, config.effect {
            let customPresentationController = CustomPresentationController(presentedViewController: viewController, presenting: self)
            customPresentationController.customPresetationDelegate = config
            let customModalTransitioning = CustomModalTransitioning(configuration: config, presentationController: customPresentationController)
            viewController.transitioningDelegate = customModalTransitioning
            CustomTransitioningManager.shared.setTransitioning(customModalTransitioning, for: "\(viewController)")
        }
        present(viewController, animated: true, completion: completion)
    }
    
    open func dismissCustomModal(animated: Bool, completion: (()->Void)?) {
        let vc = presentedViewController ?? self
        let key = "\(vc)"
        vc.dismiss(animated: animated) {
            CustomTransitioningManager.shared.removeTransitioning(for: key)
            completion?()
        }
    }
    
    open func show(viewController: UIViewController, config: CustomModalTransitioningConfiguration) {
        guard let targetView = viewController.view else { return }
        CustomModalAnimationManager.shared.setAnimation(config, for: "\(viewController)")
        addChild(viewController)
        targetView.size = config.displaySize
        view.addSubview(targetView)
        let enterAnimate = config.presentAnimation
        enterAnimate?.forward = true
        enterAnimate?.doAnimation(view, targetView, nil)
    }
    
    open func disappear() {
        let key = "\(self)"
        let completion = { [weak self] in
            self?.removeFromParent()
            self?.view.removeFromSuperview()
            CustomModalAnimationManager.shared.removeAnimation(for: key)
        }
        guard let config = CustomModalAnimationManager.shared.animation(for: key),
              let parentVC = parent else {
            completion()
            return
        }
        let exitAnimate = config.dismissAnimation ?? config.presentAnimation
        exitAnimate?.forward = false
        exitAnimate?.doAnimation(view, parentVC.view, nil, completion)
    }
    
}

#endif
