//
//  extensions.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/4/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation

import UIKit
extension UIImageView {
    
    func addCurvedView(imageview: UIImageView ,backgroundColor: UIColor = .white,
                       curveRadius: CGFloat = 17,
                       shadowColor: UIColor = .darkGray,
                       shadowRadius: CGFloat = 4,
                       heightOffset: CGFloat = 0) {
        
        // Without navigation controller we cannot continue. Also make sure layer do not exist already.
        
        
        // Get needed sizes with respect to device screen
        let screenWidth = UIScreen.main.bounds.size.width
        let totalHeight = imageview.frame.size.height + heightOffset
        let y1: CGFloat = totalHeight
        let y2: CGFloat = totalHeight + curveRadius
        
        // Create shape layer to hold curve path
        let pathLayer = CAShapeLayer()
        pathLayer.fillColor = backgroundColor.cgColor
        pathLayer.path = UIBezierPath().topCurvePath(width: screenWidth, y1: y1, y2: y2).cgPath
        
        // Create shadow layer
        let shadowLayer = CALayer().addShadowLayer(name: "curved_view", shapeLayer: pathLayer, radius: shadowRadius, color: shadowColor)
        
        // Add to view
        imageview.layer.addSublayer(shadowLayer)
    }
}


extension UIBezierPath {
    
    func topCurvePath(width: CGFloat, y1: CGFloat, y2: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: y1))
        path.addCurve(to: CGPoint(x: width / 2 , y: y2), controlPoint1: CGPoint(x: 0, y: y1), controlPoint2: CGPoint(x:width / 4, y: y2))
        path.addCurve(to: CGPoint(x: width, y: y1), controlPoint1: CGPoint(x: width * 0.75, y: y2), controlPoint2: CGPoint(x: width, y: y1))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x:0, y: 0))
        path.addLine(to: CGPoint(x:0, y: y1))
        path.stroke()
        return path
    }
}
extension CALayer {
    
    func addShadowLayer(name: String, shapeLayer: CAShapeLayer, radius: CGFloat, color: UIColor) -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.insertSublayer(shapeLayer, at: 0)
        shadowLayer.name = name
        return shadowLayer
    }
}
