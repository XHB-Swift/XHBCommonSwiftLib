//
//  UITextView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/3.
//

import UIKit
import XHBFoundationSwiftLib

extension UITextView {
    
    @discardableResult
    open func subscribedText(action: @escaping ObserverClosure<UITextView, String?>) -> ValueObservable<String?> {
        return self.textStorage.subscribe(value: text,
                                          didProcess: { [weak self] (storage, editedMask, editedRange, changedInLength) in
            guard let strongSelf = self else { return }
            action(strongSelf, storage.string)
        },
                                          willProcess: nil)
    }
    
    @discardableResult
    open func subscribedAttributedText(action: @escaping ObserverClosure<UITextView, NSAttributedString>) -> ValueObservable<NSAttributedString?> {
        return self.textStorage.subscribe(value: attributedText,
                                          didProcess: { [weak self] (storage, editedMask, editedRange, changedInLength) in
            guard let strongSelf = self else { return }
            action(strongSelf, strongSelf.attributedText)
        },
                                          willProcess: nil)
    }
    
}
