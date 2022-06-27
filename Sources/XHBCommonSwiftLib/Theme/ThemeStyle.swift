//
//  File.swift
//  
//
//  Created by xiehongbiao on 2022/6/27.
//

import UIKit

public protocol ThemeStyle {
    func toAttribute() -> ThemeAttribute?
}

public struct ColorStyle: ThemeStyle {
    
    public var color: String?
    public var alpha: CGFloat?
    
    public init(color: String, alpha: CGFloat) {
        self.color = color
        self.alpha = alpha
    }
    
    public func toAttribute() -> ThemeAttribute? {
        
        guard let colorStr = color else { return nil }
        return UIColor(hexString: colorStr, alpha: alpha ?? 1)
    }
}

public struct FontStyle: ThemeStyle {
    
    public var fontName: String?
    public var fontSize: CGFloat?
    
    public init(fontName: String, fontSize: CGFloat) {
        self.fontName = fontName
        self.fontSize = fontSize
    }
    
    public func toAttribute() -> ThemeAttribute? {
        guard let name = fontName, let size = fontSize else { return nil }
        return UIFont(name: name, size: size)
    }
}

//如果是网络图片，先下载到本地，再将本地资源路径设置，UIImage属于大内存的资源，不应该大量持有
public struct ImageStyle: ThemeStyle {
    
    public var localPath: String?
    
    public init(localPath: String) {
        self.localPath = localPath
    }
    
    public func toAttribute() -> ThemeAttribute? {
        guard let path = localPath else { return nil }
        return UIImage(contentsOfFile: path)
    }
}

public struct RichTextStyle: ThemeStyle {
    
    public typealias RichTextAttributes = [NSAttributedString.Key : Any]
    public var string: String?
    public var attributes: [NSAttributedString.Key:ThemeStyle]?
    
    public func toAttribute() -> ThemeAttribute? {
        guard let str = string else { return nil }
        var attributes0 = RichTextAttributes()
        attributes?.forEach({ key, value in
            guard let v = value.toAttribute() else { return }
            attributes0[key] = v
        })
        return NSAttributedString(string: str, attributes: attributes0)
    }
}

public struct StateStyle: ThemeStyle {
    
    public var selector: Selector
    public var params: [UInt : Any]?
    
    public init(selector: Selector) {
        self.selector = selector
    }
    
    public func toAttribute() -> ThemeAttribute? {
        return selector
    }
}
