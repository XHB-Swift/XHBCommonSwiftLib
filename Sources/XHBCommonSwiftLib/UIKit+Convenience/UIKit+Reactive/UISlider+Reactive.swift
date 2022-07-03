//
//  UISlider+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UISlider {
    
    @discardableResult
    open func subscribeValue(action: @escaping UIControlEventsAction<UISlider>) -> ValueObservable<Float> {
        return UIControl.subscribe(control: self, value: self.value, action: action)
    }
}
