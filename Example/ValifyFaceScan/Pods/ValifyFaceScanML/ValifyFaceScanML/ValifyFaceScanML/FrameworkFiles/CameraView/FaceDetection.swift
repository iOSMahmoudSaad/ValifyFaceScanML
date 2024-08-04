//
//  FaceDetection.swift
//  ValifyFaceScanML
//
//  Created by Mahmoud Saad on 03/08/2024.
//

import UIKit
import Vision
import QuartzCore


extension CameraView {
    
    func detectFace(image: CVPixelBuffer, completion: @escaping ((_ isFace:Bool) -> ())) {
        
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { vnRequest, error in
            
            DispatchQueue.main.async {
                
                if let results = vnRequest.results as? [VNFaceObservation], results.count > 0 {
                    self.handleFaceDetectionResults(observedFaces: results)
                    completion(true)
                } else {
                    
                    self.clearDrawings()
                    completion(false)
                }
            }
        }
        
        let imageResultHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageResultHandler.perform([faceDetectionRequest])
    }
    
    private func handleFaceDetectionResults(observedFaces: [VNFaceObservation]) {
        
        clearDrawings()
        

        let facesBoundingBoxes: [CAShapeLayer] = observedFaces.map({ (observedFace: VNFaceObservation) -> CAShapeLayer in
            
            let faceBoundingBoxOnScreen = previewLayer.layerRectConverted(fromMetadataOutputRect: observedFace.boundingBox)
            let faceBoundingBoxPath = CGPath(rect: faceBoundingBoxOnScreen, transform: nil)
            let faceBoundingBoxShape = CAShapeLayer()
            

            faceBoundingBoxShape.path = faceBoundingBoxPath
            faceBoundingBoxShape.fillColor = UIColor.clear.cgColor
            faceBoundingBoxShape.strokeColor = UIColor.red.cgColor
            
            return faceBoundingBoxShape
        })
        
        facesBoundingBoxes.forEach { faceBoundingBox in
            
            view.layer.addSublayer(faceBoundingBox)
            
            drawings = facesBoundingBoxes
        }
    }
    
    private func clearDrawings() {
        
        drawings.forEach({ drawing in drawing.removeFromSuperlayer() })
    }
    
}
