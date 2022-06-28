//
//  UISearchBar+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate static let sel_barStyle = "setBarStyle:"
    fileprivate static let sel_barTintColor = "setBarTintColor:"
    fileprivate static let sel_keyboardAppearance = "setKeyboardAppearance:"
}

extension UISearchBar {
    
    open var theme_barStyle: ThemeInt? {
        set {
            set(theme: newValue, for: .sel_barStyle)
        }
        get {
            return theme(for: .sel_barStyle) as? ThemeInt
        }
    }
    
    open var theme_barTintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_barTintColor)
        }
        get {
            return theme(for: .sel_barTintColor) as? ThemeColor
        }
    }
    
    open var theme_keyboardAppearance: ThemeInt? {
        set {
            set(theme: newValue, for: .sel_keyboardAppearance)
        }
        get {
            return theme(for: .sel_keyboardAppearance) as? ThemeInt
        }
    }
}
