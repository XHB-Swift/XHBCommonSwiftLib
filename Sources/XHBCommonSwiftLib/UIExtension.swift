//
//  UIExtension.swift
//  
//
//  Created by 谢鸿标 on 2022/6/15.
//

import ObjectiveC

@frozen public struct ColorData {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red / 255.0
        self.green = green / 255.0
        self.blue = blue / 255.0
        self.alpha = max(min(alpha, 1), 0)
    }
    
    public init?(hexString: String, alpha: Double = 1.0) {
        var fixedHexStr = hexString
        if hexString.hasPrefix("#") {
            guard let fixedHex = hexString[(1..<hexString.count-1)] else { return nil }
            if fixedHex.count != 6 && fixedHex.count != 8 {
                return nil
            }
            fixedHexStr = fixedHex
        }
        
        do {
            let regex = try NSRegularExpression(pattern: "[^a-fA-F|0-9]", options: [])
            let match = regex.numberOfMatches(in: fixedHexStr, options: [.reportCompletion], range: NSRange(location: 0, length: fixedHexStr.count))
            if match != 0 {
                return nil
            }
            self.init(argbHexString: fixedHexStr)
        } catch {
            return nil
        }
    }
    
    public init?(argbHexString: String) {
        var argbHex = argbHexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if argbHex.hasPrefix("#") {
            guard let fixedHex = argbHex[(1..<argbHex.count-1)] else { return nil }
            if fixedHex.count != 6 || fixedHex.count != 8 {
                return nil
            }
            argbHex = fixedHex
        }
        
        if argbHex.count == 8 {
            let a = Double(argbHex[(0..<2)]?.hexStringToInt ?? 0)
            let r = Double(argbHex[(2..<4)]?.hexStringToInt ?? 0)
            let g = Double(argbHex[(4..<6)]?.hexStringToInt ?? 0)
            let b = Double(argbHex[(6..<8)]?.hexStringToInt ?? 0)
            self.init(red: r, green: g, blue: b, alpha: a)
        }else if argbHex.count == 6 {
            let r = Double(argbHex[(0..<2)]?.hexStringToInt ?? 0)
            let g = Double(argbHex[(2..<4)]?.hexStringToInt ?? 0)
            let b = Double(argbHex[(4..<6)]?.hexStringToInt ?? 0)
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        }else {
            return nil
        }
    }
    
    public static var randomColor: Self {
        let red = Double(arc4random() % 256)
        let green = Double(arc4random() % 256)
        let blue = Double(arc4random() % 256)
        return ColorData(red: red, green: green, blue: blue)
    }
}

extension ColorData {
    
    var argbHexString: String? {
        guard let rgbStr = rgbHexString else { return nil }
        return "\(String(format: "%02X", Int(rgbStr.1 * 255.0)))\(rgbStr.0)"
    }
    
    var rgbHexString: (String, Double)? {
        var rStr = String(Int(255.0 * red), radix: 16),
            gStr = String(Int(255.0 * green), radix: 16),
            bStr = String(Int(255.0 * blue), radix: 16)
        rStr = (rStr.count == 1) ? "0\(rStr)" : rStr
        gStr = (gStr.count == 1) ? "0\(gStr)" : gStr
        bStr = (bStr.count == 1) ? "0\(bStr)" : bStr
        let rgb = "\(rStr)\(gStr)\(bStr)"
        return (rgb,alpha)
    }
}

#if os(iOS)

import UIKit

extension UIView {
    
    open var x: CGFloat {
        
        set {
            self.frame.origin.x = newValue
        }
        
        get {
            return self.frame.minX
        }
    }
    
    open var y: CGFloat {
        
        set {
            self.frame.origin.y = newValue
        }
        
        get {
            return self.frame.minY
        }
        
    }
    
    open var midX: CGFloat {
        
        set {
            self.frame.origin.x = newValue - self.frame.width / 2
        }
        
        get {
            return self.frame.midX
        }
    }
    
    open var midY: CGFloat {
        
        set {
            self.frame.origin.y = newValue - self.frame.height / 2
        }
        
        get {
            return self.frame.midY
        }
    }
    
    open var right: CGFloat {
        
        set {
            self.frame.origin.x = newValue - self.frame.width
        }
        
        get {
            return self.frame.maxX
        }
    }
    
    open var bottom: CGFloat {
        
        set {
            self.frame.origin.y = newValue - self.frame.height
        }
        
        get {
            return self.frame.maxY
        }
    }
    
    open var width: CGFloat {
        
        set {
            self.frame.size.width = newValue
        }
        
        get {
            return self.frame.width
        }
    }
    
    open var height: CGFloat {
        
        set {
            self.frame.size.height = newValue
        }
        
        get {
            return self.frame.height
        }
    }
    
    open var origin: CGPoint {
        
        set {
            self.frame.origin = newValue
        }
        
        get {
            return self.frame.origin
        }
    }
    
    open var size: CGSize {
        
        set {
            self.frame.size = newValue
        }
        
        get {
            return self.frame.size
        }
    }
    
    open var centerX: CGFloat {
        
        set {
            self.center.x = newValue
        }
        
        get {
            return self.center.x
        }
    }
    
    open var centerY: CGFloat {
        
        set {
            self.center.y = newValue
        }
        
        get {
            return self.center.y
        }
    }
    
    private(set) var levelWieght: Int? {
        set {
            objc_setAssociatedObject(self, "levelWieght", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, "levelWieght") as? Int
        }
    }
    
    open func add(subview: UIView, for levelWeight: Int) {
        if subviews.contains(subview) {
            subview.removeFromSuperview()
        }
        subview.levelWieght = levelWeight
        let reversedSubviews = subviews.reversed()
        var belowView: UIView?
        for view in reversedSubviews {
            guard let view_level_weight = view.levelWieght else { continue }
            if view_level_weight > levelWeight {
                belowView = view
            }else {
                insertSubview(subview, aboveSubview: view)
                break
            }
        }
        if subview.superview == nil {
            if let belowView = belowView {
                insertSubview(subview, belowSubview: belowView)
            }else {
                addSubview(subview)
            }
        }
    }
}

extension UIButton {
    
    public convenience init(type: UIButton.ButtonType = .custom,
                            target: Any?,
                            action: Selector,
                            for controlEvents: UIControl.Event = .touchUpInside) {
        self.init(type: type)
        addTarget(target, action: action, for: controlEvents)
    }
}

extension UIWindow {
    
    open class var currentWindow: UIWindow? {
        
        let app = UIApplication.shared
        
        if #available(iOS 13.0, *) {
            
            if #available(iOS 15.0, *) {
                
                return app.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .first?.keyWindow
                
            }else {
                
                return app.windows.first(where: { $0.isKeyWindow })
            }
            
        }else {
            
            return app.keyWindow
        }
    }
    
}

extension UIResponder {
    
    @objc public func responds(from sender: UIResponder, value: Any?, event name: String) {
        next?.responds(from: sender, value: value, event: name)
    }
}

extension CGFloat {
    public static let pi_2 = pi / 2
    public static let pi_3 = pi / 3
    public static let pi_4 = pi / 4
    public static let pi_6 = pi / 6
    public static let m_2_pi = pi * 2
}

extension ColorData {
    
    public var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

#else

import AppKit

extension ColorData {
    
    public var nsColor: NSColor {
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

#endif





