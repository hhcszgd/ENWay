//
//  DDDevice.swift
//  Project
//
//  Created by WY on 2017/11/2.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
enum DeviceType:String {
    case iPhone4
    ///包含iPhoneSe
    case iPhone5
    ///包含iPhone7,8
    case iPhone6
    ///包含iPhone7p,8p
    case iPhone6p
    ///包含iphoneXS
    case iphoneX
    ///包含 iphoneXr
    case iphoneXsMax
    ///包含 iPad Mini4
    case iPad
    /// iPadPro9.7
    case iPadProSmall
    ///iPadPro12.9
    case iPadProBig
    case unkonw
}

class DDDevice: UIDevice {
    class var scale : CGFloat{
        //竖屏模式下
        switch (UIScreen.main.bounds.height , UIScreen.main.bounds.width) {
        case (480 , 320) ,  (320 , 480 ):
            return 0.6//.iPhone4
        case (568 , 320) , (320 ,568):
            return 0.72//.iPhone5
        case (667,375) , (375 , 667):
            return 1//.iPhone6
        case (736 , 414) , (414 , 736 ):
            return 1.103//.iPhone6p
        case (812 , 375) , (375 , 812):
            return 1.15//.iphoneX
        case (896 , 414) , (414 , 896):
            return 1.3//.iphoneXsMax
        case (1024 , 768) , (768 , 1024):
            return 1.5//.iPad
        case (1112 , 834) , (834 , 1112):
            return 1.5//.iPadProSmall
        case (1366 , 1024) , (1024 , 1366):
            return 2.0//.iPadProBig
        default:
            return 1
        }
    }
   class var type : DeviceType{
        //竖屏模式下
        switch (UIScreen.main.bounds.height , UIScreen.main.bounds.width) {
        case (480 , 320) ,  (320 , 480 ):
            return .iPhone4
        case (568 , 320) , (320 ,568):
            return .iPhone5
        case (667,375) , (375 , 667):
            return .iPhone6
        case (736 , 414) , (414 , 736 ):
            return .iPhone6p
        case (812 , 375) , (375 , 812):
            return .iphoneX
        case (896 , 414) , (414 , 896):
            return .iphoneXsMax
        case (1024 , 768) , (768 , 1024):
            return .iPad
        case (1112 , 834) , (834 , 1112):
            return .iPadProSmall
        case (1366 , 1024) , (1024 , 1366):
            return .iPadProBig
        default:
            return .unkonw
        }
    }
    
    class var isFullScreen : Bool {//是不是全面屏(刘海屏)
        //竖屏模式下
        switch (UIScreen.main.bounds.height , UIScreen.main.bounds.width) {
        case (480 , 320) ,  (320 , 480 ):
            return false
        case (568 , 320) , (320 ,568):
            return false
        case (667,375) , (375 , 667):
            return false
        case (736 , 414) , (414 , 736 ):
            return false
        case (812 , 375) , (375 , 812):
            return true
        case (896 , 414) , (414 , 896):
            return true
        case (1024 , 768) , (768 , 1024):
            return false
        case (1112 , 834) , (834 , 1112):
            return false
        case (1366 , 1024) , (1024 , 1366):
            return false
        default:
            return false
        }
    }
    
    
}
var _scale: CGFloat {
    get{
        let width: CGFloat = UIScreen.main.bounds.size.width
        if width > 375.0 {
            return CGFloat(1.10)
        }else if width < 321 {
            return CGFloat(0.85)
        }else {
            return 1
        }
    }
}
