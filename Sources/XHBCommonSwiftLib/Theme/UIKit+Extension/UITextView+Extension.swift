//
//  UITextView+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate static let sel_font = "setFont:"
    fileprivate static let sel_textColor = "setTextColor:"
    fileprivate static let sel_attributedText = "setAttributedText:"
    fileprivate static let sel_keyboardAppearance = "setKeyboardAppearance:"
}

extension UITextView {
    
    public var theme_font: ThemeFont? {
        set {
            set(theme: newValue, for: .sel_font)
        }
        get {
            return theme(for: .sel_font) as? ThemeFont
        }
    }
    
    public var theme_textColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_textColor)
        }
        get {
            return theme(for: .sel_textColor) as? ThemeColor
        }
    }
    
    public var theme_attributedText: ThemeRichText? {
        set {
            set(theme: newValue, for: .sel_attributedText)
        }
        get {
            return theme(for: .sel_attributedText) as? ThemeRichText
        }
    }
    
    public var theme_keyboardAppearance: ThemeInt? {
        set {
            set(theme: newValue, for: .sel_keyboardAppearance)
        }
        get {
            return theme(for: .sel_keyboardAppearance) as? ThemeInt
        }
    }
}
