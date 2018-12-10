//
//  GDMsgIconView.swift
//  zjlao
//
//  Created by WY on 17/1/7.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDMsgIconView: UIControl {
    lazy var titleLabel = UILabel()
    private lazy var subTitleLabel = UILabel()
    var messageCount : Int  = 0 {
        didSet{
            DDStorgeManager.standard.set(messageCount, forKey: GDMessageCount)
            self.layoutIfNeeded()
        }
    }
    
    lazy var imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)//前
        self.addSubview(self.subTitleLabel)//后
        self.titleLabel.numberOfLines = 0
        self.subTitleLabel.numberOfLines = 0
        NotificationCenter.default.addObserver(self , selector: #selector(messageCountChanged), name: GDMessageCountChanged, object: nil )
        self.subTitleLabel.backgroundColor = UIColor.red
        self.subTitleLabel.font = GDFont.systemFont(ofSize: 9)
        self.subTitleLabel.textColor = UIColor.white 
        self.titleLabel.font = GDFont.systemFont(ofSize: 11)
        self.titleLabel.textColor = UIColor.lightGray
        self.imageView.image = UIImage(named: "news")
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.subTitleLabel.textAlignment = NSTextAlignment.center
//        self.titleLabel.text = "扫一扫"
        //MARK:   forTest , WillBeDelete
        DDStorgeManager.standard.set(2, forKey: GDMessageCount)

    }
    
    //留上设置图片和文字的接口
    override func layoutSubviews() {
        super.layoutSubviews()
        let width : CGFloat = self.bounds.size.width
        let height : CGFloat  = self.bounds.size.height
        var imgWidth : CGFloat  = 0
        var imgHeight : CGFloat  = 0
        var imgX : CGFloat = 0
        var imgY : CGFloat  = 0
        
        var margin : CGFloat = 0
        if let titStr = self.titleLabel.text {
            
                if titStr.isEmpty {//titleLabel的text字符串长度为0
                    if width >= height {
                        margin = height / 5
                        imgHeight = height - margin * 2
                        imgWidth = imgHeight
                    }else{
                        margin = width / 5
                        imgWidth = width - margin * 2
                        imgHeight = imgWidth
                    }
                    imgX = (width - imgWidth) / 2
                    imgY = (height - imgHeight) / 2
                    imageView.frame = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHeight)
                    //frameTheRedPoint
                    self.frameRedPoint(imgView: imageView)
                    
                    //                let subTitleW = //动态计算 , = 高 , 或者 > 高 , 隐藏或不隐藏 , 显示数量还是红点
                }else{
                    //                let titleLabelW = width - margin * 2
                    //                let titleLabelH = self.titleLabel.font.lineHeight
                    mylog("shibai ")
//                    首先计算标题的宽高
                    let  titleLabelW : CGFloat = width
                    let titleLabelH : CGFloat  = self.titleLabel.font.lineHeight
                    let titleLabelCenterX : CGFloat  = width / 2
                    let titleLabelCenterY : CGFloat  = height - titleLabelH * 0.55
                    titleLabel.bounds = CGRect(x: 0, y: 0, width: titleLabelW, height: titleLabelH)
                    titleLabel.center = CGPoint(x: titleLabelCenterX, y: titleLabelCenterY)
                    
                    let remainingH =  titleLabel.frame.minY  //剩余高度
                    if width >= remainingH {
                        margin = remainingH / 8
                        
                        imgHeight = remainingH - margin * 2
                        imgWidth = imgHeight
                    }else{
                        margin = width / 8
                        imgWidth = width - margin * 2
                        imgHeight = imgWidth
                    }
                    imgX = (width - imgWidth) / 2
                    imgY = (remainingH - imgHeight) / 2
                    imageView.frame = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHeight)
                    //frameTheRedPoint
                    
                    self.frameRedPoint(imgView: imageView)


                    
                }
            
        }else{
//            mylog("titleLabel的text属性为空")
            if width >= height {
                margin = height / 5
                imgHeight = height - margin * 2
                imgWidth = imgHeight
            }else{
                margin = width / 5
                imgWidth = width - margin * 2
                imgHeight = imgWidth
            }
            imgX = (width - imgWidth) / 2
            imgY = (height - imgHeight) / 2
            imageView.frame = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHeight)
            //frameTheRedPoint
            self.frameRedPoint(imgView: imageView)
        }
       

    }

    
    private func frameRedPoint (imgView : UIImageView)  {
        let messageCount  = DDStorgeManager.standard.integer(forKey: GDMessageCount)
        if messageCount > 0 {
            subTitleLabel.text = messageCount > 9 ? "9+" : "\(messageCount)"
            self.subTitleLabel.isHidden = false
            let subTitleH = self.subTitleLabel.font.lineHeight
            var  subTitleW : CGFloat = 0
            let titleTextW = self.subTitleLabel.text?.sizeSingleLine(font: self.subTitleLabel.font).width ??  subTitleH
            subTitleW = titleTextW > subTitleH ? titleTextW : subTitleH
            self.subTitleLabel.frame = CGRect(x: 0, y: 0, width: subTitleW + 5, height: subTitleH + 5 )
            self.subTitleLabel.center = CGPoint(x: self.imageView.frame.maxX, y: self.imageView.frame.minY)
            self.subTitleLabel.layer.cornerRadius = self.subTitleLabel.bounds.size.width * 0.5
            self.subTitleLabel.layer.masksToBounds = true
            
        }else{
            self.subTitleLabel.isHidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func messageCountChanged()  {
        //重置消息图标
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
