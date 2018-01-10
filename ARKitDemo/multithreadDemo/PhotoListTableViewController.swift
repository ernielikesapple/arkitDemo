//
//  PhotoListTableViewController.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 1/10/18.
//  Copyright © 2018 ernie.cheng. All rights reserved.
//

import UIKit
import CoreImage

let dataSourceURL = NSURL(string: "http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")

class PhotoListTableViewController: UITableViewController {
    
    lazy var photos = NSDictionary(contentsOf: dataSourceURL! as URL)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Classis Photos"
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let rowKey = photos.allKeys[indexPath.row] as! String
        var image: UIImage?
        if let imageURL = NSURL(string:photos[rowKey] as! String), let imageData = NSData(contentsOf: imageURL as URL) {
            // 1
            let unfilteredImage = UIImage(data: imageData as Data)
            // 2
            image = self.appySepialFilter(image: unfilteredImage!)
        }
        
        cell.textLabel?.text = rowKey
        if let image = image {
         cell.imageView?.image = image
        }
        
        return cell
    }
    
    func appySepialFilter(image: UIImage) -> UIImage {
        let inputImage = CIImage(data: UIImagePNGRepresentation(image)!)
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: "inputIntensity")
        if let outputImage = filter?.outputImage {
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: outImage!)
        }
        return UIImage()
    }
}
