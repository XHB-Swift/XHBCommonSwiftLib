//
//  UISlider+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UISlider {
    
    public var observation: AnyObservable<Float, Never> {
        return .init(UISlider.Action<UISlider>(output: self, events: .valueChanged).map { $0.value })
    }
}
