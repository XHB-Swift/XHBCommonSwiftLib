//
//  UITextField+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UITextField {
    
    @discardableResult
    open func subscribeText(action: @escaping UIControlEventsAction<UITextField>) -> ValueObservable<String?> {
        return UIControl.subscribe(control: self, value: self.text, action: action)
    }
    
    @discardableResult
    open func subscribeAttributedText(action: @escaping UIControlEventsAction<UITextField>) -> ValueObservable<NSAttributedString?> {
        return UIControl.subscribe(control: self, value: self.attributedText, action: action)
    }
}
