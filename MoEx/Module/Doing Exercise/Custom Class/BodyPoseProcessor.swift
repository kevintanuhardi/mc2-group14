//
//  HandGestureProcessor.swift
//  MoEx
//
//  Created by Randy Efan Jayaputra on 17/06/21.
//

import CoreGraphics

class BodyPoseProcessor{
    
    typealias AngleAxis = (firstAxis: CGPoint, secondAxis: CGPoint, thirdAxis: CGPoint)
    
    //calculate the third axix / center
    static func calculateAngle(first: CGPoint, second: CGPoint, center: CGPoint) -> Double{
        let xDistA = center.x - second.x
        let yDistA = center.y - second.y
        let a = sqrt((xDistA * xDistA) + (yDistA * yDistA))
        
        let xDistB = first.x - second.x
        let yDistB = first.y - second.y
        let b = sqrt((xDistB * xDistB) + (yDistB * yDistB))
        
        let xDistC = center.x - first.x
        let yDistC = center.y - first.y
        let c = sqrt((xDistC * xDistC) + (yDistC * yDistC))
        
        let angleRad = acos(((a*a) + (c*c) - (b*b)) / ((2*a*c)))
        var angleDeg = (Double(angleRad) * 180)/Double.pi
        if angleDeg < 0 {
            angleDeg += 180
        }
        return angleDeg
        
    }
    
    func processPoints(_ angleAxis: AngleAxis) -> Double {
        let firstAxis = angleAxis.firstAxis
        let secondAxis = angleAxis.secondAxis
        let center = angleAxis.thirdAxis
        
        let angle = BodyPoseProcessor.calculateAngle(first: firstAxis, second: secondAxis, center: center)
        print("angle", angle)
        return angle
    }
}

// MARK: - CGPoint helpers
extension CGPoint {
    
    static func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
}
