//
//  UIButton+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate struct SEL_UIButton {
        static let sel_setImageForState = "setImage:forState:"
        static let sel_setTitleForState = "setTitle:forState:"
        static let sel_setTitleColorForState = "setTitleColor:forState:"
        static let sel_setAttributedTitleForState = "setAttributedTitle:forState:"
        static let sel_setBackgroundImageForState = "setBackgroundImage:forState:"
    }
}

extension UIButton {
    
    open var theme_titleState: ThemeState? {
        set {
            set(theme: newValue, for: .SEL_UIButton.sel_setTitleForState)
        }
        get {
            return theme(for: .SEL_UIButton.sel_setTitleForState) as? ThemeState
        }
    }
    
    open var theme_imageState: ThemeState? {
        set {
            set(theme: newValue, for: .SEL_UIButton.sel_setImageForState)
        }
        get {
            return theme(for: .SEL_UIButton.sel_setImageForState) as? ThemeState
        }
    }
    
    open var theme_richTextState: ThemeState? {
        set {
            set(theme: newValue, for: .SEL_UIButton.sel_setAttributedTitleForState)
        }
        get {
            return theme(for: .SEL_UIButton.sel_setAttributedTitleForState) as? ThemeState
        }
    }
    
    open var theme_backgroundImageState: ThemeState? {
        set {
            set(theme: newValue, for: .SEL_UIButton.sel_setBackgroundImageForState)
        }
        get {
            return theme(for: .SEL_UIButton.sel_setBackgroundImageForState) as? ThemeState
        }
    }
}
