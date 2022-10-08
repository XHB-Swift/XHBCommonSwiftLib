//
//  UIBarItem+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate struct SEL_UIBarItem {
        static let sel_setImage = "setImage:"
        static let sel_setTitleTextAttributesForState = "setTitleTextAttributes:forState:"
    }
}

extension UIBarItem {
    
    public var theme_image: ThemeImage? {
        set {
            set(theme: newValue, for: .SEL_UIBarItem.sel_setImage)
        }
        get {
            return theme(for: .SEL_UIBarItem.sel_setImage) as? ThemeImage
        }
    }
    
    public var theme_titleTextAttributesForState: ThemeState? {
        set {
            set(theme: newValue, for: .SEL_UIBarItem.sel_setTitleTextAttributesForState)
        }
        get {
            return theme(for: .SEL_UIBarItem.sel_setTitleTextAttributesForState) as? ThemeState
        }
    }
}
