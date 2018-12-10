//
//  ArrayExtension.swift
//  Project
//
//  Created by 张凯强 on 2018/5/30.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation


extension Array where Element: Comparable {
    func rmoveObject<T>(object: T) {
        
    }
    mutating func mergeSort(begin: Index, end: Index) {
        var tmp: [Element] = []
        tmp.reserveCapacity(count)
        
        func merge(begin: Index, mid: Index, end: Index) {
            tmp.removeAll(keepingCapacity: true)
            var i = begin
            var j = mid
            while i != mid && j != end {
                if self[i] < self[j] {
                    tmp.append(self[i])
                    i += 1
                }else {
                    tmp.append(self[j])
                    j += 1
                }
            }
            tmp.append(contentsOf: self[i ..< mid])
            tmp.append(contentsOf: self[j ..< end])
            replaceSubrange(begin..<end, with: tmp)
        }
        
        
        if (end - begin) > 1 {
            let mid = (begin + end) / 2
            mergeSort(begin: begin, end: mid)
            mergeSort(begin: mid, end: end)
            merge(begin: begin, mid: mid, end: end)
        }
    }
    
    
    
    
}
