//
//  UIStepper+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIStepper {
    
    @discardableResult
    open func subscribeValue(action: @escaping UIControlEventsAction<UIStepper>) -> ValueObservable<Double> {
        return UIControl.subscribe(control: self, value: self.value, action: action)
    }
}
