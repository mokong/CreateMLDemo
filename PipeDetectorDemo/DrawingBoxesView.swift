//
//  DrawingBoxesView.swift
//  PipeDetectorDemo
//
//  Created by Horizon on 30/09/2022.
//

import UIKit
import Vision

class DrawingBoxesView: UIView {
    
    func removeBox() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    func drawBox(with predictions: [VNRecognizedObjectObservation]) {
//        removeBox()
        
        predictions.forEach { drawBox(with: $0) }
    }
    
    private func drawBox(with prediction: VNRecognizedObjectObservation) {
        let scale = CGAffineTransform.identity.scaledBy(x: bounds.width, y: bounds.height)
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
        
        let rectangle = prediction.boundingBox.applying(transform).applying(scale)
        
        let newLayer = CALayer()
        newLayer.frame = rectangle
        
        newLayer.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        newLayer.cornerRadius = 4.0
        
        layer.addSublayer(newLayer)
    }

}
