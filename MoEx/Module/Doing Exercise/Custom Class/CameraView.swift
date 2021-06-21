//
//  CameraView.swift
//  MoEx
//
//  Created by Randy Efan Jayaputra on 17/06/21.
//

import UIKit
import AVFoundation

class CameraView: UIView {

    private var overlayLayer = CAShapeLayer()
    private var pointsPath = UIBezierPath()

    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOverlay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOverlay()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == previewLayer {
            overlayLayer.frame = layer.bounds
        }
    }

    private func setupOverlay() {
        previewLayer.addSublayer(overlayLayer)
    }
    
    func showPoints(_ points: [CGPoint], maidPoints: CGPoint = .zero, color: UIColor) {
        pointsPath.removeAllPoints()
        guard var currentPoint = points.first else {return}
        
        pointsPath.move(to: maidPoints)
        pointsPath.addArc(withCenter: maidPoints, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        for point in points {
            if overlayLayer.contains(point) {
                let newPoint = point
                pointsPath.move(to: currentPoint)
                pointsPath.addArc(withCenter: newPoint, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                pointsPath.addLine(to: newPoint)
                currentPoint = newPoint
            } else {
                removeAllPath()
                return
            }
        }
        
        overlayLayer.fillColor = color.cgColor
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        overlayLayer.path = pointsPath.cgPath
        CATransaction.commit()
    }
    
    func removeAllPath() {
        overlayLayer.path = nil
    }
}