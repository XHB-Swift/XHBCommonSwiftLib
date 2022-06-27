//
//  Theme.swift
//  
//
//  Created by 谢鸿标 on 2022/6/27.
//

import UIKit
import XHBFoundationSwiftLib

open class Theme: NSObject {
    
    internal var theme = [String:Any]()
    
    public convenience init(style: String, value: Any) {
        self.init()
        theme[style] = value
    }
    
    open func set(value: Any, for style: String) {
        theme[style] = value
    }
    
    open func toConcreteTheme(for style: String) -> Any? {
        assert(false, "Subsclass must implement this method.")
        return nil
    }
}

open class ThemeInt: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        return theme[style] as? Int ?? 0
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? Int else { return }
        theme[style] = v
    }
}

open class ThemeBool: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        return theme[style] as? Bool ?? false
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? Bool else { return }
        theme[style] = v
    }
}

open class ThemeText: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        return theme[style] as? String ?? ""
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? String else { return }
        theme[style] = v
    }
}

open class ThemeFont: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        guard let font = theme[style] as? UIFont else { return nil }
        return font
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? UIFont else { return }
        theme[style] = v
    }
}

open class ThemeColor: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        guard let colorString = theme[style] as? String else { return nil }
        return UIColor(argbHexString: colorString)
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? UIColor else { return }
        theme[style] = v
    }
}

open class ThemeImage: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        guard let imagePath = theme[style] as? String else { return nil }
        return UIImage(contentsOfFile: imagePath)
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? String else { return }
        theme[style] = v
    }
}

open class ThemeCGFloat: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        return theme[style] as? CGFloat ?? 0.0
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? CGFloat else { return }
        theme[style] = v
    }
}

open class ThemeRichText: Theme {
    
    open override func toConcreteTheme(for style: String) -> Any? {
        guard let richText = theme[style] as? NSAttributedString else { return nil }
        return richText
    }
    open override func set(value: Any, for style: String) {
        guard let v = value as? NSAttributedString else { return }
        theme[style] = v
    }
}

open class ThemeState: Theme {
    
    internal var stateTheme: (Theme, ThemeInt)
    
    public init(stateTheme: (Theme, ThemeInt)) {
        self.stateTheme = stateTheme
    }
    
    open override func toConcreteTheme(for style: String) -> Any? {
        guard let theme = stateTheme.0.toConcreteTheme(for: style),
              let state = stateTheme.1.toConcreteTheme(for: style) else { return nil }
        
        return (theme, state)
    }
}
