//
//  ImgTxtView.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/9/12.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
/*先看width 和height 哪个小 , 哪个小就以哪个为基准*/

import UIKit

class ImgTxtView: UIControl {

    /*
     lazy var titleLabel = UILabel()//底部标题
     lazy var subTitleLabel = UILabel()//头部数量标题
     lazy var imageView = UIImageView()//图片视图
     lazy var additionalLabel = UILabel()//额外的文字标题(bedge数量)
     */
    let imageView = UIImageView()
    let label = UILabel()
    var imgToLblMargin : CGFloat = 0
//    let container = UIView()
    
//    var model  = ProfileSubModel(dict:nil) {
//        didSet{
//            //当图片为网络图片链接时
//            //当图片不是网络链接时
//            if model.localImgName != nil {
//                if let imgName = model.localImgName {
//                    self.imageView.image = UIImage(named: imgName)
//                }
//            }else{
////                self.imageView.sd_setImage(with: imgStrConvertToUrl("服务器图片地址"))//
//            }
//            //            self.topTitleLabel.text = "\(model.number)"
//            self.subTitleLabel.text = model.name
//            //            self.setNeedsLayout()
//            //            self.layoutIfNeeded()
//        }
//
//    }
    
    convenience init(frame : CGRect = CGRect.zero , margin : CGFloat = 5.0) {//imgToLblMargin
        self.init(frame: frame)
        self.imgToLblMargin = margin
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
       
        self.label.font = GDFont.systemFont(ofSize: 14)//默认14号字体
        self.label.textColor = UIColor.white
        self.label.textAlignment = NSTextAlignment.center
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let  selfW = self.bounds.size.width
        let  selfH = self.bounds.size.height
        let leftH = (selfH - imgToLblMargin ) - label.font.lineHeight
        label.sizeToFit()
        let bottomTitleW =  label.bounds.width  + 10
        let bottomTitleH = self.label.font.lineHeight
//        let bottomTitleX : CGFloat = 0.0 ;
        let bottomTitleY = selfH - bottomTitleH
        
        var imgW : CGFloat = 0.0
        var  imgH : CGFloat = 0.0
        if selfW < leftH {
             imgW = selfW
             imgH = imgW
        }else {
             imgH = leftH
             imgW = imgH
        }
        self.imageView.bounds = CGRect(x: 0, y: 0, width: imgW, height: imgH)
        self.imageView.center = CGPoint(x: selfW/2, y: imgH/2)
        self.label.bounds = CGRect(x: 0, y: 0, width: bottomTitleW, height: bottomTitleH)
        self.label.center = CGPoint(x: selfW/2, y: bottomTitleY + bottomTitleH/2)
        
    }
}
