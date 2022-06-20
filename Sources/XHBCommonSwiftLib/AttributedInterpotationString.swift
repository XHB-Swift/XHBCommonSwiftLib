//
//  AttributedInterpotationString.swift
//  
//
//  Created by 谢鸿标 on 2022/6/16.
//

import Foundation

#if os(iOS)

import UIKit

#else

import AppKit

#endif

public struct AttributedInterpotationString {
    
    public let attributedString: NSAttributedString
}

extension AttributedInterpotationString: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.attributedString = NSAttributedString(string: value)
    }
}

extension AttributedInterpotationString: CustomStringConvertible {
    
    public var description: String {
        return String(describing: self.attributedString)
    }
}

extension AttributedInterpotationString: ExpressibleByStringInterpolation {
    public init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    public struct StringInterpolation: StringInterpolationProtocol {
        public var attributedString: NSMutableAttributedString
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }
        
        public func appendLiteral(_ literal: String) {
            #if os(iOS)
            let attrs: [NSAttributedString.Key : Any] = [
                .font : UIFont(name: "PingFangSC-Regular", size: 16) as Any,
                .foregroundColor : UIColor.black as Any
            ]
            appendInterpolation(literal, attrs)
            #else
            let astr = NSAttributedString(string: literal)
            self.attributedString.append(astr)
            #endif
        }
        
        public func appendInterpolation(_ string: String, _ attributes: [NSAttributedString.Key : Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            self.attributedString.append(astr)
        }
        
        #if os(iOS)
        
        public func appendInterpolation(image: UIImage, scale: CGFloat = 1.0) {
            let attachment = NSTextAttachment()
            let size = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
            attachment.image = image
            attachment.bounds = CGRect(origin: .zero, size: size)
            self.attributedString.append(NSAttributedString(attachment: attachment))
        }
        
        #else
        
        public func appendInterpolation(image: NSImage, scale: CGFloat = 1.0) {
            let attachment = NSTextAttachment()
            let size = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
            attachment.image = image
            attachment.bounds = CGRect(origin: .zero, size: size)
            self.attributedString.append(NSAttributedString(attachment: attachment))
        }
        
        #endif
    }
}

extension AttributedInterpotationString {
    public struct Style {
        public let attributes: [NSAttributedString.Key : Any]
#if os(iOS)
        public static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font : font])
        }
        public static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor : color])
        }
        public static func color(_ colorString: String, _ defaultColor: UIColor = .black) -> Style {
            return .color(UIColor(argbHexString: colorString) ?? defaultColor)
        }
        public static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor : color])
        }
        public static func bgColor(_ colorString: String, _ defaultColor: UIColor = .black) -> Style {
            return .bgColor(UIColor(argbHexString: colorString) ?? defaultColor)
        }
        public static func link(_ link: URL) -> Style {
            return Style(attributes: [.link : link])
        }
        public static func link(_ link: String) -> Style {
            return Style(attributes: [.link : link])
        }
        public static func underline(_ color: UIColor, _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineStyle : style.rawValue,
                .underlineColor : color,
            ])
        }
        public static func underline(_ colorString: String, _ defaultColor: UIColor = .black, _ style: NSUnderlineStyle) -> Style {
            return .underline(UIColor(argbHexString: colorString) ?? defaultColor, style)
        }
#else
        public static func font(_ font: NSFont) -> Style {
            return Style(attributes: [.font : font])
        }
        public static func color(_ color: NSColor) -> Style {
            return Style(attributes: [.foregroundColor : color])
        }
        public static func color(_ colorString: String, _ defaultColor: NSColor = .black) -> Style {
            return .color(NSColor(argbHexString: colorString) ?? defaultColor)
        }
        public static func bgColor(_ color: NSColor) -> Style {
            return Style(attributes: [.backgroundColor : color])
        }
        public static func bgColor(_ colorString: String, _ defaultColor: NSColor = .black) -> Style {
            return .bgColor(NSColor(argbHexString: colorString) ?? defaultColor)
        }
        public static func link(_ link: URL) -> Style {
            return Style(attributes: [.link : link])
        }
        public static func link(_ link: String) -> Style {
            return Style(attributes: [.link : link])
        }
        public static func underline(_ color: NSColor, _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineStyle : style.rawValue,
                .underlineColor : color,
            ])
        }
        public static func underline(_ colorString: String,
                                     _ defaultColor: NSColor = .black,
                                     _ style: NSUnderlineStyle) -> Style {
            return .underline(NSColor(argbHexString: colorString) ?? defaultColor, style)
        }
#endif
        public static let oblique = Style(attributes: [.obliqueness : 0.1])
        public static func alignment(_ alignment: NSTextAlignment) -> Style {
            let ps  = NSMutableParagraphStyle()
            ps.alignment = alignment
            return Style(attributes: [
                .paragraphStyle : ps
            ])
        }
    }
}

extension AttributedInterpotationString.StringInterpolation {
    public func appendInterpolation(_ string: String, _ styles: AttributedInterpotationString.Style...) {
        #if os(iOS)
        var attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "PingFangSC-Regular", size: 16) as Any,
            .foregroundColor : UIColor.black as Any
        ]
        #else
        var attrs: [NSAttributedString.Key : Any] = [:]
        #endif
        styles.forEach { attrs.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let astr = NSAttributedString(string: string, attributes: attrs)
        attributedString.append(astr)
    }
    
    public func appendInterpolation(_ string: AttributedInterpotationString, _ styles: AttributedInterpotationString.Style...) {
        #if os(iOS)
        var attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "PingFangSC-Regular", size: 16) as Any,
            .foregroundColor : UIColor.black as Any
        ]
        #else
        var attrs: [NSAttributedString.Key : Any] = [:]
        #endif
        styles.forEach { attrs.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        attributedString.append(mas)
    }
}

