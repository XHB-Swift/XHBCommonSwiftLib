//
//  UIView+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate static let sel_alpha = "setAlpha:"
    fileprivate static let sel_tintColor = "setTintColor:"
    fileprivate static let sel_backgroundColor = "setBackgroundColor:"
}

extension UIView {
    
    open var theme_alpha: ThemeCGFloat? {
        set {
            set(theme: newValue, for: .sel_alpha)
        }
        get {
            return theme(for: .sel_alpha) as? ThemeCGFloat
        }
    }
    
    open var theme_tintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_tintColor)
        }
        get {
            return theme(for: .sel_tintColor) as? ThemeColor
        }
    }
    
    open var theme_backgroundColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_backgroundColor)
        }
        get {
            return theme(for: .sel_backgroundColor) as? ThemeColor
        }
    }
}
