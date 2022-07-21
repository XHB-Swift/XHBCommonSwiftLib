//
//  UIKit+Reactive.swift
//  
//
//  Created by xiehongbiao on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib


extension UIControl {
    
    public struct Action<Output: UIControl>: Observable {
        
        public typealias Output = Output
        public typealias Failure = Never
        
        public let output: Output
        public let events: Output.Event
        private let _signalConduit: _UIControlSignalConduit<Output>
        
        public init(output: Output, events: Output.Event) {
            self.output = output
            self.events = events
            self._signalConduit = .init(source: output, events: events)
        }
        
        public func subscribe<Ob>(_ observer: Ob) where Ob : Observer, Failure == Ob.Failure, Output == Ob.Input {
            _signalConduit.attach(observer: observer)
        }
    }
}

extension UIControl.Action {
    
    fileprivate final class _UIControlSignalConduit<Source: UIControl>: SelectorSignalConduit<Source, Source, Never> {
        
        override func cancel() {
            source?.removeTarget(self, action: self.selector, for: self.events)
        }
        
        let events: Source.Event
        
        init(source: Source, events: Source.Event) {
            self.events = events
            super.init(source: source)
            source.addTarget(self, action: self.selector, for: events)
        }
    }
}

extension UIBarButtonItem {
    
    public func observation() -> UIBarButtonItem.Observation {
        return .init(output: self)
    }
    
    public struct Observation: Observable {
        
        public typealias Output = UIBarButtonItem
        public typealias Failure = Never
        
        public let output: Output
        private let _signalConduit: _UIBarButtonItemSignalConduit
        
        public init(output: Output) {
            self.output = output
            self._signalConduit = .init(source: output)
        }
        
        public func subscribe<Ob>(_ observer: Ob) where Ob : Observer, Never == Ob.Failure, UIBarButtonItem == Ob.Input {
            _signalConduit.attach(observer: observer)
        }
    }
}

extension UIBarButtonItem.Observation {
    
    fileprivate final class _UIBarButtonItemSignalConduit: SelectorSignalConduit<UIBarButtonItem, UIBarButtonItem, Never> {
        
        override func cancel() {
            source?.target = nil
            source?.action = nil
            super.cancel()
        }
        
        override init(source: UIBarButtonItem?) {
            super.init(source: source)
            source?.target = self
            source?.action = self.selector
        }
    }
}

extension UIGestureRecognizer {
    
    public func observation<G: UIGestureRecognizer>(for gesture: G) -> G.Observation<G> {
        return .init(output: gesture)
    }
    
    public struct Observation<Output: UIGestureRecognizer>: Observable {
        
        public typealias Output = Output
        public typealias Failure = Never
        
        public let output: Output
        private let _signalConduit: _UIGestureRecognizerSignalConduit<Output>
        
        public init(output: Output) {
            self.output = output
            self._signalConduit = .init(source: output)
        }
        
        public func subscribe<Ob>(_ observer: Ob) where Ob : Observer, Never == Ob.Failure, Output == Ob.Input {
            _signalConduit.attach(observer: observer)
        }
    }
}

extension UIGestureRecognizer.Observation {
    
    fileprivate final class _UIGestureRecognizerSignalConduit<Output: UIGestureRecognizer>: SelectorSignalConduit<Output, Output, Never> {
        
        override func cancel() {
            source?.removeTarget(self, action: self.selector)
            super.cancel()
        }
        
        override init(source: Output?) {
            super.init(source: source)
            source?.addTarget(self, action: self.selector)
        }
    }
}


