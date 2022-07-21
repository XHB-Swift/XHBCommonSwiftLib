//
//  UIActivityIndicatorView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/3.
//

import UIKit
import XHBFoundationSwiftLib

extension UIActivityIndicatorView {
    
    open func subscribeAnimating(before: ((Bool) -> Void)? = nil,
                                 after: ((Bool) -> Void)? = nil) -> NSObjectValueObservation<Bool> {
        return subscribe(for: isAnimating, action: { [weak self] in
            before?($0)
            if $0 {
                self?.startAnimating()
            } else {
                self?.stopAnimating()
            }
            after?($0)
        })
    }
}
