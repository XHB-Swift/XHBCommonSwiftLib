//
//  UIView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIView {
    
    public func observation<G: UIGestureRecognizer>(for gesture: G) -> G.Observation<G> {
        addGestureRecognizer(gesture)
        return .init(output: gesture)
    }
}
