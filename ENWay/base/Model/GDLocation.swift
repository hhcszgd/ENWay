//
//  GDLocation.swift
//  zjlao
//
//  Created by WY on 17/3/21.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import MapKit
enum GDLocationType {
    case origen
    case image1
    case image2
    case image3
    case image4
    case image5
}
class GDLocation: NSObject ,  MKAnnotation  {//大头针数据模型,包含位置,标题,副标题等
    override init() {
        super.init()
    }
    var serialNumber : String = ""
    
     var coordinate: CLLocationCoordinate2D  =  CLLocationCoordinate2D.init(){
        didSet{
//            coordinate = newValue
        }
        willSet{
//            return self.coordinate
        }
    }
    // Title and subtitle for use by selection UI.
      var title: String?
    
      var subtitle: String?
    var type  :GDLocationType = GDLocationType.origen//大头针类型
    
}
