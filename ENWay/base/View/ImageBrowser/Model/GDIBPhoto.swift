//
//  GDIBPhoto.swift
//  zjlao
//
//  Created by WY on 04/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import Photos
class GDIBPhoto: NSObject {
    var image : UIImage?
    var imageURL : String?
    var imagePath : String?
    var asset : PHAsset?
    init(dict : [String : AnyObject]?) {
        super.init()
        if let dic = dict {
            self.setValuesForKeys(dic)
        }
    }
    override func setValue(_ value: Any?, forKey key: String) {
        //                mylog("\(value)/\(key)")
        
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
