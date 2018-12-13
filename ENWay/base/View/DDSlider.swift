//
//  DDSlider.swift
//  ENWay
//
//  Created by WY on 2018/12/13.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit


class DDSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setThumbImage(UIImage(named:"playdragging"), for: UIControl.State.normal)
        self.setThumbImage(UIImage(named:"playdragging"), for: UIControl.State.highlighted)
        self.minimumTrackTintColor = UIColor.orange
        self.maximumTrackTintColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect{
        let rect = super.trackRect(forBounds: bounds)
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: 6)
    }
    
}

