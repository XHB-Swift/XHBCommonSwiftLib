//
//  UIBarButtonItem+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate struct SEL_UIBarButtonItem {
        static let sel_tintColor = "setTintColor:"
    }
}

extension UIBarButtonItem {
    
    public var theme_tintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .SEL_UIBarButtonItem.sel_tintColor)
        }
        get {
            return theme(for: .SEL_UIBarButtonItem.sel_tintColor) as? ThemeColor
        }
    }
}
