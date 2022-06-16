//
//  BezierPathBubbleTipsView.swift
//  
//
//  Created by xiehongbiao on 2022/6/16.
//

#if os(iOS)

import UIKit

public class BezierPathBubbleTipsView: UIView {
    
    public var arrowPosition: ArrowPosition = .leading(5)
    public var arrowDirection: ArrowDirection = .up(CGSize(width: 14, height: 8))
    
}

extension BezierPathBubbleTipsView {
    
    public enum ArrowPosition {
        case leading(CGFloat)
        case center(CGFloat)
        case trailing(CGFloat)
    }
    
    public enum ArrowDirection {
        case up(CGSize)
        case down(CGSize)
        case left(CGSize)
        case right(CGSize)
    }
}

#endif
