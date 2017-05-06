//
//  PhotoResizer.swift
//  PhotobookCreator
//
//  Created by Keith Moon on 05/05/2017.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit
import CoreImage

func resizeAndCropToSmallest(of photos: [UIImage]) -> [UIImage] {
    
    var smallestHeight = CGFloat.greatestFiniteMagnitude
    var smallestWidth = CGFloat.greatestFiniteMagnitude
    
    photos.forEach { photo in
        smallestHeight = min(smallestHeight, photo.size.height)
        smallestWidth = min(smallestWidth, photo.size.width)
    }
    
    let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])
    
    let scaledImages: [UIImage] = photos.flatMap { photo in
        
        guard let cgImage = photo.cgImage else { return nil }
        
        // Calculate scale needed to fit the closest smallest dimension
        let heightScale = smallestHeight / photo.size.height
        let weightScale = smallestWidth / photo.size.width
        let heightScaleDifference = abs(1 - heightScale)
        let weightScaleDifference = abs(1 - weightScale)
        
        let closestScale = heightScaleDifference < weightScaleDifference ? heightScale: weightScale
        
        print("--------------------------")
        print("Image Size: \(photo.size)")
        print("Height Scale: \(heightScale)")
        print("Weight Scale: \(weightScale)")
        print("Height Scale Diff: \(heightScaleDifference)")
        print("Weight Scale Diff: \(weightScaleDifference)")
        print("Closest Scale: \(closestScale)")
        print("+++++++++++++++++++++")
        
        let image = CIImage(cgImage: cgImage)
        
        print("CIImage: \(image)")
        
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: "inputImage")
        filter.setValue(closestScale, forKey: "inputScale")
        filter.setValue(1.0, forKey: "inputAspectRatio")
        guard let outputImage = filter.value(forKey: "outputImage") as? CIImage else { return nil }
        
        print("Scaled CIImage: \(outputImage)")
        
        guard let scaledCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        print("Scaled CGImage: \(scaledCGImage)")
        
        let scaledUIImage = UIImage(cgImage: scaledCGImage)
        
        print("Scaled UIImage: \(scaledUIImage)")
        
        return scaledUIImage
    }
    
    return scaledImages
}
