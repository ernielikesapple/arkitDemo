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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
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
        let indicator = cell.accessoryView as! UIActivityIndicatorView

        let eachPhoto = self.photos[indexPath.row]
        cell.textLabel?.text = eachPhoto.name
        cell.imageView?.image = eachPhoto.image
        switch eachPhoto.state {
        case .Filtered:
            print("======666====")
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        case .Failed:
            print("======777====")
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
            cell.textLabel?.text = "---"
        case .New, .Downloaded:
            print("======888====")
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
            if(!tableView.isDragging && !tableView.isDecelerating) { // start operations only if the table view is not scrolling.
                self.startOperationsForPhotoRecord(photoDetails: eachPhoto, indexPath: indexPath)
            }
        }
        return cell
    }
    
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        switch (photoDetails.state) {
        case .New:
            print("11111111")
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        case .Downloaded:
            print("222222222")
            startFiltrationForRecord(photoDetails: photoDetails, indexPath: indexPath)
        default:
            print("do nothing")
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: IndexPath) {
        // 1 to see if there is already an operation in downloads in progress for it
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        // 2 create an instance of image downloader by using designated initial either
        let downloader = ImageDownloader(photoRecord: photoDetails)
        // 3 Add a completion block which will be executed when the operation is completed. This is a great place to let the rest of your app know that an operation has finished. It’s important to note that the completion block is executed even if the operation is cancelled, so you must check this property before doing anything. You also have no guarantee of which thread the completion block is called on, so you need to use GCD to trigger a reload of the table view on the main thread.
        //???????????????????????????????????????
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        // 4 Add the operation to downloadsInProgress to help keep track of things.
        pendingOperations.downloadsInProgress[indexPath] = downloader
        // 5 Add the operation to the download queue. This is how you actually get these operations to start running – the queue takes care of the scheduling for you once you’ve added the operation.
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let url = URL(string: dataSourceURL) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
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
                print("Error: did not receive data")
                return
            }
            do {
            // You should unwrap your data object instead of checking it against nil. Also you need to implement do try catch error handling instead of forcing it:
                let datasourceDictionary = try PropertyListSerialization.propertyList(from: responseData, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSDictionary
                for (key, value) in datasourceDictionary {
                    let imageName = key as? String
                    let imageUrl = URL(string: value as? String ?? "")
                    if imageName != nil && imageUrl != nil {
                        let photoRecord = PhotoRecord(name: imageName,url: imageUrl)
                        self.photos.append(photoRecord)
                        print("llllllllll")
                    }
                    print("llllllllll88888")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                print("llllllllll888880000000")
            } catch {
                print("error at parsing data")
                return
            }
            // UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
    // the dragging and decelerating properties because UITableView is a subclass of UIScrollView delegate methods to the class
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 1 when the user starts scrolling you will want to suspend all operations and take a look at what the user wants to see.
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2 when the user stops dragging the table view.
        if (!decelerate) {
            loadImagesForOnScreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnScreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    func loadImagesForOnScreenCells() {
        // 1
        if let pathsArray = tableView.indexPathsForVisibleRows {
            // 2
            var allPendingOperations = Set(Array(pendingOperations.downloadsInProgress.keys))
            allPendingOperations.union(Array(pendingOperations.filtrationsInProgress.keys))
            
            // 3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray as [IndexPath])
            toBeCancelled.subtract(visiblePaths)
            
            // 4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations) //
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let indexPath = indexPath as IndexPath
                let recordToProcess = self.photos[indexPath.row]
                startOperationsForPhotoRecord(photoDetails: recordToProcess, indexPath: indexPath)
            }
            
        }
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
