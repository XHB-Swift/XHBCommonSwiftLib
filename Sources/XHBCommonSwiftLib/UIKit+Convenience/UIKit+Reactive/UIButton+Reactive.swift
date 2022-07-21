//
//  UIButton+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIButton {
    
    open var touchupInside: AnyObservable<UIButton, Never> {
        return .init(UIButton.Action<UIButton>(output: self, events: .touchUpInside))
    }
}

extension UIButton {
    
    open func subscribeTitle(for state: UIControl.State) -> NSObjectNilValueObservation<String> {
        return subscribe(for: { [weak self] in self?.setTitle($0, for: state) })
    }
    
    open func subscribeImage(for state: UIControl.State) -> NSObjectNilValueObservation<UIImage> {
        return subscribe(for: { [weak self] in self?.setImage($0, for: state) })
    }
    
    open func subscribeBackgroundImage(for state: UIControl.State) -> NSObjectNilValueObservation<UIImage> {
        return subscribe(for: { [weak self] in self?.setBackgroundImage($0, for: state) })
    }
    
    open func subscribeAttributedTitle(for state: UIControl.State) -> NSObjectNilValueObservation<NSAttributedString> {
        return subscribe(for: { [weak self] in self?.setAttributedTitle($0, for: state) })
    }
}
