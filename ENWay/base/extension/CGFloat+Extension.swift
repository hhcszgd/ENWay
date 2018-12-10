//
//  CGFloat+Extension.swift
//  Project
//
//  Created by WY on 2017/11/29.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

extension  CGFloat {
    var adaptValue : CGFloat {
        switch DDDevice.type {
        case .iPhone4 , .iPhone5 :
            return self * 0.95
        case .iPhone6 , .iphoneX:
            return self * 1.0001
        case .iPhone6p :
            return self * 1.2001
        default:
            return self * 1.5
        }
    }
    
}
