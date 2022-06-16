//
//  Foundation.swift
//  
//
//  Created by 谢鸿标 on 2022/6/15.
//

import Foundation
import CryptoKit
import CommonCrypto

#if os(iOS)
import UIKit
#endif

public struct CommonError: Error {
    public var code: Int
    public var reason: String
}

extension String {
    
    public var hexStringToInt: Int {
        return Int(self, radix: 16) ?? 0
    }
    
    public subscript(i: Int) -> Self? {
        if i >= count {
            return nil
        }
        if i == 0 {
            return String(self[startIndex])
        }
        if i == count - 1 {
            return String(self[endIndex])
        }
        
        let targetIndex = index(startIndex, offsetBy: i)
        return String(self[targetIndex])
    }
    
    public subscript(r: Range<Int>) -> Self? {
        if r.lowerBound < 0 {
            return nil
        }
        if r.lowerBound >= count {
            return nil
        }
        if r.upperBound > count {
            return nil
        }
        let index0 = index(startIndex, offsetBy: r.lowerBound)
        let index1 = index(startIndex, offsetBy: r.upperBound)
        return String(self[index0..<index1])
    }
    
    public subscript(r: NSRange) -> Self? {
        guard let rr = Range(r) else { return nil }
        return self[rr]
    }
    
    public var objectClassName: String? {
        
        guard let space = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return nil }
        return "\(space.replacingOccurrences(of: "-", with: "_")).\(self)"
    }
    
    public var md5String: Self {
        if isEmpty { return self }
        if #available(iOS 13.0, *) {
            guard let d = self.data(using: .utf8) else { return "" }
            return Insecure.MD5.hash(data: d).map {
                String(format: "%02hhx", $0)
            }.joined()
        }else {
            let data = Data(utf8)
            let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
                var array = Array<UInt8>(repeating: 0, count: Int(CC_MD5_BLOCK_BYTES))
                CC_MD5(bytes.baseAddress, CC_LONG(data.count), &array)
                return array
            }
            return hash.map { String(format: "%02x", $0) }.joined()
        }
    }
    
    public  func appending(path: Self) -> Self {
        let pathHasPrefixSlash = path.hasPrefix("/")
        let currentHasSuffixSlash = self.hasSuffix("/")
        if (pathHasPrefixSlash && !currentHasSuffixSlash) ||
            (!pathHasPrefixSlash && currentHasSuffixSlash){
            return appending(path)
        } else if pathHasPrefixSlash && currentHasSuffixSlash {
            guard let ss = self[count - 1] else { return appending(path) }
            return ss.appending(path)
        } else {
            return appending("/\(path)")
        }
    }
    
    public mutating func append(path: Self) {
        let pathHasPrefixSlash = path.hasPrefix("/")
        let currentHasSuffixSlash = self.hasSuffix("/")
        if (pathHasPrefixSlash && !currentHasSuffixSlash) ||
            (!pathHasPrefixSlash && currentHasSuffixSlash){
            self.append(path)
        } else if pathHasPrefixSlash && currentHasSuffixSlash {
            guard let ss = self[count - 1] else { return }
            self = ss.appending(path)
        } else if !pathHasPrefixSlash && !currentHasSuffixSlash {
            self.append("/\(path)")
        }
    }
    
    public var urlEncoded: Self {
        let encodedUrlString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedUrlString ?? ""
    }
    
    public var urlDecoded: Self {
        return removingPercentEncoding ?? ""
    }
}

extension Double {
    
    public static let pi_2 = pi / 2
    public static let pi_3 = pi / 3
    public static let pi_4 = pi / 4
    public static let pi_6 = pi / 6
    public static let m_2_pi = pi * 2
    
    public var degree: Self {
        return self * 180.0 / Self.pi
    }
    
    public var radian: Self {
        return self * Self.pi / 180.0
    }
}

extension Float {
    
    public static let pi_2 = pi / 2
    public static let pi_3 = pi / 3
    public static let pi_4 = pi / 4
    public static let pi_6 = pi / 6
    public static let m_2_pi = pi * 2
    
    public var degree: Self {
        return self * 180.0 / Self.pi
    }
    
    public var radian: Self {
        return self * Self.pi / 180.0
    }
}

public typealias TimerUpdateAction = (TimeInterval)->Void

extension Timer {
    
    public class func scheduled(interval: TimeInterval,
                                loopInCommonModes: Bool,
                                repeats: Bool,
                                action: @escaping TimerUpdateAction) -> Timer {
        
        let timer = Timer.scheduledTimer(timeInterval: interval,
                                         target: self,
                                         selector: #selector(timerAction(_:)),
                                         userInfo: action,
                                         repeats: repeats)
        
        if loopInCommonModes {
            RunLoop.current.add(timer, forMode: .common)
        }
        
        return timer
    }
    
    @objc private class func timerAction(_ sender: Timer) {
        guard let action = sender.userInfo as? TimerUpdateAction else { return }
        action(sender.timeInterval)
    }
}

#if os(iOS)

extension CADisplayLink {
    
    private static var UpdatedActionKey: Void?
    
    private var updateAction: TimerUpdateAction? {
        set {
            if newValue == nil {
                print("Set CADisplayLink updateAction is nil")
            }
            objc_setAssociatedObject(self, &CADisplayLink.UpdatedActionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            let action = objc_getAssociatedObject(self, &CADisplayLink.UpdatedActionKey) as? TimerUpdateAction
            if action == nil {
                print("Get CADisplayLink updateAction is nil")
            }
            return action
        }
    }
    
    public class func scheduled(loopInCommonModes: Bool,
                               action: @escaping TimerUpdateAction) -> CADisplayLink {
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction(_:)))
        displayLink.updateAction = action
        displayLink.add(to: .current, forMode: loopInCommonModes ? .common : .default)
        return displayLink
    }
    
    @objc private class func displayLinkAction(_ sender: CADisplayLink) {
        sender.updateAction?(sender.duration)
    }
}

#endif

extension Sequence {
    
    public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}

extension Collection {
    
    public func sorted<Value: Comparable>(on property: KeyPath<Element, Value>,
                                        by areIncreasingOrder: (Value, Value)->Bool) -> [Element] {
        return sorted { value1, value2 in
            areIncreasingOrder(value1[keyPath: property], value2[keyPath: property])
        }
    }
    
    public subscript(safe index: Self.Index) -> Iterator.Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
    
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    
    public mutating func sort<Value: Comparable>(on property: KeyPath<Element, Value>, by order: (Value, Value) throws -> Bool) rethrows {
        
        try sort { try order($0[keyPath: property], $1[keyPath: property]) }
    }
    
}

public protocol KeyPathEditable {
    
    func set<T>(value: T, for property: PartialKeyPath<Self>) throws -> Self
}

extension KeyPathEditable {
    
    func set<T>(value: T, for property: PartialKeyPath<Self>) throws -> Self {
        guard let writableProperty = property as? WritableKeyPath<Self,T> else {
            throw CommonError(code: -101, reason: "属性设置失败")
        }
        var newSelf = self
        newSelf[keyPath: writableProperty] = value
        return newSelf
    }
}

extension Dictionary where Key == String {
    
    public func value(for keyPath: String, seperator: String = ".") -> Value? {
        
        let keyArray = keyPath.components(separatedBy: seperator)
        
        var arrayIterator = keyArray.makeIterator()
        var currentKey = arrayIterator.next()
        var nextDict: Self? = self
        var targetValue: Value? = nil
        while currentKey != nil {
            
            if let k = currentKey {
                targetValue = nextDict?[k]
                if targetValue is Self {
                    nextDict = targetValue as? Self
                }
            }
            currentKey = arrayIterator.next()
        }
        
        return targetValue
    }
    
    subscript(keyPath: String, seperator: String = ".") -> Value? {
        
        get { value(for: keyPath, seperator: seperator) }
    }
}

extension Dictionary {
    
    public mutating func filter(with keys: Array<Key>, excepted: Bool = false) {
        guard !keys.isEmpty else { return }
        let keysSet = Set(keys)
        self = filter { keysSet.contains($0.key) != excepted }
    }
    
    public mutating func concat(dictionary: Self, keysMapping: Dictionary<Key,Key>) {
        
        if keysMapping.isEmpty {
            
            _ = dictionary.map { self[$0] = $1 }
            
        } else {
            
            _ = keysMapping.map { self[$0] = dictionary[$1] }
        }
        
    }
    
}

extension Array {
    
    public func absElement(_ absIndex: Int) -> Element {
        if (0..<count).contains(absIndex) {
            return self[absIndex]
        } else {
            let adjustIndex = abs(absIndex) - count
            return self[abs(adjustIndex)]
        }
    }
    
    public func safeElement(_ safeIndex: Int) -> Element? {
        guard (0..<count).contains(safeIndex) else { return nil }
        return self[safeIndex]
    }
}

@available(macOS 10.15, iOS 13, *)
extension URLSession {
    
    public func download(for request: URLRequest) async throws -> (URL, URLResponse) {
        
        return try await withTaskCancellationHandler(operation: {
            return try await withUnsafeThrowingContinuation({ continuation in
                downloadTask(with: request, completionHandler: { url, response, error in
                    if let _url = url,
                        let _response = response {
                        continuation.resume(returning: (_url, _response))
                    } else if let _error = error {
                        continuation.resume(throwing: _error)
                    } else {
                        continuation.resume(throwing: CommonError(code: -1024, reason: "此处需要调试"))
                    }
                }).resume()
            })
            
        }, onCancel: {
            
        })
        
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        
        return try await withTaskCancellationHandler(operation: {
            return try await withUnsafeThrowingContinuation({ continuation in
                dataTask(with: request) { data, response, error in
                    
                    if let _data = data,
                        let _response = response {
                        continuation.resume(returning: (_data, _response))
                    } else if let _error = error {
                        continuation.resume(throwing: _error)
                    } else {
                        continuation.resume(throwing: CommonError(code: -1024, reason: "此处需要调试"))
                    }
                    
                }.resume()
            })
        }, onCancel: {
            
        })
    }
    
}

//MARK: 属性包装器

@propertyWrapper
struct Clamped<T: Comparable> {
    
    private var value: T
    private var validRange: ClosedRange<T>
    
    public var wrappedValue: T {
        set {
            value = min(max(newValue, validRange.lowerBound), validRange.upperBound)
        }
        get { return value }
    }
    
    init(wrappedValue: T, range: ClosedRange<T>) {
        self.value = wrappedValue
        self.validRange = range
    }
    
}

@propertyWrapper
struct Trimmed {
    
    private var value = ""
    
    var wrappedValue: String {
        get { return value }
        set {
            value = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    init(_ value: String) {
        self.value = value
    }
    
}

@propertyWrapper
struct Path {
    
    let root: String
    private var absolutePath = ""
    var wrappedValue: String {
        get {
            return absolutePath
        }
        set {
            absolutePath = "\(root)/\(newValue)"
        }
    }
    
    init(root: String) {
        self.root = root
    }
    
}

public protocol DefaultValue {
    
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

@propertyWrapper
struct Default<T: DefaultValue> {
    
    var wrappedValue: T.Value
}

extension Default: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension Bool {
    public enum False: DefaultValue {
        public typealias Value = Bool
        public static var defaultValue = false
    }
    public enum True: DefaultValue {
        public typealias Value = Bool
        public static var defaultValue = true
    }
}

extension String {
    public enum Empty: DefaultValue {
        public typealias Value = String
        public static var defaultValue = ""
    }
}

extension Int {
    public enum Zero: DefaultValue {
        public typealias Value = Int
        public static var defaultValue: Int = 0
    }
}

#if os(iOS)

extension CGFloat {
    public enum Zero: DefaultValue {
        public typealias Value = CGFloat
        public static var defaultValue: CGFloat = 0
    }
}

#endif

extension Float {
    public enum Zero: DefaultValue {
        public typealias Value = Float
        public static var defaultValue: Float = 0
    }
}

extension Double {
    public enum Zero: DefaultValue {
        public typealias Value = Double
        public static var defaultValue: Double = 0
    }
}

extension Default {
    typealias True = Default<Bool.True>
    typealias False = Default<Bool.False>
    typealias IntZero = Default<Int.Zero>
    typealias FloatZero = Default<Float.Zero>
    typealias DoubleZero = Default<Double.Zero>
    #if os(iOS)
    typealias CGFloatZero = Default<CGFloat.Zero>
    #endif
    typealias EmptyString = Default<String.Empty>
}
