//
//  PhotoCollectionViewController.swift.swift
//  PhotobookCreator
//
//  Created by Keith Moon [Contractor] on 5/4/17.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit
import QuartzCore

class PhotoCollectionViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var photos = [UIImage]()
    
    let builder = PhotoBookBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let bundle = Bundle.main
        
        guard let samplePhotosFolderPath = bundle.resourcePath?.appending("/SamplePhotos/") else { return }
        guard let photoPaths = try? fileManager.contentsOfDirectory(atPath: samplePhotosFolderPath) else { return }
        
        photos = photoPaths.flatMap { UIImage(contentsOfFile: samplePhotosFolderPath.appending($0)) }
    }
    
    @IBAction func generateButtonPressed(sender: UIBarButtonItem) {
        generatePhotoBook()
    }
    
    
    func generatePhotoBook() {
        
        let resizedPhotos = resizeAndCropToSmallest(of: photos)
        
        let now = Date()
        let photobookURL = builder.buildPhotobook(with: resizedPhotos)
        
        let previewController = UIDocumentInteractionController(url: photobookURL)
        previewController.delegate = self
        previewController.presentPreview(animated: true)
        
        let duration = now.timeIntervalSinceNow
        print("Duration: \(duration)")
    }
}

extension PhotoCollectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let photo = photos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        cell.imageView?.image = photo
        cell.textLabel?.text = "\(photo.size.width) x \(photo.size.height)"
        return cell
    }
    
}

extension PhotoCollectionViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return navigationController!
    }
}
