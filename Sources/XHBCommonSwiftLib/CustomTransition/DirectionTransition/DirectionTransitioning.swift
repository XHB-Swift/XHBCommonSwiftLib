//
//  DirectionTransitioning.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/16.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

#if os(iOS)

import UIKit

public enum TransitionDirection {
    
    case top
    case left
    case bottom
    case right
    case center
    
}

open class DirectionTransitioningAnimator: CustomTransitioningAnimator {
    
    //从左边进就从左边出
    open var direction: TransitionDirection = .left
    
    open override func doAnimation(_ from: UIView,
                                   _ to: UIView,
                                   _ transitionContext: UIViewControllerContextTransitioning?,
                                   _ completion: (() -> Void)? = nil) {
        
        animationWillBegin(with: from, to)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseInOut]) { [weak self] in
            self?.animationDidBegin(with: from, to)
        } completion: { finished in
            completion?()
            guard let ctx = transitionContext else { return }
            ctx.completeTransition(!ctx.transitionWasCancelled)
        }
    }
    
    private func animationWillBegin(with srcView: UIView, _ dstView: UIView) {
        guard let superView = dstView.superview else { return }
        switch direction {
        case .left:
            if self.forward {
                dstView.x = -superView.width
            }else {
                srcView.x = 0
            }
            break
        case .right:
            if self.forward {
                dstView.x = superView.width
            }else {
                srcView.x = 0
            }
            break
        case .top:
            if self.forward {
                dstView.y = -superView.height
            }else {
                srcView.y = 0
            }
            break
        case .bottom:
            if self.forward {
                dstView.y = superView.height
            }else {
                srcView.bottom = superView.height
            }
            break
        case .center:
            if self.forward {
                dstView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
                dstView.alpha = 0
            }else {
                srcView.transform = .identity
                srcView.alpha = 1
            }
            break
        }
        
    }
    
    private func animationDidBegin(with srcView: UIView, _ dstView: UIView) {
        guard let superView = srcView.superview else { return }
        switch direction {
        case .left:
            if self.forward {
                dstView.x = 0
            }else {
                srcView.x = -superView.width
            }
            break
        case .right:
            if self.forward {
                dstView.x = 0
            }else {
                srcView.x = superView.width
            }
            break
        case .top:
            if self.forward {
                dstView.y = 0
            }else {
                srcView.y = -superView.height
            }
            break
        case .bottom:
            if self.forward {
                dstView.bottom = superView.height
            }else {
                srcView.y = superView.height
            }
            break
        case .center:
            if self.forward {
                dstView.transform = .identity
                dstView.alpha = 1
            }else {
                srcView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
                srcView.alpha = 0
            }
            break
        }
    }
    
}

open class CustomModalDirectionTransitioningConfiguration: CustomModalTransitioningConfiguration {
    
    open var direction: TransitionDirection = .left
    
    public init(direction: TransitionDirection, displayedSize: CGSize) {
        super.init()
        self.direction = direction
        self.displaySize = displayedSize
    }
    
    override var presentAnimation: CustomTransitioningAnimator? {
        let animate = DirectionTransitioningAnimator()
        animate.direction = direction
        animate.duration = duration
        animate.isTransitioning = isTransitioning
        return animate
    }
    
    override var dismissAnimation: CustomTransitioningAnimator? {
        return nil
    }
    
    open override func frameOfPresetedViewInContainerView(_ containerView: UIView?) -> CGRect {
        var frame = super.frameOfPresetedViewInContainerView(containerView)
        let containerFrame = containerView?.frame ?? .zero
        
        switch direction {
        case .left:
            frame.origin.x = 0
            break
        case .right:
            frame.origin.x = containerFrame.maxX - displaySize.width
            break
        case .top:
            frame.origin.y = 0
            break
        case .bottom:
            frame.origin.y = containerFrame.height - displaySize.height
            break
        case .center:
            frame.origin = CGPoint(x: (containerFrame.width - displaySize.width) / 2,
                                   y: (containerFrame.height - displaySize.height) / 2)
        }
        
        return frame
    }
    
}

#endif
