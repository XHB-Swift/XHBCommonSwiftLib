//
//  ThemeAttribute.swift
//  
//
//  Created by xiehongbiao on 2022/6/27.
//

import UIKit

public protocol ThemeAttribute {}

extension UIFont: ThemeAttribute {}
extension UIImage: ThemeAttribute {}
extension UIColor: ThemeAttribute {}
extension Selector: ThemeAttribute {}
extension NSAttributedString: ThemeAttribute {}
