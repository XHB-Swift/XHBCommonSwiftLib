//
//  UISwicth+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UISwitch {
    
    @discardableResult
    open func subscribeOn(action: @escaping UIControlEventsAction<UISwitch>) -> ValueObservable<Bool> {
        return UIControl.subscribe(control: self, value: self.isOn, action: action)
    }
}
