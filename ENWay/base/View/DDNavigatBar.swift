//
//  GDNavigatBar.swift
//  zdlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

@objc protocol CustomNaviBarDelegate {
    func popToPreviousVC() -> Void
}
protocol CustomnaviBarStatusDelegate {
    func navigationBarHasChanged(status :  NaviBarStatus) -> Void
}
enum LayoutType {
    case desc/*下降的*/ // 监听属性 , 当这个被赋值时 , navibarstatus初始状态必须是消失状态
    case asc /*ascending上升的*/ // 监听属性 , 当这个被赋值时 , navibarstatus初始状态必须是正常状态状态
}

/// 初始化控制器时,导航栏是否带返回按钮
///
/// - withBackBtn:    有返回键
/// - withoutBackBtn: 没有返回键
enum NaviBarStyle {
    case withBackBtn
    case withoutBackBtn
}

/// 导航栏改变的方式
///
/// - offset:   通过改变位置来实现消失/出现
/// - alpha: 通过改变整体透明度实现消失/出现
/// - color: 通过改变背景色实现消失/出现(非子控件不变)
enum NaviBarActionType {
    case offset
    case alpha
    case color
    case other
}

/// 导航栏状态
///
/// - normal:   正常出现状态
/// - changing: 状态改变中
/// - disapear: 已经消失
enum NaviBarStatus {
    case normal
    case changing
    case disapear
}

/// 导航栏过渡的类型
///
/// - immediately: 导航栏的状态 在contentOffset达到某个值时立刻改变 , 默认
/// - gradually: 导航栏的状态根据contentOffset的改变而渐渐的改变
enum TransitionType  {
    case immediately
    case gradually
}

class DDNavigatBar: UIView {
   
    
    weak var delegate  :  CustomNaviBarDelegate?
    var backBtn : UIButton! {
        didSet{
            backBtn.setImage(UIImage(named:"returnImage"), for: UIControl.State.normal)
        }
    }//= UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
    private var  titleLabel : UILabel! // = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 88.0, height: 44))
    var attributeTitle : NSAttributedString {
        set{
            mylog(newValue)
            titleLabel.isHidden = false
            if titleLabel.superview == nil  {
                self.addSubview(titleLabel)
            }
            titleLabel.attributedText =  newValue
        }
        get{
            if let a = titleLabel.attributedText {
                return a
            }else{
                return NSAttributedString()
            }
        }
    }
    
    
    var title : String {
        set{
            mylog(self)
            mylog(titleLabel)
            mylog(titleLabel.superview)
            mylog(newValue)
            if titleLabel.superview == nil  {
                self.addSubview(titleLabel)
            }
            titleLabel.isHidden = false
            titleLabel.text =  newValue
        }
        get{
            if let a = titleLabel.text {
                return a
            }else{
                return ""
            }
        }
    }
    
    
    var  leftSubViewsContainer : UIView! // = UIView()
    
    
    var leftBarButtons  = [UIView]()
    
    var  rightSubViewsContainer : UIView!// = UIView()
    
    var rightBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in rightSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            var myWidth: CGFloat = 0
            self.rightBarButtons.forEach { (view) in
                myWidth += view.width
            }
            
            let rightSubViewsContainerW = myWidth > UIScreen.main.bounds.size.width * 0.5  ? UIScreen.main.bounds.size.width * 0.5  : myWidth
            rightSubViewsContainer.frame = CGRect(x: UIScreen.main.bounds.size.width - rightSubViewsContainerW, y: DDNavigationBarHeight - 44, width: rightSubViewsContainerW, height: 44)
            var leftWidth: CGFloat = 0
            for (index , newSub) in rightBarButtons.enumerated() {
                
                
                rightSubViewsContainer.addSubview(newSub)
                newSub.frame = CGRect(x: leftWidth, y: 0, width: newSub.width, height: 44)
                leftWidth += newSub.width
            }
        }
        
    }
    
    var navTitleView   =  NavTitleView(){
        willSet {
            navTitleView.removeFromSuperview()
        }
        
        didSet {
            self.addSubview(navTitleView)
            let inset =   navTitleView.insets
            var x : CGFloat = 0.0
            let y : CGFloat = DDNavigationBarHeight - 44 + inset.top
            var w : CGFloat = 0.0
            let h : CGFloat = 44.0 - inset.top - inset.bottom
            
            
            
            if leftBarButtons.count>0 && rightBarButtons.count>0 {//左右都有
                x = leftSubViewsContainer.frame.maxX + inset.left
                //                y = inset.top
                w = rightSubViewsContainer.frame.minX - inset.right - x
                //                h = 44.0 - inset.top - inset.bottom
            }else if leftBarButtons.count>0{//左有 ,右没有
                x = leftSubViewsContainer.frame.maxX + inset.left
                w = UIScreen.main.bounds.size.width - inset.right - x
            }else if rightBarButtons.count>0{//左没有,右有
                x = backBtn.frame.maxX + inset.left
                w = rightSubViewsContainer.frame.minX - inset.right - x
            }else {//左右都没有
                x = backBtn.frame.maxX + inset.left
                w = UIScreen.main.bounds.size.width - inset.right - x
            }
            navTitleView.frame = CGRect(x: x, y: y, width: w, height: h);
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        backBtn = UIButton(frame: CGRect(x: 0, y: DDNavigationBarHeight - 44, width: 44, height: 44))
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleLabel = UILabel(frame: CGRect(x: 0, y: DDNavigationBarHeight - 44 , width: UIScreen.main.bounds.size.width - 88.0, height: 44))
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
        leftSubViewsContainer  = UIView()
        rightSubViewsContainer = UIView()
        titleLabel.center = CGPoint(x: UIScreen.main.bounds.size.width/2.0, y: DDNavigationBarHeight - 44 + 22  );
 
        
        self.addSubview(backBtn)
        self.addSubview(leftSubViewsContainer)
        self.addSubview(rightSubViewsContainer)
//        backBtn.backgroundColor = UIColor.randomColor()
        backBtn.setImage(UIImage(named:"returnImage"), for: UIControl.State.normal)
//        backBtn.setImage(UIImage(named:"back_icon"), for: UIControl.State.normal)
        backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControl.Event.touchUpInside)
    }
    
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    var previousOffset : CGFloat = 0
    var scrollView : UIScrollView = UIScrollView()
    var originContentInset = UIEdgeInsets.zero
   
    
    let originFrame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: DDNavigationBarHeight)
    let targetFrame = CGRect(x: 0, y: -DDNavigationBarHeight, width: SCREENHEIGHT, height: DDNavigationBarHeight)
    let originAlpha : CGFloat = 1.0
    let targetAlpha : CGFloat = 0.0
    var originColorAlpha  : UIColor{ return (self.backgroundColor ?? UIColor.white).withAlphaComponent(1.0)}
    var targetColorAlpha : UIColor {return (self.backgroundColor ?? UIColor.white).withAlphaComponent(0)}
    //    let originColorAlpha  = originBackgroundColor.withAlphaComponent(1.0)
    //    let targetColorAlpha = originBackgroundColor.withAlphaComponent(0)
    
    @objc fileprivate  func backAction(_ sender : UIButton) -> () {
        delegate?.popToPreviousVC()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
class NavTitleView: UIView {
    var insets : UIEdgeInsets = UIEdgeInsets.zero
    
}
