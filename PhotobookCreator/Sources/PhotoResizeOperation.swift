//
//  PhotoResizeOperation.swift
//  PhotobookCreator
//
//  Created by Keith Moon on 10/05/2017.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit

class PhotoResizeOperation: Operation {
    
    let resizer: PhotoResizer
    let size: CGSize
    let photos: NSMutableArray
    let photoIndex: Int
    
    init(resizer: PhotoResizer, size: CGSize, photos: NSMutableArray, photoIndex: Int) {
        self.resizer = resizer
        self.size = size
        self.photos = photos
        self.photoIndex = photoIndex
    }
    
    override func main() {
        
        // Check if operation has been cancelled
        guard isCancelled == false else { return }
        
        guard let photo = photos[photoIndex] as? UIImage else { return }
        // Scale down (can take a while)
        var photosForBook = resizer.scaleWithAspectFill([photo], to: size)
        
        // Check if operation has been cancelled
        guard isCancelled == false else { return }
        
        // Crop (can take a while)
        photosForBook = resizer.centerCrop(photosForBook, to: size)
        
        photos[photoIndex] = photosForBook[0]
    }
}
