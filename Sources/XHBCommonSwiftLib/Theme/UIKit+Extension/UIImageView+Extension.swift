//
//  UIImageView+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate struct SEL_UIImageView {
        static let sel_setImage = "setImage:"
    }
}

extension UIImageView {
    
    public var theme_image: ThemeImage? {
        set {
            set(theme: newValue, for: .SEL_UIImageView.sel_setImage)
        }
        get {
            return theme(for: .SEL_UIImageView.sel_setImage) as? ThemeImage
        }
    }
}
