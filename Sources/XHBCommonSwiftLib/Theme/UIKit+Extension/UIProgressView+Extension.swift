//
//  UIProgressView+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension String {
    fileprivate static let sel_trackTintColor = "setTrackTintColor:"
    fileprivate static let sel_progressTintColor = "setProgressTintColor:"
}

extension UIProgressView {
    
    public var theme_trackTintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_trackTintColor)
        }
        get {
            return theme(for: .sel_trackTintColor) as? ThemeColor
        }
    }
    
    public var theme_progressTintColor: ThemeColor? {
        set {
            set(theme: newValue, for: .sel_progressTintColor)
        }
        get {
            return theme(for: .sel_progressTintColor) as? ThemeColor
        }
    }
}
