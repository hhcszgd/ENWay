//
//  GDRowView.swift
//  zjlao
//
//  Created by WY on 17/12/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class DDRowView: UIControl {
    private var customView : UIView = UIView()
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
     lazy var titleLabel = UILabel()//主标题
     lazy var subTitleLabel = UILabel()//副标题
     lazy var additionalLabel = UILabel()
     lazy var imageView = UIImageView()//左侧icon
    lazy var subImageView = UIImageView()//右侧图片
     lazy var additionalImageView = UIImageView()//右侧箭头

    
    
    var diyView = UIView(){
        didSet{
            for view in self.customView.subviews {
                view.removeFromSuperview()
            }
            self.customView.addSubview(diyView)
            self.customView.frame = diyView.frame
            diyView.frame = self.customView.bounds
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(customView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.subImageView)
        self.addSubview(self.additionalImageView)
        //        self.titleLabel.backgroundColor = UIColor.red
        //        self.subTitleLabel.backgroundColor = UIColor.yellow
        //        self.imageView.backgroundColor = UIColor.blue
        //        self.subImageView.backgroundColor = UIColor.purple
        //        self.additionalImageView.backgroundColor = UIColor.orange
        self.additionalImageView.image = UIImage(named: "enterthearrow")
        
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.subImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.additionalImageView.contentMode =  UIView.ContentMode.scaleAspectFit
        
        self.titleLabel.textColor = UIColor.darkGray
        self.subTitleLabel.textColor = UIColor.lightGray
        self.subTitleLabel.font = GDFont.systemFont(ofSize: 13)//GDFont.systemFont(ofSize: 13*SCALE)
        self.additionalImageView.isHidden = true
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10.0
        let selfH = self.bounds.size.height
        let selfW = self.bounds.size.width
        //有图和没图情况下 左侧的布局
        self.titleLabel.sizeToFit()
        self.subTitleLabel.sizeToFit()
        if self.imageView.image == nil {//忽略左侧图标 , 直接布局标题
            self.imageView.isHidden = true
            let titleLabelY : CGFloat = 0.0
            let titleLabelX =  margin
            let titleLabelH = selfH
            let titleLabelW = min(self.bounds.width - titleLabelX - margin * 2, self.titleLabel.bounds.width)
            
            self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
            
        }else{
            self.imageView.isHidden = false//先布局图标 , 再布局标题
            let imageViewH : CGFloat = selfH - margin * 2
            let imageViewW = imageViewH
            let imageViewX = margin + 5
            let imageViewY = margin
            self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
            let titleLabelY : CGFloat = 0.0
            let titleLabelX = self.imageView.frame.maxX + margin
            let titleLabelH = selfH
            let titleLabelW = min(self.bounds.width - titleLabelX - margin * 2, self.titleLabel.bounds.width)
            self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
            
        }
        
        
        //箭头隐藏和不隐藏情况下 右侧的布局
        if self.additionalImageView.isHidden   {
            
            if self.subImageView.image == nil {//忽略箭头 , 忽略subimageView并隐藏
                self.subImageView.isHidden = true//布局文字
                
            
                let subLabelX : CGFloat = self.titleLabel.frame.maxX + margin
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat =  self.bounds.width - titleLabel.frame.maxX - margin * 2//subTitleLabel.bounds.width
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
            
            }else{//显示subimageView ,并先布局它  , 再布局subtitleLabel//既有文字又有图片的情况先不考虑
                self.subImageView.isHidden = false
                //暂时先只布局图片
                let subImageViewH : CGFloat = selfH - margin * 2
                let subImageViewW = subImageViewH
                let subImageViewY = margin
                let subImageViewX = selfW - margin - subImageViewW
                self.subImageView.frame = CGRect(x: subImageViewX, y: subImageViewY, width: subImageViewW, height: subImageViewH)
                //等待布局文字
                if self.titleLabel.frame.maxX >= subImageView.frame.minX{
                    self.titleLabel.frame.size.width = subImageView.frame.minX - self.titleLabel.frame.minX - margin
                    self.subTitleLabel.frame = CGRect.zero
                }else{
                    let subLabelX : CGFloat = self.titleLabel.frame.maxX + margin
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat = self.subImageView.frame.minX - subLabelX - margin
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                }
                /*
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat = self.subImageView.frame.minX - margin - selfW*0.5
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
                */
            }
        }else{//先显示并布局箭头
            //布局箭头
            let addiW : CGFloat = 10.0
            let addiH : CGFloat = 14.0
            let addiX : CGFloat = selfW - margin - addiW
            let addiY : CGFloat = (selfH - addiH) * 0.5
            self.additionalImageView.frame = CGRect(x: addiX, y: addiY, width: addiW, height: addiH)
            
            
            
            if self.subImageView.image == nil {//忽略subimageView并隐藏 ,布局subtitleLabel
                self.subImageView.isHidden = true
                if self.titleLabel.frame.maxX >= additionalImageView.frame.minX{//主标题超长
                    self.titleLabel.frame.size.width = additionalImageView.frame.minX - self.titleLabel.frame.minX - margin
                    self.subTitleLabel.frame = CGRect.zero
                }else{
                    let subLabelX : CGFloat = self.titleLabel.frame.maxX + margin
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat = self.additionalImageView.frame.minX - subLabelX - margin
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                    
                }
                /*
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat = self.additionalImageView.frame.minX - margin - selfW*0.5
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
                */
            }else{//先布局subimageView , 再布局subtitleLabel
                self.subImageView.isHidden = false//暂时先只布局图片
                let subImageViewH : CGFloat = selfH - margin * 2
                let subImageViewW = subImageViewH
                let subImageViewY = margin
                let subImageViewX = self.additionalImageView.frame.minX - margin - subImageViewW
                self.subImageView.frame = CGRect(x: subImageViewX, y: subImageViewY, width: subImageViewW, height: subImageViewH)
                //等待布局文字
                if self.titleLabel.frame.maxX >= subImageView.frame.minX{//主标题超长
                    self.titleLabel.frame.size.width = subImageView.frame.minX - self.titleLabel.frame.minX - margin
                    self.subTitleLabel.frame = CGRect.zero
                }else{
                    let subLabelX : CGFloat = self.titleLabel.frame.maxX + margin
                    let subLabelY : CGFloat = 0.0
                    let subLabelW : CGFloat = self.subImageView.frame.minX - subLabelX - margin
                    let subLabelH : CGFloat = selfH
                    self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                    self.subTitleLabel.textAlignment = NSTextAlignment.right
                }
                /*
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat = self.subImageView.frame.minX - margin - selfW*0.5
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
                */
            }
        }
        
    }
    

}


class ZKRowView: UIControl {
    private var customView : UIView = UIView()
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    lazy var titleLabel = UILabel()//主标题
    lazy var subTitleLabel = UILabel()//副标题
    lazy var additionalLabel = UILabel()
    lazy var imageView = UIImageView()//左侧icon
    lazy var subImageView = UIImageView()//右侧图片
    lazy var additionalImageView = UIImageView()//右侧箭头
    
    
    
    var diyView = UIView(){
        didSet{
            for view in self.customView.subviews {
                view.removeFromSuperview()
            }
            self.customView.addSubview(diyView)
            self.customView.frame = diyView.frame
            diyView.frame = self.customView.bounds
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(customView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.subImageView)
        self.addSubview(self.additionalImageView)
        //        self.titleLabel.backgroundColor = UIColor.red
        //        self.subTitleLabel.backgroundColor = UIColor.yellow
        //        self.imageView.backgroundColor = UIColor.blue
        //        self.subImageView.backgroundColor = UIColor.purple
        //        self.additionalImageView.backgroundColor = UIColor.orange
        self.additionalImageView.image = UIImage(named: "enterthearrow")
        
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.subImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.additionalImageView.contentMode =  UIView.ContentMode.scaleAspectFit
        
        self.titleLabel.textColor = UIColor.darkGray
        self.subTitleLabel.textColor = UIColor.lightGray
        self.subTitleLabel.font = GDFont.systemFont(ofSize: 13)//GDFont.systemFont(ofSize: 13*SCALE)
        self.additionalImageView.isHidden = true
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10.0
        let selfH = self.bounds.size.height
        let selfW = self.bounds.size.width
        //有图和没图情况下 左侧的布局
        if self.imageView.image == nil {//忽略左侧图标 , 直接布局标题
            self.imageView.isHidden = true
            let titleLabelY : CGFloat = 0.0
            let titleLabelX =  margin
            let titleLabelH = selfH
            let titleLabelW = selfW * 0.5 - titleLabelX
            self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
            
        }else{
            
            self.imageView.isHidden = false//先布局图标 , 再布局标题
            let imageViewH : CGFloat = selfH / 2.0
            let imageViewW = imageViewH
            let imageViewX = margin + 5
            let imageViewY = (selfH - imageViewH) / 2.0
            self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
            let titleLabelY : CGFloat = 0.0
            let titleLabelX = self.imageView.frame.maxX + margin
            let titleLabelH = selfH
            let titleLabelW = selfW * 0.5 - titleLabelX
            self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
            
        }
        
        
        //箭头隐藏和不隐藏情况下 右侧的布局
        if self.additionalImageView.isHidden   {
            
            if self.subImageView.image == nil {//忽略箭头 , 忽略subimageView并隐藏
                self.subImageView.isHidden = true//布局文字
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat =  selfW*0.5 - margin
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
                
            }else{//显示subimageView ,并先布局它  , 再布局subtitleLabel//既有文字又有图片的情况先不考虑
                self.subImageView.isHidden = false
                //暂时先只布局图片
                let subImageViewH : CGFloat = selfH - margin * 2
                let subImageViewW = subImageViewH
                let subImageViewY = margin
                let subImageViewX = selfW - margin - subImageViewW
                self.subImageView.frame = CGRect(x: subImageViewX, y: subImageViewY, width: subImageViewW, height: subImageViewH)
                //等待布局文字
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat = self.subImageView.frame.minX - margin - selfW*0.5
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
            }
        }else{//先显示并布局箭头
            //布局箭头
            let addiW : CGFloat = 10.0
            let addiH : CGFloat = 14.0
            let addiX : CGFloat = selfW - margin - addiW
            let addiY : CGFloat = (selfH - addiH) * 0.5
            self.additionalImageView.frame = CGRect(x: addiX, y: addiY, width: addiW, height: addiH)
            
            
            
            if self.subImageView.image == nil {//忽略subimageView并隐藏 ,布局subtitleLabel
                self.subImageView.isHidden = true
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat = self.additionalImageView.frame.minX - margin - selfW*0.5
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
                
            }else{//先布局subimageView , 再布局subtitleLabel
                self.subImageView.isHidden = false//暂时先只布局图片
                let subImageViewH : CGFloat = selfH - margin * 2
                let subImageViewW = subImageViewH
                let subImageViewY = margin
                let subImageViewX = self.additionalImageView.frame.minX - margin - subImageViewW
                self.subImageView.frame = CGRect(x: subImageViewX, y: subImageViewY, width: subImageViewW, height: subImageViewH)
                //等待布局文字
                let subLabelX : CGFloat = selfW * 0.5
                let subLabelY : CGFloat = 0.0
                let subLabelW : CGFloat = self.subImageView.frame.minX - margin - selfW*0.5
                let subLabelH : CGFloat = selfH
                self.subTitleLabel.frame = CGRect(x: subLabelX, y: subLabelY, width: subLabelW, height: subLabelH)
                self.subTitleLabel.textAlignment = NSTextAlignment.right
                
            }
        }
        
    }
    
    
}
