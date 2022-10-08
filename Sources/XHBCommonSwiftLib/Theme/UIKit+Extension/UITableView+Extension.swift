//
//  UITableView+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/27.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate static let sel_separatorColor = "setSeparatorColor:"
    fileprivate static let sel_sectionIndexColor = "setSectionIndexColor:"
    fileprivate static let sel_sectionIndexBackgroundColor = "setSectionIndexBackgroundColor:"
}

extension UITableView {
    
    public var theme_separatorColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_separatorColor)
        }
        get {
            return theme(for: .sel_separatorColor) as? ThemeColor
        }
    }
    
    public var theme_sectionIndexColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_sectionIndexColor)
        }
        get {
            return theme(for: .sel_sectionIndexColor) as? ThemeColor
        }
    }
    
    public var theme_sectionIndexBackgroundColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_sectionIndexBackgroundColor)
        }
        get {
            return theme(for: .sel_sectionIndexBackgroundColor) as? ThemeColor
        }
    }
    
}
