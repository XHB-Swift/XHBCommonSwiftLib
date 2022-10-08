//
//  UIButton+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIButton {
    
    public var touchupInside: AnyObservable<UIButton, Never> {
        return .init(UIButton.Action<UIButton>(output: self, events: .touchUpInside))
    }
}

extension UIButton {
    
    public func subscribeTitle(for state: UIControl.State) -> NSObjectNilValueObservation<String> {
        return subscribe(for: { [weak self] in self?.setTitle($0, for: state) })
    }
    
    public func subscribeImage(for state: UIControl.State) -> NSObjectNilValueObservation<UIImage> {
        return subscribe(for: { [weak self] in self?.setImage($0, for: state) })
    }
    
    public func subscribeBackgroundImage(for state: UIControl.State) -> NSObjectNilValueObservation<UIImage> {
        return subscribe(for: { [weak self] in self?.setBackgroundImage($0, for: state) })
    }
    
    public func subscribeAttributedTitle(for state: UIControl.State) -> NSObjectNilValueObservation<NSAttributedString> {
        return subscribe(for: { [weak self] in self?.setAttributedTitle($0, for: state) })
    }
}
