//
//  PhotoListTableViewController.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 1/10/18.
//  Copyright © 2018 ernie.cheng. All rights reserved.
//

import UIKit
import CoreImage

let dataSourceURL = "http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist"

class PhotoListTableViewController: UITableViewController {
    
    //  lazy var photos = NSDictionary(contentsOf: dataSourceURL! as URL)!
    var photos = [PhotoRecord]()
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Classis Photos"
        fetchPhotoDetails()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        if cell.accessoryView == nil {
            cell.accessoryView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        }
        // let rowKey = photos.allKeys[indexPath.row] as! String
        /* var image: UIImage?
        if let imageURL = NSURL(string:photos[rowKey] as! String), let imageData = NSData(contentsOf: imageURL as URL) {
            // 1
            let unfilteredImage = UIImage(data: imageData as Data)
            // 2
            image = self.appySepialFilter(image: unfilteredImage!)
        }
        cell.textLabel?.text = rowKey
        if let image = image {
         cell.imageView?.image = image
        } */
        cell.textLabel?.text = self.photos[indexPath.row].name
        cell.imageView?.image = self.photos[indexPath.row].image
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        switch photos[indexPath.row].state {
        case .Filtered:
            indicator.stopAnimating()
        case .Failed:
            indicator.stopAnimating()
            cell.textLabel?.text = "---"
        case .New, .Downloaded:
            indicator.stopAnimating()
            self.startOperationsForPhotoRecord(photoDetails: photos[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
    
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        case .Downloaded:
            startFiltrationForRecord(photoDetails: photoDetails, indexPath: indexPath)
        default:
            print("")
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        // 1 to see if there is already an operation in downloads in progress for it
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        // 2 create an instance of image downloader by using designated initial either
        let downloader = ImageDownloader(photoRecord: photoDetails)
        // 3
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        // 4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        // 5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltrationForRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        if let filterOperation = pendingOperations.filtrationsInProgress[indexPath] {
            return
        }
        let filterer = ImageFiltration(photoRecord: photoDetails)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
    
    func fetchPhotoDetails() {
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let url = URL(string: dataSourceURL) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // make the request
        let task =  session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error at session data task")
                return
            }
            guard let responseData = data else {
                print("Error: did not reive data")
                return
            }
            do {
            // You should unwrap your data object instead of checking it against nil. Also you need to implement do try catch error handling instead of forcing it:
                let datasourceDictionary = try PropertyListSerialization.propertyList(from: responseData, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSDictionary
                for (key, value) in datasourceDictionary {
                    if let imageName = key as? String, let imageUrl = URL(string: value as! String) {
                        let photoRecord = PhotoRecord(name: imageName,url: imageUrl)
                        self.photos.append(photoRecord)
                    }
                }
            } catch {
                print("error at parsing data")
                return
            }
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
//    func appySepialFilter(image: UIImage) -> UIImage {
//        let inputImage = CIImage(data: UIImagePNGRepresentation(image)!)
//        let context = CIContext(options: nil)
//        let filter = CIFilter(name: "CISepiaTone")
//        filter?.setValue(inputImage, forKey: kCIInputImageKey)
//        filter?.setValue(0.8, forKey: "inputIntensity")
//        if let outputImage = filter?.outputImage {
//            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
//            return UIImage(cgImage: outImage!)
//        }
//        return UIImage()
//    }
}
