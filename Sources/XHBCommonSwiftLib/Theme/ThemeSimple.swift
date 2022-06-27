//
//  ThemeSimple.swift
//  
//
//  Created by xiehongbiao on 2022/6/27.
//

import UIKit

public protocol ThemeSimple: ThemeAttribute, ThemeStyle {}
extension ThemeSimple {
    public func toAttribute() -> ThemeAttribute? { return self }
}

extension Int: ThemeSimple {}
extension String: ThemeSimple {}
extension CGFloat: ThemeSimple {}
extension UIBarStyle: ThemeSimple {}
extension Dictionary: ThemeSimple {}
extension UIStatusBarStyle: ThemeSimple {}
