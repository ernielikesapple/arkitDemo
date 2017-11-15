//
//  ViewController.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 9/20/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    var variableTakeAFunction: Any? = nil
//
//        = { params in
//        print("sth\(params)")
//    }
    
    func funcitonNeedtoAssignToAVar(params: String) -> Void {
        print("sth is \(params)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        variableTakeAFunction = funcitonNeedtoAssignToAVar(params: "Hello")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

