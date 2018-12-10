//
//  DDPageControl.swift
//  Project
//
//  Created by WY on 2018/2/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPageControl: UIView {

    weak var delegate : GDAutoPageControlDelegate?
    
    var selectedImage : UIImage?
    var normalImage : UIImage?
    var itemMargin : CGFloat = 10
    var previousOffset : CGPoint = CGPoint.zero
    var sectionCount : Int = 3 //无限循环时通常设置3组
    weak var scrollView : UIScrollView?{
        didSet{
            
            scrollView?.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    
    var align : GDAutoAlignment = GDAutoAlignment.center
    var selectedBtn = UIButton()
    /// set this proterty and then get bounds of page control , you need set center only
    var numberOfPages : Int  = 0 {
        willSet{
            for view  in self.subviews { view.removeFromSuperview() }
            for index  in 0..<newValue {
                let btn = UIButton()
                btn.adjustsImageWhenHighlighted = false
                self.addSubview(btn)
                if index == 0 {
                    if let tempSelectedImg = self.selectedImage {
                        btn.setImage(tempSelectedImg, for: UIControl.State.selected)
                    }else{
                        btn.setImage(UIImage(named: "whiteDot"), for: UIControl.State.selected)
                    }
                    if let tempNormalImg = self.normalImage {
                        btn.setImage(tempNormalImg, for: UIControl.State.normal)
                    }else{
                        btn.setImage(UIImage(named: "blackDot"), for: UIControl.State.normal)
                    }
                    self.selectedBtn = btn
                    self.currentPage = 0
                }else{
                    if let tempSelectedImg = self.selectedImage {
                        btn.setImage(tempSelectedImg, for: UIControl.State.selected)
                    }else{
                        btn.setImage(UIImage(named: "whiteDot"), for: UIControl.State.selected)
                    }
                    if let tempNormalImg = self.normalImage {
                        btn.setImage(tempNormalImg, for: UIControl.State.normal)
                    }else{
                        btn.setImage(UIImage(named: "blackDot"), for: UIControl.State.normal)
                    }
                }
            }
        }
        didSet{
            _layoutSubviews()
        }
    }
    func _layoutSubviews() {
        let itemW : CGFloat = 10
        let itemH  = itemW
        let margin : CGFloat = itemMargin
        let totalWidth = CGFloat(self.subviews.count) * (itemW + margin) + margin
//        let originFrame = self.frame
        self.bounds = CGRect(x: 0, y: 0, width: totalWidth, height: itemH)

//        if self.align == GDAutoAlignment.center {
//            self.bounds = CGRect(x: 0, y: 0, width: totalWidth, height: itemH)
//            self.center = CGPoint(x: (self.superview?.center.x)!, y: originFrame.origin.y + itemH / 2)
//        }else if (self.align == GDAutoAlignment.left){
//            self.frame = CGRect(x: 0, y: originFrame.origin.y, width: totalWidth, height: itemH)
//        }else if (self.align == GDAutoAlignment.right){
//            self.frame = CGRect(x: (self.superview?.bounds.size.width)! - totalWidth, y: originFrame.origin.y, width: totalWidth, height: itemH)
//        }
        for (index , view ) in self.subviews.enumerated() {
            view.frame = CGRect(x: margin + CGFloat(index) * (margin + itemW), y: 0, width: itemW, height: itemH)
        }
    }
    var currentPage : Int  = 0 {
        willSet{
            if newValue >= self.subviews.count || newValue < 0{return}
            self.selectedBtn.isSelected = false
            self.selectedBtn = self.subviews[newValue] as! UIButton
            self.selectedBtn.isSelected = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil  {
            self.scrollView?.removeObserver(self , forKeyPath: "contentOffset")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    deinit {
    //        self.scrollView.removeObserver(self , forKeyPath: "contentOffset")
    //    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == "contentOffset" {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                //                mylog("监听contentOffset\(newPoint)")//下拉变小
                let offset = newPoint
                var scrollViewWidth : CGFloat =  0
                if let scrollview = self.scrollView {
                    scrollViewWidth = scrollview.bounds.size.width
                }
                let count = scrollView!.contentSize.width / scrollView!.bounds.size.width
                let index  : Int = Int( offset.x / scrollViewWidth )
                if offset.x > self.previousOffset.x { // xiang you
                    if offset.x > scrollView?.contentSize.width   ?? 0 - scrollViewWidth{
                        //                        return
                    }else{
                        
                        let pass = offset.x -  CGFloat(index) * scrollViewWidth
                        if abs(pass) > scrollViewWidth / 2 {
                            if self.currentPage != index + 1 {
                                
                                self.currentPage = (index + 1) % Int(count / CGFloat(sectionCount))//
                                self.delegate?.currentPageChanged(currentPage: self.currentPage)
                            }
                            //                    mylog("nvnvnvnvvnvnvn")
                        }
                    }
                }else{//xiang zuo
                    if offset.x < 0  {
                        //                        return
                    }else{
                        
                        let less = CGFloat(index + 1) * scrollViewWidth - offset.x
                        //                mylog(abs(less))
                        if abs(less) > scrollViewWidth / 2 {
                            if self.currentPage != index {
                                
                                self.currentPage = index % Int(count / CGFloat(sectionCount))
                                self.delegate?.currentPageChanged(currentPage: self.currentPage)
                            }
                        }
                    }
                }
                self.previousOffset = offset
                
                
            }
            //            mylog(self.currentPage)
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
