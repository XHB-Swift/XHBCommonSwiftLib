//
//  UITextView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/3.
//

import UIKit
import XHBFoundationSwiftLib

extension UITextView {
    
    open var textObservation: AnyObservable<String, Never> {
        return .init(textStorage.observation.map { $0.storage.string })
    }
    
    open var attributedTextObservation: AnyObservable<NSAttributedString, Never> {
        return .init(textStorage.observation.map { $0.storage })
    }
}
