//
//  LibraryApi.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 10/19/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//
import Foundation
import UIKit

final class LibraryApi {
    
    // make the initializer as private then add a static property for the shared instance, in this way we will get a singleton
    static let shared = LibraryApi()
    
    private init() {
    
    }

}
