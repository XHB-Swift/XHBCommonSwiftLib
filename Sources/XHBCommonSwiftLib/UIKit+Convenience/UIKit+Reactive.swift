//
//  UIKit+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

public typealias UIControlEventsAction = SelectorObserverContainer<UIControl>.SelectorObserverAction
public typealias UIBarButtonItemAction = SelectorObserverContainer<UIBarButtonItem>.SelectorObserverAction
public typealias UIGestureRecognizerAction = SelectorObserverContainer<UIGestureRecognizer>.SelectorObserverAction

fileprivate final class UIKitControlObserverContainer: SelectorObserverContainer<UIControl> {
    
    init(_ control: UIControl, _ events: UIControl.Event, _ action: @escaping UIControlEventsAction) {
        super.init(control, action)
        control.addTarget(self, action: selector, for: events)
    }
}

fileprivate final class UIKitBarButtonItemObserverContainer: SelectorObserverContainer<UIBarButtonItem> {
    
    init(_ barButtonItem: UIBarButtonItem, _ action: @escaping UIBarButtonItemAction) {
        super.init(barButtonItem, action)
        barButtonItem.target = self
        barButtonItem.action = self.selector
    }
}

fileprivate final class UIKitGestureRecognizerObserverContainer: SelectorObserverContainer<UIGestureRecognizer> {
    
    init(_ gestureRecognizer: UIGestureRecognizer, _ action: @escaping UIGestureRecognizerAction) {
        super.init(gestureRecognizer, action)
        gestureRecognizer.addTarget(self, action: self.selector)
    }
}

extension AnyObservable {
    
    open func add(control: UIControl,
                  events: UIControl.Event,
                  action: @escaping UIControlEventsAction) {
      let newOne = UIKitControlObserverContainer(control, events, action)
      add(observer: newOne)
    }
    
    open func add(barButtonItem: UIBarButtonItem,
                  action: @escaping UIBarButtonItemAction) {
        let newOne = UIKitBarButtonItemObserverContainer(barButtonItem, action)
        add(observer: newOne)
    }
    
    open func add(gesture: UIGestureRecognizer, action: @escaping UIGestureRecognizerAction) {
        let newOne = UIKitGestureRecognizerObserverContainer(gesture, action)
        add(observer: newOne)
    }
}

extension UIControl {
    
    private static var UIControlTouchEventsActionKey: Void?
    private static var UIControlValueEventsActionKey: Void?
    
    @discardableResult
    open func subscribe(events: UIControl.Event, action: @escaping UIControlEventsAction) -> AnyObservable {
        return runtimePropertyLazyBinding(&Self.UIControlTouchEventsActionKey) {
            let ob = AnyObservable()
            ob.add(control: self, events: events, action: action)
            return ob
        }
    }
    
    @discardableResult
    open func subscribe<T>(value: T, action: @escaping UIControlEventsAction) -> Observable<T> {
        return runtimePropertyLazyBinding(&Self.UIControlValueEventsActionKey) {
            let ob = Observable<T>(observedValue: value, queue: .main)
            ob.add(control: self, events: [.allEditingEvents, .valueChanged], action: action)
            return ob
        }
    }
}

extension UIBarButtonItem {
    
    private static var UIBarButtonItemActionKey: Void?
    
    @discardableResult
    open func subscribe(action: @escaping UIBarButtonItemAction) -> AnyObservable {
        return runtimePropertyLazyBinding(&Self.UIBarButtonItemActionKey) {
            let ob = AnyObservable()
            ob.add(barButtonItem: self, action: action)
            return ob
        }
    }
}

extension UIGestureRecognizer {
    
    private static var UIGestureRecognizerActionKey: Void?
    
    @discardableResult
    open func subscribe(action: @escaping UIGestureRecognizerAction) -> AnyObservable {
        return runtimePropertyLazyBinding(&Self.UIGestureRecognizerActionKey) {
            let ob = AnyObservable()
            ob.add(gesture: self, action: action)
            return ob
        }
    }
}

