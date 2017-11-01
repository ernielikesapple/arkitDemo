//
//  videoCollectionViewCell.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 11/1/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import UIKit

class videoCollectionViewCell: UICollectionViewCell {
    
    let thumbNail: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"lonelyMan")
        return iv
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame) // todo: why do we have to put this???
        setUpCellViews()
    }
    
    func setUpCellViews() {
        addSubview(thumbNail)
        thumbNail.frame = CGRect(x: 0,
                                 y: 0,
                                 width: 100,
                                 height: 100)
        
        
    }
    
    // todo: why do we have to put this???
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
