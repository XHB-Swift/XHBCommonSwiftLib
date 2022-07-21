//
//  UITextField+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UITextField {
    
    open var textObservation: AnyObservable<String?, Never> {
        return .init(UITextField.Action<UITextField>(output: self, events: [.valueChanged, .allEditingEvents])
            .map { $0.text })
    }
    
    open var attributedTextObservation: AnyObservable<NSAttributedString?, Never> {
        return .init(UITextField.Action<UITextField>(output: self, events: [.valueChanged, .allEditingEvents])
            .map { $0.attributedText })
    }
}
