//
//  UITabBarItem+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate static let sel_selectedImage = "setSelectedImage:"
}

extension UITabBarItem {
    
    public var theme_selectedImage: ThemeImage? {
        set {
            set(theme: newValue, for: .sel_selectedImage)
        }
        get {
            return theme(for: .sel_selectedImage) as? ThemeImage
        }
    }
}
