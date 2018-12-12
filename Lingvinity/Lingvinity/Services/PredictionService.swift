//
//  PredictionService.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 11/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class PredictionService {
    
    var model: MobileNet!
    
    typealias Prediction = (String, Double)
    
    func loadModel() {
        model = MobileNet()
    }
    
    func getTopPredictionResults(for image: UIImage) -> (convertedImage: UIImage, predictions: [Prediction])? {
        
        let convertionResult = self.convertImageFormat(for: image)
        if convertionResult == nil {
            return nil
        }
        
        guard let prediction = try? model.prediction(image: (convertionResult?.pixelBuffer)!) else {
            return nil
        }
        
        print("prediction top 5:")
        let top5 = self.top(number: 5, prediction.classLabelProbs)
        print(top5)
        
        return (convertionResult!.newImage, top5)
        
    }
    
    func top(number k: Int, _ prob: [String: Double]) -> [Prediction] {
        precondition(k <= prob.count)
        
        return Array(prob.map { x in (x.key, x.value) }
            .sorted(by: { a, b -> Bool in a.1 > b.1 })
            .prefix(through: k - 1))
    }
    
    func convertImageFormat(for image: UIImage) -> (newImage: UIImage, pixelBuffer: CVPixelBuffer)? {
        
        // TODO: fix image size on storybord to 224x224
        
        let widthToConvert = 224
        let heightToConvert = 224
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: widthToConvert, height: heightToConvert), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: widthToConvert, height: heightToConvert))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return (newImage, pixelBuffer!)
    }
    
}
