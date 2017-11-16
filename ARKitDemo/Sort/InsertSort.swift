//
//  InsertSort.swift
//  ARKitDemo
//
//  Created by ernie.cheng on 11/16/17.
//  Copyright © 2017 ernie.cheng. All rights reserved.
//

class InsertSort {
//    static let shared = InsertSort()
//    private init() {
//    }
    
    
    
    
    // actually we can do the sort in one line of code just use sortedList.sort()
    func insertionSort(alist: [Int]) -> [Int] {
        var sortedList = alist
        for i in 1..<sortedList.count {
            let tmp = sortedList[i]
            var j = i - 1
            while (j >= 0 && sortedList[j] > tmp) {
                sortedList[j+1] = sortedList[j]
                j = j - 1
            }
            sortedList[j+1] = tmp
        }
        return sortedList
    }
    
}

//extension InsertSort {
//
//}

