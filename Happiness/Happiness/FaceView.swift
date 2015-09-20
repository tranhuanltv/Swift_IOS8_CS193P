//
//  FaceView.swift
//  Happiness
//
//  Created by HuanTran on 9/19/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var lineWidth : CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color : UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var scale : CGFloat = 0.90 { didSet { setNeedsDisplay() } }

    private struct Scalling {
        static let FaceRadiusToEyeRadiusRatio : CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio : CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio : CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio : CGFloat = 1
        static let FaceRadiusToMouthHeightRatio : CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio : CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye : Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scalling.FaceRadiusToEyeRadiusRatio;
        let eyeVerticalOffset = faceRadius / Scalling.FaceRadiusToEyeOffsetRatio;
        let eyeHorizontalSeperation = faceRadius / Scalling.FaceRadiusToEyeSeperationRatio;
        
        var eyeCenter = faceCenter;
        eyeCenter.y -= eyeVerticalOffset;
        
        switch whichEye {
        case .Left:
            eyeCenter.x -= eyeHorizontalSeperation / 2;
        case .Right:
            eyeCenter.x += eyeHorizontalSeperation / 2;
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile : Double) -> UIBezierPath {
        let mouthWidth = faceRadius / Scalling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scalling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scalling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    var faceCenter : CGPoint {
        return convertPoint(center, fromCoordinateSpace: superview!)
    }
    
    var faceRadius : CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale;
    }
    
    override func drawRect(rect: CGRect)
    {
        let path = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        color.set()
        path.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness = 0.75
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
    
}
