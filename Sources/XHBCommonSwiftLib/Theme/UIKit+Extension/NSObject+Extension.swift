//
//  NSObject+Extension.swift
//  
//
//  Created by xiehongbiao on 2022/6/28.
//

import UIKit
import ObjectiveC
import XHBFoundationSwiftLib

extension Notification.Name {
    public static let ThemeDidUpdate: Notification.Name = .init(rawValue: "ThemeDidUpdateNotification")
}

fileprivate typealias imp_setObject =
@convention(c) (NSObject, Selector, AnyObject) -> Void

fileprivate typealias imp_setCGFloat =
@convention(c) (NSObject, Selector, CGFloat) -> Void

fileprivate typealias imp_setBarStyle =
@convention(c) (NSObject, Selector, UIBarStyle) -> Void

fileprivate typealias imp_setAlignment =
@convention(c) (NSObject, Selector, NSTextAlignment) -> Void

fileprivate typealias imp_setValueForState =
@convention(c) (NSObject, Selector, AnyObject, UIControl.State) -> Void

fileprivate typealias imp_setKeyboardAppearance =
@convention(c) (NSObject, Selector, UIKeyboardAppearance) -> Void

fileprivate typealias imp_setScrollViewIndicatorStyle =
@convention(c) (NSObject, Selector, UIScrollView.IndicatorStyle) -> Void

fileprivate typealias imp_setActivityViewIndicatorStyle =
@convention(c) (NSObject, Selector, UIActivityIndicatorView.Style) -> Void

extension NotificationCenter {
    
    private static var ThemeObserverKey: Void?
    
    private var themeObservers: Set<NSObject> {
        set {
            objc_setAssociatedObject(self, &Self.ThemeObserverKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let observers = objc_getAssociatedObject(self, &Self.ThemeObserverKey) as? Set<NSObject> {
                return observers
            }
            let emptyObservers = Set<NSObject>()
            objc_setAssociatedObject(self, &Self.ThemeObserverKey, emptyObservers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return emptyObservers
        }
    }
    
    public func add(themeObserver: NSObject, selector: Selector, name: Notification.Name) {
        guard !themeObservers.contains(themeObserver) else { return }
        addObserver(themeObserver, selector: selector, name: name, object: nil)
        themeObservers.insert(themeObserver)
    }
    
    public func remove(themeObserver: NSObject, name: Notification.Name? = nil) {
        guard themeObservers.contains(themeObserver) else { return }
        removeObserver(themeObserver, name: name, object: nil)
        themeObservers.remove(themeObserver)
    }
    
    public func removeAllThemeObservers() {
        if themeObservers.isEmpty { return }
        themeObservers.forEach { themeObserver in
            removeObserver(themeObserver)
        }
        themeObservers.removeAll()
    }
}

extension NSObject {
    
    private static var ThemeUpdateKey: Void?
    private static var ThemeTypeCurrentKey: Void?
    
    private var themeInfo: [String:Set<Theme>] {
        set {
            objc_setAssociatedObject(self, &NSObject.ThemeUpdateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let themeInfo = objc_getAssociatedObject(self, &NSObject.ThemeUpdateKey) as? [String:Set<Theme>] {
                return themeInfo
            }
            NotificationCenter.default.add(themeObserver: self,
                                           selector: #selector(themeShouldUpdate(_:)),
                                           name: .ThemeDidUpdate)
            let emptyInfo = [String:Set<Theme>]()
            objc_setAssociatedObject(self, &NSObject.ThemeUpdateKey, emptyInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return emptyInfo
        }
    }
    
    public var currentThemeType: String {
        set {
            let themeType = objc_getAssociatedObject(self, &NSObject.ThemeTypeCurrentKey) as? String
            objc_setAssociatedObject(self, &NSObject.ThemeTypeCurrentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if (themeType ?? "") != newValue {
                NotificationCenter.default.post(name: .ThemeDidUpdate, object: newValue)
            }
        }
        get {
            if let themeType = objc_getAssociatedObject(self, &NSObject.ThemeTypeCurrentKey) as? String {
                return themeType
            }
            objc_setAssociatedObject(self, &NSObject.ThemeTypeCurrentKey, "", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return ""
        }
    }
    
    public func set(theme: Theme?, for selector: String) {
        guard let theme = theme else { return }
        if theme.type == currentThemeType {
            update(theme: theme, key: selector)
        }
        guard var themes = themeInfo[selector] else {
            themeInfo[selector] = Set<Theme>(arrayLiteral: theme)
            return
        }
        themes.insert(theme)
        themeInfo[selector] = themes
    }
    
    public func theme(for selector: String) -> Theme? {
        guard let themes = themeInfo[selector] else {
            return nil
        }
        return themes.filter { $0.type == currentThemeType }.first
    }
    
    public func update(theme: Theme?, key: String) {
        guard let theme = theme else { return }
        let selector = Selector(key)
        guard responds(to: selector) else { return }
        guard let themeEffect = theme.toConcreteTheme() else { return }
        guard let method = method(for: selector) else { return }
        
        if let stateThemes = themeEffect as? Dictionary<UInt, Theme> {
            let setState = unsafeBitCast(method, to: imp_setValueForState.self)
            for stateTheme in stateThemes {
                let state = UIControl.State(rawValue: stateTheme.key)
                guard let result = stateTheme.value.toConcreteTheme() as? AnyObject
                else { continue }
                setState(self, selector, result, state)
            }
        } else if theme is ThemeFont ||
                  theme is ThemeText ||
                  theme is ThemeColor ||
                  theme is ThemeImage ||
                  theme is ThemeRichText {
            let setObject = unsafeBitCast(method, to: imp_setObject.self)
            setObject(self, selector, themeEffect as AnyObject)
        } else if let style = themeEffect as? Int {
            if self is UIScrollView,
                let s = UIScrollView.IndicatorStyle(rawValue: style) {
                let setScrollViewIndicatorStyle = unsafeBitCast(method,
                                                                to: imp_setScrollViewIndicatorStyle.self)
                setScrollViewIndicatorStyle(self, selector, s)
            } else if self is UIActivityIndicatorView,
                      let s = UIActivityIndicatorView.Style(rawValue: style) {
                let setActivityIndicatorStyle = unsafeBitCast(method,
                                                              to: imp_setActivityViewIndicatorStyle.self)
                setActivityIndicatorStyle(self, selector, s)
            }
        } else if let floatTheme = themeEffect as? CGFloat {
            let setCGFloat = unsafeBitCast(method, to: imp_setCGFloat.self)
            setCGFloat(self, selector, floatTheme)
        }
    }
    
    @objc private func themeShouldUpdate(_ sender: Notification) {
        guard let newThemeType = sender.object as? String else { return }
        themeInfo.forEach { (key, themes) in
            guard let theme = themes.filter({ $0.type == newThemeType }).first else { return }
            UIView.animate(withDuration: 0.5) {
                self.update(theme: theme, key: key)
            }
        }
    }
}
