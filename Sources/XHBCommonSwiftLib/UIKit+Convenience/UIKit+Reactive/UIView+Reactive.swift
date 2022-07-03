//
//  UIView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIView {
    
    @discardableResult
    open func subscribeTap(action: @escaping UIGestureRecognizerAction<UITapGestureRecognizer>) -> AnyObservable {
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        return UIGestureRecognizer.subscribe(gesture: tap, action: action)
    }
    
    @discardableResult
    open func subscribePan(action: @escaping UIGestureRecognizerAction<UIPanGestureRecognizer>) -> AnyObservable {
        let pan = UIPanGestureRecognizer()
        addGestureRecognizer(pan)
        return UIGestureRecognizer.subscribe(gesture: pan, action: action)
    }
    
    @discardableResult
    open func subscribePinch(action: @escaping UIGestureRecognizerAction<UIPinchGestureRecognizer>) -> AnyObservable {
        let pinch = UIPinchGestureRecognizer()
        addGestureRecognizer(pinch)
        return UIGestureRecognizer.subscribe(gesture: pinch, action: action)
    }
    
    @discardableResult
    open func subscribeSwipe(action: @escaping UIGestureRecognizerAction<UISwipeGestureRecognizer>) -> AnyObservable {
        let swipe = UISwipeGestureRecognizer()
        addGestureRecognizer(swipe)
        return UIGestureRecognizer.subscribe(gesture: swipe, action: action)
    }
    
    @discardableResult
    open func subscribeRotation(action: @escaping UIGestureRecognizerAction<UIRotationGestureRecognizer>) -> AnyObservable {
        let rotation = UIRotationGestureRecognizer()
        addGestureRecognizer(rotation)
        return UIGestureRecognizer.subscribe(gesture: rotation, action: action)
    }
    
    @discardableResult
    open func subscribeLongPress(action: @escaping UIGestureRecognizerAction<UILongPressGestureRecognizer>) -> AnyObservable {
        let longPress = UILongPressGestureRecognizer()
        addGestureRecognizer(longPress)
        return UIGestureRecognizer.subscribe(gesture: longPress, action: action)
    }
    
    @discardableResult
    open func subscribeScreenEdgePan(action: @escaping UIGestureRecognizerAction<UIScreenEdgePanGestureRecognizer>) -> AnyObservable {
        let screenEdgePan = UIScreenEdgePanGestureRecognizer()
        addGestureRecognizer(screenEdgePan)
        return UIGestureRecognizer.subscribe(gesture: screenEdgePan, action: action)
    }
    
}
