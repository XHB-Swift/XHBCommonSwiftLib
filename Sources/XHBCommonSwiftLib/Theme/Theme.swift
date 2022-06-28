//
//  Theme.swift
//  
//
//  Created by 谢鸿标 on 2022/6/27.
//

import UIKit
import XHBFoundationSwiftLib

open class Theme: Hashable {
    
    open var type = ""
    internal var theme: Any
    
    public init(value: Any, type: String = "") {
        theme = value
        self.type = type
    }
    
    open func toConcreteTheme() -> Any? {
        assert(false, "Subsclass must implement this method.")
        return theme
    }
    
    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.type == rhs.type
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
    }
}

extension Theme: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "type = \(type), theme = \(theme)"
    }
}

public final class ThemeInt: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? Int ?? 0
    }
}

public final class ThemeBool: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? Bool ?? false
    }
}

public final class ThemeText: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? String ?? ""
    }
}

public final class ThemeFont: Theme {
    
    public override func toConcreteTheme() -> Any? {
        guard let font = theme as? UIFont else { return nil }
        return font
    }
}

public final class ThemeColor: Theme {
    
    public var isCGColor = false
    
    public override func toConcreteTheme() -> Any? {
        guard let colorString = theme as? String else { return nil }
        let color = UIColor(argbHexString: colorString)
        return isCGColor ? color?.cgColor : color
    }
}

public final class ThemeImage: Theme {
    
    public override func toConcreteTheme() -> Any? {
        guard let imagePath = theme as? String else { return nil }
        return UIImage(contentsOfFile: imagePath)
    }
}

public final class ThemeCGFloat: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? CGFloat ?? 0.0
    }
}

public final class ThemeRichText: Theme {
    
    public override func toConcreteTheme() -> Any? {
        guard let richText = theme as? NSAttributedString else { return nil }
        return richText
    }
}

public final class ThemeState: Theme {
    
    public init(theme: Theme, for state: UInt) {
        super.init(value: [state : theme])
        set(theme: theme, for: state)
    }
    
    public func set(theme: Theme, for state: UInt) {
        guard var stateTheme = self.theme as? [UInt : Theme] else { return }
        stateTheme[state] = theme
    }
    
    public override func toConcreteTheme() -> Any? {
        return theme as? [UInt : Theme]
    }
}

public final class ThemeBlurEffect: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? UIBlurEffect
    }
}

public final class ThemeVisualEffect: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? UIVisualEffect
    }
}

@available(iOS 13.0, *)
public final class ThemeTabBarAppearance: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? UITabBarAppearance
    }
}

@available(iOS 13.0, *)
public final class ThemeNavigationBarAppearance: Theme {
    
    public override func toConcreteTheme() -> Any? {
        return theme as? UINavigationBarAppearance
    }
}
