//
//  ViewController.swift
//  PhotobookCreator
//
//  Created by Keith Moon [Contractor] on 5/4/17.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    let builder = PhotoBookBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let bundle = Bundle.main
        
        guard let samplePhotosFolderPath = bundle.resourcePath?.appending("/SamplePhotos/") else { return }
        guard let photoPaths = try? fileManager.contentsOfDirectory(atPath: samplePhotosFolderPath) else { return }
        
        let photos = photoPaths.flatMap { UIImage(contentsOfFile: samplePhotosFolderPath.appending($0)) }
        
        let now = Date()
        let photobookURL = builder.buildPhotobook(with: photos)
        
        let previewController = UIDocumentInteractionController(url: photobookURL)
        previewController.delegate = self
        previewController.presentPreview(animated: true)
        
        let duration = now.timeIntervalSinceNow
        print("Duration: \(duration)")
    }
    
}

extension ViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return navigationController!
    }
}
