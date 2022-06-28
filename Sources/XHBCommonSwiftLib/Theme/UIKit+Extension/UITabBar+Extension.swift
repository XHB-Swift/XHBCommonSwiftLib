//
//  UITabBar+Extension.swift
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
    fileprivate static let sel_unselectedItemTintColor = "setUnselectedItemTintColor:"
    
    @available(iOS 13.0, *)
    fileprivate static let sel_compactAppearance = "setCompactAppearance:"
    
    @available(iOS 13.0, *)
    fileprivate static let sel_standardAppearance = "setStandardAppearance:"
    
    @available(iOS 13.0, *)
    fileprivate static let sel_scrollEdgeAppearance = "setScrollEdgeAppearance:"
}

extension UITabBar {
    
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
    
    open var theme_unselectedItemTintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_unselectedItemTintColor)
        }
        get {
            return theme(for: .sel_unselectedItemTintColor) as? ThemeColor
        }
    }
    
    @available(iOS 13.0, *)
    open var theme_standardAppearance: ThemeTabBarAppearance? {
        set {
            set(theme: newValue, for: .sel_standardAppearance)
        }
        get {
            return theme(for: .sel_standardAppearance) as? ThemeTabBarAppearance
        }
    }
    
    @available(iOS 13.0, *)
    open var theme_compactAppearance: ThemeTabBarAppearance? {
        set {
            set(theme: newValue, for: .sel_compactAppearance)
        }
        get {
            return theme(for: .sel_compactAppearance) as? ThemeTabBarAppearance
        }
    }
    
    @available(iOS 13.0, *)
    open var theme_scrollEdgeAppearance: ThemeTabBarAppearance? {
        set {
            set(theme: newValue, for: .sel_scrollEdgeAppearance)
        }
        get {
            return theme(for: .sel_scrollEdgeAppearance) as? ThemeTabBarAppearance
        }
    }
}
