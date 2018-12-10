//
//  HomeReusableHeader.swift
//  Project
//
//  Created by WY on 2017/11/29.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class HomeReusableHeader: DDCollectionReusableView {
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(imageView)
        self.backgroundColor = UIColor.white
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit//UIView.ContentMode.scaleToFill//UIView.ContentMode.scaleAspectFill//
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.sizeToFit()
//        if let url  = URL.init(string: "http://ozstzd6mp.bkt.gdipper.com/Snip20171129_3.png") {
//            imageView.sd_setImage(with: url , placeholderImage: nil , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
//        }
        imageView.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5)
    }
}
