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
    open func touchupInside(action: @escaping UIControlEventsAction) -> AnyObservable {
        return subscribe(events: .touchUpInside, action: action)
    }
}

extension UIButton {
    
    private static var UIButtonTitleKey: Void?
    private static var UIButtonImageKey: Void?
    private static var UIButtonBackgroundImageKey: Void?
    private static var UIButtonAttributedTitleKey: Void?
    
    @discardableResult
    open func subscribeTitle(for state: UIControl.State) -> Observable<String?> {
        return runtimePropertyLazyBinding(&Self.UIButtonTitleKey) {
            let ob = Observable<String?>(observedValue: nil, queue: .main)
            ob.add(observer: self) { button, changedTitle in
                button?.setTitle(changedTitle, for: state)
            }
            return ob
        }
    }
    
    @discardableResult
    open func subscribeImage(for state: UIControl.State) -> Observable<UIImage?> {
        return runtimePropertyLazyBinding(&Self.UIButtonImageKey) {
            let ob = Observable<UIImage?>(observedValue: nil, queue: .main)
            ob.add(observer: self) { button, changedImage in
                button?.setImage(changedImage, for: state)
            }
            return ob
        }
    }
    
    @discardableResult
    open func subscribeBackgroundImage(for state: UIControl.State) -> Observable<UIImage?> {
        return runtimePropertyLazyBinding(&Self.UIButtonImageKey) {
            let ob = Observable<UIImage?>(observedValue: nil, queue: .main)
            ob.add(observer: self) { button, changedImage in
                button?.setBackgroundImage(changedImage, for: state)
            }
            return ob
        }
    }
    
    @discardableResult
    open func subscribeAttributedTitle(for state: UIControl.State) -> Observable<NSAttributedString?> {
        return runtimePropertyLazyBinding(&Self.UIButtonAttributedTitleKey) {
            let ob = Observable<NSAttributedString?>(observedValue: nil, queue: .main)
            ob.add(observer: self) { button, changedAttributedTitle in
                button?.setAttributedTitle(changedAttributedTitle, for: state)
            }
            return ob
        }
    }
}
