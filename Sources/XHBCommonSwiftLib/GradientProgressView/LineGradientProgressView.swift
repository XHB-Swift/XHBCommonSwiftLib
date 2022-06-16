//
//  HBLineGradientProgressView.swift
//  CodeRecord-Swift
//
//  Created by 谢鸿标 on 2022/4/16.
//  Copyright © 2022 谢鸿标. All rights reserved.
//

#if os(iOS)

import UIKit

open class LineGradientProgressView: GradientProgressView {

    override func progressLayerPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 5, y: self.height / 2))
        path.addLine(to: CGPoint(x: self.width - 5, y: self.height / 2))
        
        return path
    }
    
    override func setupSublayers() {
        super.setupSublayers()
        
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeEnd = 1
        backgroundLayer.lineCap = .round
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
    }
    
}

#endif
