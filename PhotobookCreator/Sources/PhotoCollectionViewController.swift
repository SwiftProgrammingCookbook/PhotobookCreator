//
//  PhotoCollectionViewController.swift.swift
//  PhotobookCreator
//
//  Created by Keith Moon [Contractor] on 5/4/17.
//  Copyright © 2017 Keith Moon. All rights reserved.
//

import UIKit
import QuartzCore
import Dispatch

class PhotoCollectionViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let bundle = Bundle.main
        
        guard let samplePhotosFolderPath = bundle.resourcePath?.appending("/SamplePhotos/") else { return }
        guard let photoPaths = try? fileManager.contentsOfDirectory(atPath: samplePhotosFolderPath) else { return }
        
        photos = photoPaths.flatMap { UIImage(contentsOfFile: samplePhotosFolderPath.appending($0)) }
        
        // Setup Activity Indicator
        activityIndicator.hidesWhenStopped = true
        let barButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @IBAction func generateButtonPressed(sender: UIBarButtonItem) {
        
        activityIndicator.startAnimating()
        
        generatePhotoBook(with: photos) { [activityIndicator] photobookURL in
            
            activityIndicator.stopAnimating()
            
            let previewController = UIDocumentInteractionController(url: photobookURL)
            previewController.delegate = self
            previewController.presentPreview(animated: true)
        }
    }
    
    let processingQueue = DispatchQueue(label: "Photo processing queue")
    
    func generatePhotoBook(with photos: [UIImage], completion: @escaping (URL) -> Void) {
        
        processingQueue.async {
            
            let now = Date()
            
            let resizer = PhotoResizer()
            let builder = PhotoBookBuilder()
            
            // Scale down (can take a while)
            var photosForBook = resizer.scaleToSmallest(of: photos)
            // Crop (can take a while)
            photosForBook = resizer.cropToSmallest(of: photosForBook)
            // Generate PDF (can take a while)
            let photobookURL = builder.buildPhotobook(with: photosForBook)
            
            let duration = now.timeIntervalSinceNow
            print("Duration: \(duration)")
            
            DispatchQueue.main.async {
                completion(photobookURL)
            }
        }
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
        cell.textLabel?.text = "\(Int(photo.size.width)) x \(Int(photo.size.height))"
        return cell
    }
}

extension PhotoCollectionViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return navigationController!
    }
}
