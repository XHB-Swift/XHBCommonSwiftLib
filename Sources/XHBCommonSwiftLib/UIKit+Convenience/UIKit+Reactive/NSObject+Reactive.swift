//
//  NSObject+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/21.
//

import Foundation
import XHBFoundationSwiftLib

fileprivate final class _NSObjectSetBox: NSObject {
    
    fileprivate var _box: Set<AnyCancellable>
    
    override init() { _box = .init() }
}

extension NSObject {
    
    public typealias NSObjectValueObservation<T> = CurrentValueNeverObservation<T>
    public typealias NSObjectNilValueObservation<T> = CurrentValueNeverObservation<T?>
    
    private static var NSObjectValueBindingSetKey: Void?
    
    open var customCancellableSet: Set<AnyCancellable> {
        set {
            runtimePropertyLazyBinding(&Self.NSObjectValueBindingSetKey, { _NSObjectSetBox() })._box.formUnion(newValue)
        }
        get {
            runtimePropertyLazyBinding(&Self.NSObjectValueBindingSetKey, { _NSObjectSetBox() })._box
        }
    }
    
    open func subscribe<T>(for defaultValue: T, action: @escaping (T) -> Void) -> NSObjectValueObservation<T> {
        let observable = CurrentValueNeverObservation<T>(defaultValue)
        observable
            .receive(on: DispatchScheduler.main)
            .sink(receiveValue: action)
            .store(in: &customCancellableSet)
        return observable
    }
    
    open func subscribe<T>(for action: @escaping (T?) -> Void) -> NSObjectNilValueObservation<T> {
        let observable = CurrentValueNeverObservation<T?>(nil)
        observable
            .receive(on: DispatchScheduler.main)
            .sink(receiveValue: action)
            .store(in: &customCancellableSet)
        return observable
    }
}
