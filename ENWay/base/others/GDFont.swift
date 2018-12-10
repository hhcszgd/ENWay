//
//  GDFont.swift
//  zjlao
//
//  Created by WY on 16/11/5.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDFont: UIFont {
    override class func boldSystemFont(ofSize: CGFloat) -> UIFont {
        var size = ofSize
        switch (UIScreen.main.bounds.height , UIScreen.main.bounds.width) {
        case (480 , 320) ,  (320 , 480 ):
            size *= 0.7//.iPhone4
        case (568 , 320) , (320 ,568):
            size *= 0.82//.iPhone5
        case (667,375) , (375 , 667):
            size += 0//.iPhone6
        case (736 , 414) , (414 , 736 ):
            size *= 1.1//.iPhone6p
        case (812 , 375) , (375 , 812):
            size *= 1.15//.iphoneX
        case (896 , 414) , (414 , 896):
            size *= 1.3//.iphoneXsMax
        case (1024 , 768) , (768 , 1024):
            size *= 1.5//.iPad
        case (1112 , 834) , (834 , 1112):
            size *= 1.5//.iPadProSmall
        case (1366 , 1024) , (1024 , 1366):
            size *= 2//.iPadProBig
        default:
            size += 0
        }
        return super.boldSystemFont(ofSize: size)
    }
    override class func systemFont(ofSize : CGFloat ) -> UIFont{
        var size = ofSize
        switch (UIScreen.main.bounds.height , UIScreen.main.bounds.width) {
        case (480 , 320) ,  (320 , 480 ):
            size *= 0.7//.iPhone4
        case (568 , 320) , (320 ,568):
            size *= 0.82//.iPhone5
        case (667,375) , (375 , 667):
            size += 0//.iPhone6
        case (736 , 414) , (414 , 736 ):
            size *= 1.1//.iPhone6p
        case (812 , 375) , (375 , 812):
            size *= 1.15//.iphoneX
        case (896 , 414) , (414 , 896):
            size *= 1.3//.iphoneXsMax
        case (1024 , 768) , (768 , 1024):
            size *= 1.5//.iPad
        case (1112 , 834) , (834 , 1112):
            size *= 1.5//.iPadProSmall
        case (1366 , 1024) , (1024 , 1366):
            size *= 2//.iPadProBig
        default:
            size += 0
        }
       return super.systemFont(ofSize: size)
    }
}

/**设备尺寸
 6和7  2X:           (375.0, 667.0)
 6p和7p  3X:         (414.0, 736.0)
 se和5和5s和5c  2X:   (320.0, 568.0)
 ipadPro(12.9)2X:  (1024.0, 1366.0)
 ipadPro(9.7)和ipadAir系列2X:   (768.0, 1024.0)
 ipadRetina(7.9寸设备)1X: (768.0, 1024.0)
 */
