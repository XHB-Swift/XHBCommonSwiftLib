//
//  UIKit+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/27.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension Notification.Name {
    public static let ThemeDidUpdate: Notification.Name = .init(rawValue: "ThemeDidUpdateNotification")
}

extension NSObject {
    
    private static var ThemeUpdateKey: Void?
    
    open var themeInfo: [String:Theme] {
        set {
            objc_setAssociatedObject(self, &NSObject.ThemeUpdateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let themeInfo = objc_getAssociatedObject(self, &NSObject.ThemeUpdateKey) as? [String:Theme] {
                return themeInfo
            }
            let emptyInfo = [String:Theme]()
            objc_setAssociatedObject(self, &NSObject.ThemeUpdateKey, emptyInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return emptyInfo
        }
    }
    
    open func registerThemeUpdate() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeShouldUpdate(_:)),
                                               name: .ThemeDidUpdate,
                                               object: nil)
    }
    
    open func unregisterThemeUpdate() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc open func update(theme: Theme, key: String, style: String) {
        
    }
    
    @objc private func themeShouldUpdate(_ sender: Notification) {
        guard let style = sender.object as? String else { return }
        for (key, theme) in themeInfo {
            update(theme: theme, key: key, style: style)
        }
    }
}

extension UIView {
    
    open var theme_backgroundColor: ThemeColor? {
        set {
            themeInfo["backgroundColor"] = newValue
        }
        get {
            return themeInfo["backgroundColor"] as? ThemeColor
        }
    }
    
    open var theme_alpha: ThemeCGFloat? {
        set {
            themeInfo["alpha"] = newValue
        }
        get {
            return themeInfo["alpha"] as? ThemeCGFloat
        }
    }
    
    open var theme_tintColor: ThemeColor? {
        set {
            themeInfo["tintColor"] = newValue
        }
        get {
            return themeInfo["tintColor"] as? ThemeColor
        }
    }
    
    open override func update(theme: Theme, key: String, style: String) {
        let t = theme.toConcreteTheme(for: style)
        if let color = t as? UIColor {
            
            if key == "tintColor" {
                self.tintColor = color
            } else {
                self.backgroundColor = color
            }
        } else if let alpha = t as? CGFloat {
            
            self.alpha = alpha
        }
    }
}

extension UILabel {
    
    open var theme_text: ThemeText? {
        set {
            themeInfo["text"] = newValue
        }
        get {
            return themeInfo["text"] as? ThemeText
        }
    }
    
    open var theme_font: ThemeFont? {
        set {
            themeInfo["font"] = newValue
        }
        get {
            return themeInfo["font"] as? ThemeFont
        }
    }
    
    open var theme_richText: ThemeRichText? {
        set {
            themeInfo["richText"] = newValue
        }
        get {
            return themeInfo["richText"] as? ThemeRichText
        }
    }
    
    open var theme_alignment: ThemeInt? {
        set {
            themeInfo["alignment"] = newValue
        }
        get {
            return themeInfo["alignment"] as? ThemeInt
        }
    }
    
    open var theme_textColor: ThemeColor? {
        set {
            themeInfo["textColor"] = newValue
        }
        get {
            return themeInfo["textColor"] as? ThemeColor
        }
    }
    
    open override func update(theme: Theme, key: String, style: String) {
        let t = theme.toConcreteTheme(for: style)
        if let text = t as? String {
            self.text = text
        } else if let richText = t as? NSAttributedString {
            self.attributedText = richText
        } else if let font = t as? UIFont {
            self.font = font
        } else if let i = t as? Int,
                  let alignment = NSTextAlignment(rawValue: i) {
            self.textAlignment = alignment
        } else {
            super.update(theme: theme, key: key, style: style)
            if key == "textColor",
               let textColor = t as? UIColor {
                self.textColor = textColor
            }
        }
    }
}

extension UIButton {
    
    open var theme_titleState: ThemeState? {
        set {
            themeInfo["setTitleForState"] = newValue
        }
        get {
            return themeInfo["setTitleForState"] as? ThemeState
        }
    }
    
    open var theme_imageState: ThemeState? {
        set {
            themeInfo["setImageForState"] = newValue
        }
        get {
            return themeInfo["setImageForState"] as? ThemeState
        }
    }
    
    open var theme_richTextState: ThemeState? {
        set {
            themeInfo["setAttributedTextForState"] = newValue
        }
        get {
            return themeInfo["setAttributedTextForState"] as? ThemeState
        }
    }
    
    open var theme_backgroundImageState: ThemeState? {
        set {
            themeInfo["setBackgroundImageForState"] = newValue
        }
        get {
            return themeInfo["setBackgroundImageForState"] as? ThemeState
        }
    }
    
    open override func update(theme: Theme, key: String, style: String) {
        super.update(theme: theme, key: key, style: style)
        let t = theme.toConcreteTheme(for: style)
        guard let result = t as? (Any, Int) else { return }
        let state = UIControl.State(rawValue: UInt(result.1))
        if key == "setTitleForState",
           let text = result.0 as? String {
            self.setTitle(text, for: state)
        } else if key == "setImageForState",
                  let image = result.0 as? UIImage {
            self.setImage(image, for: state)
        } else if key == "setAttributedTextState",
                  let richText = result.0 as? NSAttributedString {
            self.setAttributedTitle(richText, for: state)
        } else if key == "setBackgroundImageForState",
                  let image = result.0 as? UIImage {
            self.setBackgroundImage(image, for: state)
        }
    }
}

extension UIImageView {
    
    open var theme_image: ThemeImage? {
        set {
            themeInfo["image"] = newValue
        }
        get {
            return themeInfo["image"] as? ThemeImage
        }
    }
    
    open override func update(theme: Theme, key: String, style: String) {
        super.update(theme: theme, key: key, style: style)
        let t = theme.toConcreteTheme(for: style)
        if let img = t as? UIImage {
            self.image = img
        }
    }
    
}

extension UIBarItem {
    
}

extension UINavigationBar {
    
    
}
