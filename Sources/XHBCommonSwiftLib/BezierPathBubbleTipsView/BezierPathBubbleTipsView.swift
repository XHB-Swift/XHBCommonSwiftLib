//
//  BezierPathBubbleTipsView.swift
//  
//
//  Created by xiehongbiao on 2022/6/16.
//

#if os(iOS)

import UIKit

public class BezierPathBubbleTipsView: UIView {
    
    public var arrowPosition: ArrowPosition = .leading(offset: 5)
    public var arrowDirection: ArrowDirection = .up
    public var arrowSize = CGSize(width: 14, height: 8)
    public var bubbleColor: UIColor = .black {
        didSet {
            bubbleLayer.fillColor = bubbleColor.cgColor
        }
    }
    public var cornerRadius: CGFloat = 8
    public var contentInsets: UIEdgeInsets = .zero
    
    private weak var customView: UIView?
    private let bubbleView = UIView(frame: .zero)
    private let bubbleLayer = CAShapeLayer()
    private var arrowPoint: CGPoint = .zero
    
    public convenience init(customView: UIView) {
        self.init(frame: .zero)
        bubbleView.addSubview(customView)
        self.customView = customView
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedPoint = touches.first?.location(in: self) else { return }
        if bubbleView.frame.contains(touchedPoint) { return }
        removeFromSuperview()
    }
    
    public func updateLayout() {
        
        let isUp = arrowDirection == .up
        let isDown = arrowDirection == .down
        let isLeft = arrowDirection == .left
        let isVertical = isUp || isDown
        
        bubbleView.width = contentInsets.left + contentInsets.right + (customView?.width ?? 0) + (isVertical ? 0 : arrowSize.width)
        bubbleView.height = contentInsets.top + contentInsets.bottom + (customView?.height ?? 0) + (isVertical ? arrowSize.height : 0)
        
        if isVertical {
            
            if isUp {
                customView?.origin = CGPoint(x: contentInsets.left, y: contentInsets.top + arrowSize.height)
            } else {
                customView?.origin = CGPoint(x: contentInsets.left, y: contentInsets.bottom)
            }
            
        } else {
            
            if isLeft {
                customView?.origin = CGPoint(x: contentInsets.left + arrowSize.width, y: contentInsets.top)
            } else {
                customView?.origin = CGPoint(x: contentInsets.left, y: contentInsets.top)
            }
            
        }
        
        updateArrowPoint()
        updateBubbleShape()
    }
    
    private func updateArrowPoint() {
        let isUp = arrowDirection == .up
        let isDown = arrowDirection == .down
        let isLeft = arrowDirection == .left
        let isVertical = isUp || isDown
        switch arrowPosition {
        case .leading(let offset):
            if isVertical {
                arrowPoint.x = offset
                arrowPoint.y = 0
            } else {
                arrowPoint.x = 0
                arrowPoint.y = offset
            }
        case .center(let offset):
            if isVertical {
                arrowPoint.x = offset + bubbleView.width / 2 - arrowSize.width
                arrowPoint.y = isUp ? 0 : bubbleView.height
            } else {
                arrowPoint.x = isLeft ? 0 : bubbleView.width
                arrowPoint.y = bubbleView.height / 2 - arrowSize.height
            }
        case .trailing(let offset):
            if isVertical {
                arrowPoint.x = bubbleView.width - offset - arrowSize.width
                arrowPoint.y = 0
            } else {
                arrowPoint.x = 0
                arrowPoint.y = bubbleView.height - offset - arrowSize.height
            }
        }
    }
    
    private func updateBubbleShape() {
        let arrowX = arrowPoint.x
        let arrowY = arrowPoint.y
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let bubbleWidth = bubbleView.width
        let bubbleHeight = bubbleView.height
        let bubblePath = UIBezierPath()
        switch arrowDirection {
        case .up:
            bubblePath.move(to: CGPoint(x: 0, y: arrowY + arrowHeight))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius + arrowHeight),
                              radius: cornerRadius,
                              startAngle: -.pi,
                              endAngle: -.pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: arrowX, y: arrowY + arrowHeight))
            bubblePath.addLine(to: CGPoint(x: arrowX + arrowWidth / 2, y: 0))
            bubblePath.addLine(to: CGPoint(x: arrowX + arrowWidth, y: arrowY + arrowHeight))
            bubblePath.addLine(to: CGPoint(x: bubbleWidth, y: arrowY + arrowHeight))
            bubblePath.addArc(withCenter: CGPoint(x: bubbleWidth - cornerRadius, y: arrowHeight + cornerRadius),
                              radius: cornerRadius,
                              startAngle: -.pi_2,
                              endAngle: 0,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: bubbleWidth, y: bubbleHeight))
            bubblePath.addArc(withCenter: CGPoint(x: bubbleWidth - cornerRadius, y: bubbleHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: 0,
                              endAngle: .pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: 0, y: bubbleHeight))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius, y: bubbleHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: .pi_2,
                              endAngle: .pi,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: 0, y: arrowHeight))
        case .down:
            bubblePath.move(to: CGPoint(x: 0, y: 0))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                              radius: cornerRadius,
                              startAngle: -.pi,
                              endAngle: -.pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: bubbleWidth, y: 0))
            bubblePath.addArc(withCenter: CGPoint(x: bubbleWidth - cornerRadius, y: bubbleHeight - arrowHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: 0,
                              endAngle: .pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: arrowX + arrowWidth, y: bubbleHeight - arrowHeight))
            bubblePath.addLine(to: CGPoint(x: arrowX + arrowWidth / 2, y: bubbleHeight))
            bubblePath.addLine(to: CGPoint(x: arrowX, y: bubbleHeight - arrowHeight))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius, y: bubbleHeight - arrowHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: .pi_2,
                              endAngle: .pi,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: 0, y: bubbleHeight - arrowHeight))
        case .left:
            bubblePath.move(to: CGPoint(x: arrowHeight, y: 0))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius + arrowHeight, y: cornerRadius),
                              radius: cornerRadius,
                              startAngle: -.pi,
                              endAngle: -.pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: bubbleWidth, y: 0))
            bubblePath.addArc(withCenter: CGPoint(x: bubbleWidth - cornerRadius, y: cornerRadius),
                              radius: cornerRadius,
                              startAngle: 0,
                              endAngle: .pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: arrowHeight, y: bubbleHeight))
            bubblePath.addArc(withCenter: CGPoint(x: arrowHeight + cornerRadius, y: bubbleHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: .pi_2,
                              endAngle: .pi,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: arrowX + arrowHeight, y: arrowY + arrowWidth))
            bubblePath.addLine(to: CGPoint(x: arrowX, y: arrowY + arrowWidth / 2))
            bubblePath.addLine(to: CGPoint(x: arrowX + arrowHeight, y: arrowY))
            bubblePath.addLine(to: CGPoint(x: arrowHeight, y: 0))
        case .right:
            bubblePath.move(to: CGPoint(x: arrowHeight, y: 0))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                              radius: cornerRadius,
                              startAngle: -.pi,
                              endAngle: -.pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: bubbleWidth - arrowHeight, y: 0))
            bubblePath.addArc(withCenter: CGPoint(x: bubbleWidth - arrowHeight - cornerRadius, y: cornerRadius),
                              radius: cornerRadius,
                              startAngle: -.pi_2,
                              endAngle: 0,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: bubbleWidth - arrowHeight, y: arrowY))
            bubblePath.addLine(to: CGPoint(x: bubbleWidth, y: arrowY + arrowWidth / 2))
            bubblePath.addLine(to: CGPoint(x: bubbleWidth - arrowHeight, y: arrowY + arrowWidth))
            bubblePath.addLine(to: CGPoint(x: bubbleWidth - arrowHeight, y: arrowWidth))
            bubblePath.addArc(withCenter: CGPoint(x: bubbleWidth - arrowHeight - cornerRadius, y: bubbleHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: 0,
                              endAngle: .pi_2,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: 0, y: bubbleHeight))
            bubblePath.addArc(withCenter: CGPoint(x: cornerRadius, y: bubbleHeight - cornerRadius),
                              radius: cornerRadius,
                              startAngle: .pi_2,
                              endAngle: .pi,
                              clockwise: true)
            bubblePath.addLine(to: CGPoint(x: 0, y: 0))
        }
        bubbleLayer.path = bubblePath.cgPath
    }
    
}

extension BezierPathBubbleTipsView {
    
    public enum ArrowPosition {
        case leading(offset: CGFloat)
        case center(offset: CGFloat)
        case trailing(offset: CGFloat)
    }
    
    public enum ArrowDirection {
        case up
        case down
        case left
        case right
    }
}

#endif
