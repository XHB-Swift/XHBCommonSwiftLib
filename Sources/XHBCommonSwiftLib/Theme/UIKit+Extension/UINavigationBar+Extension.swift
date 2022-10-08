//
//  UINavigationBar+Extension.swift
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
    fileprivate static let sel_titleTextAttributes = "setTitleTextAttributes:"
    fileprivate static let sel_largeTitleTextAttributes = "setLargeTitleTextAttributes:"
    
    @available(iOS 13.0, *)
    fileprivate static let sel_compactAppearance = "setCompactAppearance:"
    
    @available(iOS 13.0, *)
    fileprivate static let sel_standardAppearance = "setStandardAppearance:"
    
    @available(iOS 13.0, *)
    fileprivate static let sel_scrollEdgeAppearance = "setScrollEdgeAppearance:"
    
}

extension UINavigationBar {
    
    public var theme_barStyle: ThemeInt? {
        set {
            set(theme: newValue, for: .sel_barStyle)
        }
        get {
            return theme(for: .sel_barStyle) as? ThemeInt
        }
    }
    
    public var theme_barTintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_barTintColor)
        }
        get {
            return theme(for: .sel_barTintColor) as? ThemeColor
        }
    }
    
    public var theme_titleTextAttributes: ThemeRichText? {
        set {
            set(theme: newValue, for: .sel_titleTextAttributes)
        }
        get {
            return theme(for: .sel_titleTextAttributes) as? ThemeRichText
        }
    }
    
    public var theme_largeTitleTextAttributes: ThemeRichText? {
        set {
            set(theme: newValue, for: .sel_largeTitleTextAttributes)
        }
        get {
            return theme(for: .sel_largeTitleTextAttributes) as? ThemeRichText
        }
    }
    
    @available(iOS 13.0, *)
    public var theme_standardAppearance: ThemeNavigationBarAppearance? {
        set {
            set(theme: newValue, for: .sel_standardAppearance)
        }
        get {
            return theme(for: .sel_standardAppearance) as? ThemeNavigationBarAppearance
        }
    }
    
    @available(iOS 13.0, *)
    public var theme_compactAppearance: ThemeNavigationBarAppearance? {
        set {
            set(theme: newValue, for: .sel_compactAppearance)
        }
        get {
            return theme(for: .sel_compactAppearance) as? ThemeNavigationBarAppearance
        }
    }
    
    @available(iOS 13.0, *)
    public var theme_scrollEdgeAppearance: ThemeNavigationBarAppearance? {
        set {
            set(theme: newValue, for: .sel_scrollEdgeAppearance)
        }
        get {
            return theme(for: .sel_scrollEdgeAppearance) as? ThemeNavigationBarAppearance
        }
    }
}
