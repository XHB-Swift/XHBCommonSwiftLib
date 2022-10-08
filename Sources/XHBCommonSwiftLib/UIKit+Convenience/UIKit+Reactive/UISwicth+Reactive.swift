//
//  UISwicth+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UISwitch {
    
    public var observation: AnyObservable<Bool, Never> {
        return .init(UISwitch.Action<UISwitch>(output: self, events: .valueChanged).map { $0.isOn })
    }
}
