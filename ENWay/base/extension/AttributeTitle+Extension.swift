//
//  AttributeTitle+Extension.swift
//  Project
//
//  Created by WY on 2017/12/16.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

extension Array where Element : StringProtocol  {
    func setColor(colors:[UIColor])->NSAttributedString{
        let tempAttributeStr  = NSMutableAttributedString.init()
        if self.count != colors.count {
            fatalError("strings's count is not equal to colors's count")
        }
        for ( index , str )  in self.enumerated() {
            if let string =  str as? String{
                let  temp = NSMutableAttributedString.init(string: string)
                temp.setAttributes([NSAttributedString.Key.foregroundColor : colors[index]], range: NSRange.init(location: 0, length: string.count))
                tempAttributeStr.append(temp)
            }
        }
        return tempAttributeStr
    }
}
extension UIImage {
    func imageConvertToAttributedString(bounds:CGRect? = nil )->NSAttributedString{
        let achment : NSTextAttachment = NSTextAttachment.init()
        achment.image = self
        if bounds != nil {achment.bounds = bounds!}
        return NSAttributedString.init(attachment: achment)
    }
}
