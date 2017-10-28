//
//  webComponentVC.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 10/28/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import UIKit
import WebKit

class webComponentVC: UIViewController {

    @IBOutlet var wkView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.google.com")
        let request = NSURLRequest(url: url!)
        wkView.load(request as URLRequest)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
