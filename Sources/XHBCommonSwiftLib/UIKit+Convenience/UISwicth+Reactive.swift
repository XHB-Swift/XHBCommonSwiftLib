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
    open func subscribeOn(action: @escaping UIControlEventsAction) -> Observable<Bool> {
        return subscribe(value: self.isOn, action: action)
    }
}
