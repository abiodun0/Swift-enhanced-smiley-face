//
//  OscarFace.swift
//  OscarNewFaceView
//
//  Created by Abiodun Shuaib on 05/06/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smileness(smile: OscarFace) -> Double
}

@IBDesignable
class OscarFace: UIView {
    var dataSource: FaceViewDataSource?
    
    @IBInspectable
    var eyesOpen: Bool = false {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var eyeBrowTilt: Double = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var color: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var authencityOfsmile:Double = 50.0{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var  scale: CGFloat = 0.9 {
        
        didSet{
            setNeedsDisplay()
        }
    }

    var radius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }

    
    var oscarFaceCenter: CGPoint {
        get {
            return self.convertPoint(self.center, fromView: superview)
        }
    }
    override func awakeFromNib() {
        self.contentMode = UIViewContentMode.Redraw
        backgroundColor = UIColor.greenColor()
    }
    
    enum Eye {
        case Left, Right
    }
    private struct Ratios {
        static let FaceRadiusToEyeRadiusRatio:CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio:CGFloat = 2.0
        
        static let FaceRadiusToNoseOffsetRatio:CGFloat = 6
        static let faceRadiusToNoseLengthRatio:CGFloat = 4.0
        
        static let faceRadiusToMouthOffsetRatio:CGFloat = 2
        static let faceRadiusToMouthHeightRatio:CGFloat = 4
        
        static let faceRadiusToBrowOffset:CGFloat = 5

    }
    private func bezierPathForBrow(whichEye: Eye) -> UIBezierPath {
        let browRadius = radius  / Ratios.FaceRadiusToEyeRadiusRatio
        let browVerticalOffset = radius / Ratios.faceRadiusToBrowOffset
        var tilt = eyeBrowTilt
        switch whichEye {
        case .Left: tilt = tilt * -1.0
        case .Right: break
        }
        var browCenter = getEyeCenter(whichEye)
        browCenter.y -= browVerticalOffset
        let browHeight = CGFloat(max(min(tilt, 1), -1)) * browRadius/2
        let startPoint = CGPoint(x: browCenter.x - browRadius, y: browCenter.y - browHeight)
        let endPoint = CGPoint(x: browCenter.x + browRadius, y: browCenter.y + browHeight)
        let browPath = UIBezierPath()
        browPath.moveToPoint(startPoint)
        browPath.addLineToPoint(endPoint)
        browPath.lineWidth = lineWidth
        
        return browPath
    }
    
    private func getEyeCenter(whichEye: Eye) -> CGPoint {
        let seperationOfTheEyez = radius / Ratios.FaceRadiusToEyeSeperationRatio
        let verticalOffset = radius / Ratios.FaceRadiusToEyeOffsetRatio        
        var eyeCenter: CGPoint = oscarFaceCenter
        eyeCenter.y -= verticalOffset
        switch whichEye {
        case .Left:
            eyeCenter = CGPoint(x: eyeCenter.x - seperationOfTheEyez, y: eyeCenter.y)
        case .Right:
            eyeCenter = CGPoint(x: eyeCenter.x + seperationOfTheEyez, y: eyeCenter.y)
            
        }
        return eyeCenter
    }
    private func beizerPathForEye(whichEye: Eye) -> UIBezierPath {
        
        
        let eyeCenter = getEyeCenter(whichEye)
        let eyeRadius = radius / CGFloat(Ratios.FaceRadiusToEyeRadiusRatio)

        let eyeCircle: UIBezierPath!
        if eyesOpen {
             eyeCircle = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(2*M_PI), clockwise: true)
        }
        else {
            eyeCircle = UIBezierPath()
            eyeCircle.moveToPoint(CGPoint(x:eyeCenter.x - eyeRadius, y: eyeCenter.y))
            eyeCircle.addLineToPoint(CGPoint(x:eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        eyeCircle.lineWidth = lineWidth
        return eyeCircle

    }
    
    private func beizerPathForNose() -> UIBezierPath {
        let noseLength = radius / Ratios.FaceRadiusToNoseOffsetRatio
        let noseSepration = radius / Ratios.faceRadiusToNoseLengthRatio
        let imaginaryNoseOffset = CGPoint(x: oscarFaceCenter.x, y: oscarFaceCenter.y - noseLength)
        let nosePath = UIBezierPath()
        nosePath.moveToPoint(imaginaryNoseOffset)
        nosePath.addLineToPoint(CGPoint(x:oscarFaceCenter.x - noseSepration, y: oscarFaceCenter.y + noseLength ))
        let endPoint = CGPoint(x:oscarFaceCenter.x + noseSepration, y: oscarFaceCenter.y + noseLength)
        let cp1 = CGPoint(x:oscarFaceCenter.x - noseSepration/3, y: oscarFaceCenter.y + noseLength + 12 )
        let cp2 = CGPoint(x:endPoint.x - noseSepration/3, y: oscarFaceCenter.y + noseLength + 12)
        nosePath.addCurveToPoint(endPoint, controlPoint1: cp1, controlPoint2: cp2)
        nosePath.closePath()
        nosePath.lineWidth = lineWidth
        
        return nosePath
        
    }
    
    private func beizerPathForMouth(smileness: Double) -> UIBezierPath {
        let mouthWidth = radius
        let mouthOffset = radius / Ratios.faceRadiusToMouthOffsetRatio
        let mouthHeightRatio = radius / Ratios.faceRadiusToMouthHeightRatio
        
        let smileHeight = CGFloat(max(min(smileness, 1), -1)) * mouthHeightRatio
        let start = CGPoint(x: oscarFaceCenter.x - mouthWidth/2, y: oscarFaceCenter.y + mouthOffset)
        let end = CGPoint(x: oscarFaceCenter.x + mouthWidth/2 , y: start.y)
        let cp1 = CGPoint(x:start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth/3, y: cp1.y)
        
        let mouthPath = UIBezierPath()
        mouthPath.moveToPoint(start)
        mouthPath.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = lineWidth
        return mouthPath
        
        
    }


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let faceCircle = UIBezierPath(arcCenter: oscarFaceCenter, radius: radius, startAngle: CGFloat(0.0), endAngle: CGFloat(2*M_PI), clockwise: true)
        color.set()
        faceCircle.lineWidth = lineWidth
        faceCircle.stroke()
        beizerPathForEye(.Left).stroke()
        beizerPathForEye(.Right).stroke()
        beizerPathForNose().stroke()
        let smileForMeorNah = dataSource?.smileness(self) ?? authencityOfsmile
        beizerPathForMouth(smileForMeorNah).stroke()
        bezierPathForBrow(.Left).stroke()
        bezierPathForBrow(.Right).stroke()
    }


}
