//
//  String+Extension.swift
//  ARKitDemo
//
//  Created by ernie on 3/10/2017.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail :Bool {
        
        // a regular expression to make sure the email format is correct
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0.9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with:self)
    }
    
}
