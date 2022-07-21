//
//  UIBarItem+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIBarItem {
    
    open func subscribeTitleTextAtrributes(for state: UIControl.State) -> NSObjectNilValueObservation<[NSAttributedString.Key : Any]> {
        return subscribe(for: { [weak self] in self?.setTitleTextAttributes($0, for: state)})
    }
}
