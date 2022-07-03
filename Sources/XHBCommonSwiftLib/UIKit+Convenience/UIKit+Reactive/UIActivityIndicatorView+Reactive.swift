//
//  UIActivityIndicatorView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/3.
//

import UIKit
import XHBFoundationSwiftLib

extension UIActivityIndicatorView {
    
    @discardableResult
    open func subscribedAnimating(action: @escaping ObserverClosure<UIActivityIndicatorView, Bool>) -> ValueObservable<Bool> {
        let observable = specifiedValueObservable(value: isAnimating, queue: .main)
        observable.add(observer: self) { activityIndicator, animating in
            if animating {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            action(activityIndicator, animating)
        }
        return observable
    }
}
