//
//  youtubeHomePageVC.swift
//  ARKitDemo
//
//  Created by ernie on 31/10/2017.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import UIKit

class youtubeHomePageVC: UICollectionViewController {
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        collectionView?.register(videoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
}

// grid based layout, delegate to allow you change the size and space between the items
extension youtubeHomePageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
