//
//  GDCoverView.swift
//  zjlao
//
//  Created by WY on 2017/9/18.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDCoverView: UIControl {
    weak var currentSuperView : UIView!
//    private lazy var contentView : UIView = {
//        let view = UIView()
//        view.bounds = CGRect(x: 10, y: 0, width: self.bounds.width - 20, height: self.bounds.height * 0.3)
//        view.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
//        view.backgroundColor = UIColor.white
//        self.addSubview(view)
//        return view
//    }()
    init(superView : UIView) {
        super.init(frame: superView.bounds)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.alpha = 0
        self.currentSuperView = superView
        superView.addSubview(self)
//        self.addTarget(self , action: #selector(remove), for: UIControl.Event.touchUpInside)
    }
    @discardableResult
    func layoutViewToBeShow(action:()->()) -> GDCoverView {
        action()
        return self
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
    }
    override func didMoveToWindow(){
        super.didMoveToWindow()
        mylog(self.allTargets)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { (bool ) in
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func remove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (bool ) in
            self.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            self.removeFromSuperview()
        }
    }
    ///:调整子视图的位置 , (调用者自己实现)
    func moveContent(action:()->())  {
        action()
    }
//    func moveContent(offset : CGFloat , timeInterval : TimeInterval = 0.25) {
//        let y = self.contentView.center.y + offset
//        let x = self.contentView.center.x
//        UIView.animate(withDuration: timeInterval, animations: {
//            self.contentView.center = CGPoint(x: x , y: y )
//        }) { (bool ) in
//        }
//    }
    deinit {
        mylog("遮盖销毁")
    }
}






//class DDCoverView: UIView {
//    weak var currentSuperView : UIView!
//    var deinitHandle : (()-> ())?
//    init(superView : UIView) {
//        super.init(frame: superView.bounds)
//        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
//        self.alpha = 0
//        self.currentSuperView = superView
//        superView.addSubview(self)
//    }
//    @discardableResult
//    func layoutViewToBeShow(action:()->()) -> DDCoverView {
//        action()
//        return self
//    }
//    override func willMove(toWindow newWindow: UIWindow?) {
//        super.willMove(toWindow: newWindow)
//    }
//    override func didMoveToWindow(){
//        super.didMoveToWindow()
//        UIView.animate(withDuration: 0.3, animations: {
//            self.alpha = 1
//        }) { (bool ) in
//
//        }
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    @objc func remove() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.alpha = 0
//        }) { (bool ) in
//            self.subviews.forEach({ (subview) in
//                subview.removeFromSuperview()
//            })
//            self.removeFromSuperview()
//        }
//    }
//    deinit {mylog("遮盖销毁")}
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        mylog("corver view part touch")
//        if let firstView = self.subviews.first{
//            if let point = touches.first?.location(in: self){
//                if firstView.frame.contains(point){
//                    return
//                }
//            }
//        }
//        self.deinitHandle?()
//        self.remove()
//    }
//}


class DDCoverView: UIView {
    var isHideWhenWhitespaceClick = true
    weak var currentSuperView : UIView?
    var deinitHandle : (()-> ())?
    var actionHandle : ((Any)-> ())?
    init(superView : UIView) {
        super.init(frame: superView.bounds)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.alpha = 0
        self.currentSuperView = superView
        superView.addSubview(self)
        self.frame = currentSuperView?.bounds ?? CGRect.zero
    }
    @discardableResult
    func layoutViewToBeShow(action:()->()) -> DDCoverView {
        action()
        return self
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
    }
    override func didMoveToWindow(){
        super.didMoveToWindow()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { (bool ) in
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func remove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (bool ) in
            self.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            self.removeFromSuperview()
            self.deinitHandle?()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mylog("corver view part touch")
        if let firstView = self.subviews.first{
            if let point = touches.first?.location(in: self){
                if firstView.frame.contains(point){
                    return
                }
            }
        }
        if isHideWhenWhitespaceClick {self.remove()}
        
    }
    
    deinit {
        self.deinitHandle?()
        mylog("遮盖销毁")
    }
}

