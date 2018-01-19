//
//  Alert.swift
//  ARKitDemo
//
//  Created by ernie on 3/10/2017.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)    // git commit --amend try, tried day2 now try day3
    }
}
