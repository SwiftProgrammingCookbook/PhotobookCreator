//
//  PhotoResizer.swift
//  PhotobookCreator
//
//  Created by Keith Moon on 05/05/2017.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit
import CoreImage

class PhotoResizer {
    
    let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])
    
    func scaleToSmallest(of photos: [UIImage]) -> [UIImage] {
        
        var smallestHeight = CGFloat.greatestFiniteMagnitude
        var smallestWidth = CGFloat.greatestFiniteMagnitude
        
        photos.forEach { photo in
            smallestHeight = min(smallestHeight, photo.size.height)
            smallestWidth = min(smallestWidth, photo.size.width)
        }
        
        let scaledImages: [UIImage] = photos.flatMap { photo in
            
            guard let cgImage = photo.cgImage else { return nil }
            
            // Calculate scale needed to fit the closest smallest dimension
            let heightScale = smallestHeight / photo.size.height
            let weightScale = smallestWidth / photo.size.width
            let heightScaleDifference = abs(1 - heightScale)
            let weightScaleDifference = abs(1 - weightScale)
            
            let closestScale = heightScaleDifference < weightScaleDifference ? heightScale: weightScale
            let image = CIImage(cgImage: cgImage)
            
            let filter = CIFilter(name: "CILanczosScaleTransform")!
            filter.setValue(image, forKey: "inputImage")
            filter.setValue(closestScale, forKey: "inputScale")
            filter.setValue(1.0, forKey: "inputAspectRatio")
            
            guard let outputImage = filter.value(forKey: "outputImage") as? CIImage else { return nil }
            guard let scaledCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
            
            let scaledUIImage = UIImage(cgImage: scaledCGImage)
            return scaledUIImage
        }
        
        return scaledImages
    }
    
    func cropToSmallest(of photos: [UIImage]) -> [UIImage] {
        
        var smallestHeight = CGFloat.greatestFiniteMagnitude
        var smallestWidth = CGFloat.greatestFiniteMagnitude
        
        photos.forEach { photo in
            smallestHeight = min(smallestHeight, photo.size.height)
            smallestWidth = min(smallestWidth, photo.size.width)
        }
        
        let croppedImages: [UIImage] = photos.flatMap { photo in
            
            guard let cgImage = photo.cgImage else { return nil }
            
            // Calculate center crop rect
            let x = (photo.size.width - smallestWidth) / 2
            let y = (photo.size.height - smallestHeight) / 2
            let croppingRect = CGRect(x: x, y: y, width: smallestWidth, height: smallestHeight)
            
            let croppedImage = CIImage(cgImage: cgImage).cropping(to: croppingRect)
            
            guard let scaledCGImage = context.createCGImage(croppedImage, from: croppedImage.extent) else { return nil }
            let scaledUIImage = UIImage(cgImage: scaledCGImage)
            return scaledUIImage
        }
        return croppedImages
    }
}
