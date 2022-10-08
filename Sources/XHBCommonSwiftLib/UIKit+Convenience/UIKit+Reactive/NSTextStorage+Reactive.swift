//
//  NSTextStorage+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/3.
//

import UIKit
import XHBFoundationSwiftLib

extension NSTextStorage {
    
    public typealias ProcessEditing = (_ storage: NSTextStorage,
                                       _ editedMask: EditActions,
                                       _ editedRange: NSRange,
                                       _ changedInLength: Int) -> Void
}

open class NSTextStorageObservation: NSObject, NSTextStorageDelegate, Observation {
    
    public typealias Output = (storage: NSTextStorage,
                               editedMask: NSTextStorage.EditActions,
                               editedRange: NSRange,
                               changedInLength: Int)
    public typealias Failure = Never
    
    private var observers: Dictionary<UUID, AnyObserver<Output, Failure>> = .init()
    
    public func textStorage(_ textStorage: NSTextStorage,
                            willProcessEditing editedMask: NSTextStorage.EditActions,
                            range editedRange: NSRange,
                            changeInLength delta: Int) {
        //textStorage.string;
    }
    
    public func textStorage(_ textStorage: NSTextStorage,
                            didProcessEditing editedMask: NSTextStorage.EditActions,
                            range editedRange: NSRange,
                            changeInLength delta: Int) {
        send((textStorage, editedMask, editedRange, delta))
    }
    
    public func send(_ signal: Signal) {
        observers.forEach { $0.value.receive(signal) }
    }
    
    public func send(_ value: Output) {
        observers.forEach { $0.value.receive(value) }
    }
    
    public func send(_ failure: Failure) {}
    
    public func subscribe<Ob>(_ observer: Ob) where Ob : Observer, Failure == Ob.Failure, Output == Ob.Input {
        observers[observer.identifier] = .init(observer)
        send(Signals.empty)
    }
}

extension NSTextStorage {
    
    private static var NSTextStorageObservationBindingKey: Void?
    
    public var observation: NSTextStorageObservation {
        let observation = runtimePropertyLazyBinding(&Self.NSTextStorageObservationBindingKey) {
            return NSTextStorageObservation()
        }
        if delegate == nil {
            delegate = observation
        }
        return observation
    }
}
