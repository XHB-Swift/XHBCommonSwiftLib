//
//  UILabel+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate struct SEL_UILabel {
        static let sel_text = "setText:"
        static let sel_font = "setFont:"
        static let sel_textColor = "setTextColor:"
        static let sel_hightedTextColor = "setHightedTextColor:"
        static let sel_shadowColor = "setShadowColor:"
        static let sel_attributedText = "setAttributedText:"
        static let sel_textAlignment = "setTextAlignment:"
    }
}

extension UILabel {
    
    public var theme_text: ThemeText? {
        set {
            set(theme: newValue, for: .SEL_UILabel.sel_text)
        }
        get {
            return theme(for: .SEL_UILabel.sel_text) as? ThemeText
        }
    }
    
    public var theme_font: ThemeFont? {
        set {
            set(theme: newValue, for: .SEL_UILabel.sel_font)
        }
        get {
            return theme(for: .SEL_UILabel.sel_font) as? ThemeFont
        }
    }
    
    public var theme_richText: ThemeRichText? {
        set {
            set(theme: newValue, for: .SEL_UILabel.sel_attributedText)
        }
        get {
            return theme(for: .SEL_UILabel.sel_attributedText) as? ThemeRichText
        }
    }
    
    public var theme_alignment: ThemeInt? {
        set {
            set(theme: newValue, for: .SEL_UILabel.sel_textAlignment)
        }
        get {
            return theme(for: .SEL_UILabel.sel_textAlignment) as? ThemeInt
        }
    }
    
    public var theme_textColor: ThemeColor? {
        set {
            set(theme: newValue, for: .SEL_UILabel.sel_textColor)
        }
        get {
            return theme(for: .SEL_UILabel.sel_textColor) as? ThemeColor
        }
    }
}
