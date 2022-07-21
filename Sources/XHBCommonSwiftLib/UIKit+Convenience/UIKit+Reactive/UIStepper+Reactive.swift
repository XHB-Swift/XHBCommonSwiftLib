//
//  UIStepper+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIStepper {
    
    open var observation: AnyObservable<Double, Never> {
        return .init(UIStepper.Action<UIStepper>(output: self, events: .valueChanged).map { $0.value })
    }
}
