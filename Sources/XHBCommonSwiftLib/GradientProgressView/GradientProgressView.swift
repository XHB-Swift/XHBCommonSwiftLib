//
//  HBGradientProgressView.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/4/16.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#if os(iOS)

import UIKit

public protocol ColorType {
    func toColor() -> UIColor
}

extension String: ColorType {
    
    public func toColor() -> UIColor {
        return .init(argbHexString: self) ?? .clear
    }
}

extension UIColor: ColorType {
    
    public func toColor() -> UIColor {
        return self
    }
}

open class GradientProgressView: UIView {

    internal lazy var backgroundLayer = CAShapeLayer()
    internal lazy var progressLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    public var progress: CGFloat = 0 {
        didSet {
            let value = max(min(progress, 1), 0)
            progressLayer.strokeEnd = value
        }
    }
    
    open override var frame: CGRect {
        didSet {
            let path = progressLayerPath()
            backgroundLayer.path = path.cgPath
            progressLayer.path = path.cgPath
            backgroundLayer.frame = bounds
            progressLayer.frame = bounds
            gradientLayer.frame = bounds
            backgroundLayer.lineWidth = self.height
            progressLayer.lineWidth = self.height
        }
    }
    
    internal func progressLayerPath() -> UIBezierPath {
        fatalError("Subsclass must implement this method.")
    }
    
    public func setGradientColors(_ colors: [ColorType]) {
        let cgColors = colors.map { $0.toColor().cgColor }
        gradientLayer.colors = cgColors
    }
    
    public func setLocations(_ locations: [NSNumber]) {
        gradientLayer.locations = locations
    }
    
    public func setStartPoint(_ startPoint: CGPoint) {
        gradientLayer.startPoint = startPoint
    }
    
    public func setEndPoint(_ endPoint: CGPoint) {
        gradientLayer.endPoint = endPoint
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSublayers()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSublayers()
    }
    
    internal func setupSublayers() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = progressLayer
    }
    
}

#endif
