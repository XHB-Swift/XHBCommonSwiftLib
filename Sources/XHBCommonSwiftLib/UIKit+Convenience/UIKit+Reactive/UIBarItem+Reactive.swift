//
//  UIBarItem+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIBarItem {
    
    private static var UIBarItemTitleTextAttributesKey: Void?
    
    @discardableResult
    open func subscribeTitleTextAtrributes(for state: UIControl.State) -> ValueObservable<[NSAttributedString.Key : Any]?> {
        let tmp: [NSAttributedString.Key : Any]? = nil
        let observable = specifiedOptinalValueObservable(value: tmp, queue: .main)
        observable.add(observer: self) { barItem, attributes in
            barItem.setTitleTextAttributes(attributes, for: state)
        }
        return observable
    }
}
