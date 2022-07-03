//
//  UIKit+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

public typealias UIControlEventsAction<Observer: UIControl> = SelectorObserver<Observer>.Action
public typealias UIBarButtonItemAction = SelectorObserver<UIBarButtonItem>.Action
public typealias UIGestureRecognizerAction<Observer: UIGestureRecognizer> = SelectorObserver<Observer>.Action

fileprivate final class UIControlObserver<Observer: UIControl> : SelectorObserver<Observer> {
    
    init(_ control: UIControl, _ events: UIControl.Event, _ action: @escaping UIControlEventsAction<Observer>) {
        super.init(control, action)
        control.addTarget(self, action: selector, for: events)
    }
}

fileprivate final class UIBarButtonItemObserver: SelectorObserver<UIBarButtonItem> {
    
    init(_ barButtonItem: UIBarButtonItem, _ action: @escaping UIBarButtonItemAction) {
        super.init(barButtonItem, action)
        barButtonItem.target = self
        barButtonItem.action = self.selector
    }
}

fileprivate final class UIGestureRecognizerObserver<Observer: UIGestureRecognizer> : SelectorObserver<Observer> {
    
    init(_ gestureRecognizer: Observer, _ action: @escaping UIGestureRecognizerAction<Observer>) {
        super.init(gestureRecognizer, action)
        gestureRecognizer.addTarget(self, action: self.selector)
    }
}

extension AnyObservable {
    
    open func add<Observer: UIControl>(control: Observer,
                                       events: UIControl.Event,
                                       action: @escaping UIControlEventsAction<Observer>) {
      let newOne = UIControlObserver(control, events, action)
      add(observer: newOne)
    }
    
    open func add(barButtonItem: UIBarButtonItem,
                  action: @escaping UIBarButtonItemAction) {
        let newOne = UIBarButtonItemObserver(barButtonItem, action)
        add(observer: newOne)
    }
    
    open func add<Observer: UIGestureRecognizer>(gesture: Observer,
                                                 action: @escaping UIGestureRecognizerAction<Observer>) {
        let newOne = UIGestureRecognizerObserver(gesture, action)
        add(observer: newOne)
    }
}

extension UIControl {
    
    @discardableResult
    open class func subscribe<Control: UIControl>(control: Control,
                                                  events: UIControl.Event,
                                                  action: @escaping UIControlEventsAction<Control>) -> AnyObservable {
        let observable = control.anyObservable
        observable.add(control: control, events: events, action: action)
        return observable
    }
    
    @discardableResult
    open class func subscribe<Control: UIControl, T>(control: Control,
                                                     value: T,
                                                     action: @escaping UIControlEventsAction<Control>) -> ValueObservable<T> {
        let observable = control.specifiedValueObservable(value: value, queue: .main)
        observable.add(control: control, events: [.valueChanged, .allEditingEvents], action: action)
        return observable
    }
}

extension UIBarButtonItem {
    
    @discardableResult
    open func subscribe(action: @escaping UIBarButtonItemAction) -> AnyObservable {
        let observable = anyObservable
        observable.add(barButtonItem: self, action: action)
        return observable
    }
}

extension UIGestureRecognizer {
    
    private static var UIGestureRecognizerActionKey: Void?
    
    @discardableResult
    open class func subscribe<Gesture: UIGestureRecognizer>(gesture: Gesture,
                                                            action: @escaping UIGestureRecognizerAction<Gesture>) -> AnyObservable {
        let observable = gesture.anyObservable
        observable.add(gesture: gesture, action: action)
        return observable
    }
}

