//
//  UIButton+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIButton {
    
    @discardableResult
    open func touchupInside(action: @escaping UIControlEventsAction<UIButton>) -> AnyObservable {
        return UIControl.subscribe(control: self, events: .touchUpInside, action: action)
    }
}

extension UIButton {
    
    private static var UIButtonTitleKey: Void?
    private static var UIButtonImageKey: Void?
    private static var UIButtonBackgroundImageKey: Void?
    private static var UIButtonAttributedTitleKey: Void?
    
    @discardableResult
    open func subscribeTitle(for state: UIControl.State) -> ValueObservable<String?> {
        let tmp: String? = nil
        let observable = specifiedOptinalValueObservable(value: tmp, queue: .main)
        observable.add(observer: self) { button, changedTitle in
            button.setTitle(changedTitle, for: state)
        }
        return observable
    }
    
    @discardableResult
    open func subscribeImage(for state: UIControl.State) -> ValueObservable<UIImage?> {
        let tmp: UIImage? = nil
        let observable = specifiedOptinalValueObservable(value: tmp, queue: .main)
        observable.add(observer: self) { button, changedImage in
            button.setImage(changedImage, for: state)
        }
        return observable
    }
    
    @discardableResult
    open func subscribeBackgroundImage(for state: UIControl.State) -> ValueObservable<UIImage?> {
        let tmp: UIImage? = nil
        let observable = specifiedOptinalValueObservable(value: tmp, queue: .main)
        observable.add(observer: self) { button, changedImage in
            button.setBackgroundImage(changedImage, for: state)
        }
        return observable
    }
    
    @discardableResult
    open func subscribeAttributedTitle(for state: UIControl.State) -> ValueObservable<NSAttributedString?> {
        let tmp: NSAttributedString? = nil
        let observable = specifiedOptinalValueObservable(value: tmp, queue: .main)
        observable.add(observer: self) { button, changedAttributedTitle in
            button.setAttributedTitle(changedAttributedTitle, for: state)
        }
        return observable
    }
}
