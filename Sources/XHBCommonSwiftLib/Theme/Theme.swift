//
//  Theme.swift
//  CodeRecord-Swift
//
//  Created by xiehongbiao on 2021/9/8.
//  Copyright © 2021 谢鸿标. All rights reserved.
//

import UIKit

extension String {
    
    public static let dark = "dark"
    public static let light = "light"
}

@objc public protocol ThemeUpdatable {
    
    @objc func theme_effect(for style: String, theme: AnyObject?)
}

open class Theme {
    
    //表示该主题针对view的哪个属性
    fileprivate var property: AnyKeyPath?
    
    fileprivate var style: ThemeStyle
    
    public init(style: ThemeStyle) {
        self.style = style
    }
    
    public init(property: AnyKeyPath, style: ThemeStyle) {
        self.property = property
        self.style = style
    }
}

fileprivate class ThemeObject {
    
    fileprivate var viewId: String
    fileprivate weak var view: ThemeUpdatable?
    fileprivate var themeInfo = Dictionary<String, Theme>()
    
    public init(viewId: String) {
        self.viewId = viewId
    }
    
    fileprivate func update(style: String) {
        guard let theme = themeInfo[style] else { return }
        view?.theme_effect(for: style, theme: theme)
    }
    
    deinit {
        themeInfo.removeAll()
    }
}

fileprivate class ThemeScene {
    
    fileprivate var sceneId: String
    fileprivate var themeObjects = Dictionary<String, ThemeObject>()
    
    public init(sceneId: String) {
        self.sceneId = sceneId
    }
    
    public func update(style: String) {
        themeObjects.forEach { key, value in
            value.update(style: style)
        }
    }
    
    deinit {
        themeObjects.removeAll()
    }
}

open class ThemeManager {
    
    private init() {}
    public static let shared = ThemeManager()
    private var themeScenes = Dictionary<String, ThemeScene>()
    
    open func set(theme: Theme, style: String, for view: ThemeUpdatable, in scene: Any) {
        
        let viewId = "\(view)"
        let sceneId = "\(scene)"
        if let themeScene = themeScenes[sceneId] {
            if let themeObject = themeScene.themeObjects[viewId] {
                themeObject.themeInfo[style] = theme
            }else {
                let themeObject = ThemeObject(viewId: viewId)
                themeObject.view = view
                themeObject.themeInfo[style] = theme
                themeScene.themeObjects[viewId] = themeObject
            }
        }else {
            let themeScene = ThemeScene(sceneId: sceneId)
            let themeObject = ThemeObject(viewId: viewId)
            themeObject.view = view
            themeObject.themeInfo[style] = theme
            themeScene.themeObjects[viewId] = themeObject
            themeScenes[sceneId] = themeScene
        }
    }
    
    open func clean(in scene: Any) {
        _ = themeScenes.removeValue(forKey: "\(scene)")
    }
    
    open func clean(for view: ThemeUpdatable, in scene: Any) {
        guard let themeScene = themeScenes["\(scene)"] else { return }
        _ = themeScene.themeObjects.removeValue(forKey: "\(view)")
    }
    
    open func cleanAll() {
        themeScenes.removeAll()
    }
    
    open func switchTo(style: String) {
        themeScenes.forEach { key, value in
            value.update(style: style)
        }
    }
}
