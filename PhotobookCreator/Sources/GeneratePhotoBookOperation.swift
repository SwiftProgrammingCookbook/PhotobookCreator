//
//  GeneratePhotoBookOperation.swift
//  PhotobookCreator
//
//  Created by Keith Moon on 11/05/2017.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit

class GeneratePhotoBookOperation: Operation {
    
    let builder: PhotoBookBuilder
    let photos: NSMutableArray
    var photobookURL: URL?
    
    init(builder: PhotoBookBuilder, photos: NSMutableArray) {
        self.builder = builder
        self.photos = photos
    }
    
    override func main() {
        
        guard let photos = photos as? [UIImage] else { return }
        
        // Generate PDF (can take a while)
        photobookURL = builder.buildPhotobook(with: photos)
    }
    
}
