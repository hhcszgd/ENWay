//
//  GDBaseControl+extension.swift
//  Project
//
//  Created by WY on 2018/6/21.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

extension GDLoadControl {
    func setImages() {
        var  images = [UIImage]()
        for i  in 0...12 {
            if let img = UIImage(named: "gdScrollViewControl\(i)"){
               images.append(img)
            }
        }
        self.pullingImages = images
        self.loadingImages = images
        if let imgFull =  UIImage(named: "gdScrollViewControlFull"){
            self.networkErrorImage  = imgFull
            self.successImage = imgFull
            self.failureImage = imgFull
            self.nomoreImage = imgFull
            
        }
    }
}

extension GDRefreshControl {
    func setImages() {
        var  images = [UIImage]()
        for i  in 0...12 {
            if let img = UIImage(named: "gdScrollViewControl\(i)"){
                images.append(img)
            }
        }
        self.pullingImages = images
        self.refreshingImages = images
        if let imgFull =  UIImage(named: "gdScrollViewControlFull"){
            self.networkErrorImage =  imgFull
            self.successImage =   imgFull
            self.failureImage =   imgFull
        }
    }
}
