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

open class NSTextStorageDelegateObject: NSObject, NSTextStorageDelegate {
    
    open var didProcessEditing: NSTextStorage.ProcessEditing?
    open var willProcessEditing: NSTextStorage.ProcessEditing?
    
    public init(_ didProcessEditing: NSTextStorage.ProcessEditing? = nil,
                _ willProcessEditing: NSTextStorage.ProcessEditing? = nil) {
        self.didProcessEditing = didProcessEditing
        self.willProcessEditing = willProcessEditing
    }
    
    public func textStorage(_ textStorage: NSTextStorage,
                            willProcessEditing editedMask: NSTextStorage.EditActions,
                            range editedRange: NSRange,
                            changeInLength delta: Int) {
        willProcessEditing?(textStorage, editedMask, editedRange, delta)
    }
    
    public func textStorage(_ textStorage: NSTextStorage,
                            didProcessEditing editedMask: NSTextStorage.EditActions,
                            range editedRange: NSRange,
                            changeInLength delta: Int) {
        didProcessEditing?(textStorage, editedMask, editedRange, delta)
    }
}

public class NSTextStorageObserver: ObjCDelegateObserver<NSTextStorage, NSTextStorageDelegate, NSTextStorageDelegateObject> {
    
    public override init(_ base: NSTextStorage, _ delegateObject: NSTextStorageDelegateObject) {
        super.init(base, delegateObject)
        base.delegate = delegateObject
    }
    
    public convenience init(_ base: NSTextStorage,
                            _ didProcessEditing: NSTextStorage.ProcessEditing? = nil,
                            _ willProcessEditing: NSTextStorage.ProcessEditing? = nil) {
        self.init(base, .init(didProcessEditing, willProcessEditing))
    }
}

extension NSTextStorage {
    
    @discardableResult
    open func subscribe<Value>(value: Value? = nil, observer: NSTextStorageObserver) -> ValueObservable<Value?> {
        let observable = specifiedOptinalValueObservable(value: value, queue: .main)
        observable.add(observer: observer)
        return observable
    }
    
    @discardableResult
    open func subscribe<Value>(value: Value? = nil,
                               didProcess: ProcessEditing? = nil,
                               willProcess: ProcessEditing? = nil) -> ValueObservable<Value?> {
        return subscribe(value: value, observer: .init(self, didProcess, willProcess))
    }
    
}
