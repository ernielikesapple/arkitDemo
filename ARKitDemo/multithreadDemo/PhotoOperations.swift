//
//  PhotoOperations.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 1/10/18.
//  Copyright © 2018 ernie.cheng. All rights reserved.
//

import UIKit

// represent each photo displayed in the app,
enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class PhotoRecord {
    let name: String?
    let url: URL?
    var state = PhotoRecordState.New
    var image = UIImage(named: "blueTruck")
    
    init(name: String?, url: URL?) {
        self.name = name
        self.url = url
    }
}

// to tack the status of each operation
// contains two dictionaries to keep track of active and pending download and filter operations for each row in the table
// and two operation queues for each type of operation
class PendingOperations {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
       var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        //        The maxConcurrentOperationCount is set to 1 here for the sake of this tutorial, to allow you to see operations finishing one by one. You could leave this part out to allow the queue to decide how many operations it can handle at once – this would further improve performance.
        //        How does the queue decide how many operations it can run at once? That’s a good question! :] It depends on the hardware. By default, NSOperationQueue will do some calculation behind the scenes, decide what is best for the particular platform the code is running on, and will launch the maximum possible number of threads.
        return queue
    }()
    
    lazy var filtrationsInProgress = [IndexPath:Operation]()
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
// why you have to keep track of all active and pending operations. The queue has an operations method which returns an array of operations, so why not use that? In this project it won’t be very efficient to do so. You need to track which operations are associated with which table view rows, which would involve iterating over the array each time you needed one. Storing them in a dictionary with the index path as a key means lookup is fast and efficient

class ImageDownloader: Operation {
    let photoRecord: PhotoRecord
    // 1 add a constant reference to the PhotoRecord object related to the operation
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    // override the main method in Operation subclass to actually perform work
    override func main() {
        // check for cancellation before staring. Operations should regularly check if they have been cancelled before attempting long or intensive work
        guard self.isCancelled else {
            return
        }
        // Download the image data
        var imageData = Data()
        if let url = self.photoRecord.url {
            do {
                imageData = try Data(contentsOf: url)
            } catch {
                print("there is no image data")
            }
        }
        // check again for cancellation
        guard self.isCancelled else {
            return
        }
        // if there is data, create an image object and add it to the record and move the state along, if there is no data, mark the record as failed and set the appropriate image.
        if imageData.count > 0 {
            self.photoRecord.image = UIImage(data: imageData as Data)
            self.photoRecord.state = .Downloaded
        } else {
            self.photoRecord.state = .Failed
            self.photoRecord.image = UIImage(named: "blueTruck")
        }
    }
}

class ImageFiltration: Operation {
    let photoRecord: PhotoRecord
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    override func main() {
        guard self.isCancelled else {
            return
        }
        if self.photoRecord.state != .Downloaded {
            return
        }
        if let filteredImage = self.appySepialFilter(image: self.photoRecord.image) {
            self.photoRecord.image = filteredImage
            self.photoRecord.state = .Filtered
        }
    }
    
    func appySepialFilter(image: UIImage?) -> UIImage? {
        guard self.isCancelled else {
            return nil
        }
        if let image = image {
            let inputImage = CIImage(data: UIImagePNGRepresentation(image)!)
            let context = CIContext(options: nil)
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(0.8, forKey: "inputIntensity")
            if let outputImage = filter?.outputImage {
                guard self.isCancelled else { // do cancellation check before and after any expensive method call.
                    return nil
                }
                let outImage = context.createCGImage(outputImage, from: outputImage.extent)
                return UIImage(cgImage: outImage!)
            }
        }
        return UIImage()
    }
}

