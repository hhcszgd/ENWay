//
//  DDNoNavibarVC.swift
//  Project
//
//  Created by WY on 2017/11/20.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
/// 自定义导航栏 导航栏的子控件需要自己添加和  布局

import UIKit

class DDNoNavibarVC: DDProvideForceTouchVC  ,UIGestureRecognizerDelegate {
    
    /// 滚动临界值,也是naviBar的高度 , 默认64.0
//    var scrollCritical : CGFloat = DDDevice.type == .iphoneX ? 88 : 64
    var scrollCritical : CGFloat = DDDevice.isFullScreen ? 88 : 64
    //    let naviBar : UIView = UIView.init()
    lazy var naviBar : UIView  = {
        
//        let h : CGFloat = DDDevice.type == .iphoneX ? 88 : 64
        let h : CGFloat = DDDevice.isFullScreen ? 88 : 64
        let temp = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: h    ))
        return temp
    }()
    private var scrollViews : [UIScrollView] = [UIScrollView]()
    var collectionView : UICollectionView?{
        didSet{
            if collectionView == nil{
                self.removeAllScrollViewObservers()
            }else{
                self.addObservers(scrollView: collectionView!)
            }
        }
    }
    var tableView : UITableView?{
        didSet{
            if tableView == nil{
                self.removeAllScrollViewObservers()
            }else{
                self.addObservers(scrollView: tableView!)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self._configNavBar()
        // Do any additional setup after loading the view.
    }
    private func _configNavBar()  {
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if #available(iOS 11.0, *) {
            self.collectionView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationController?.setNavigationBarHidden(true   , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏1
//        naviBar.backgroundColor = UIColor.DDThemeColor
        if naviBar.superview == nil  { self.view.addSubview(naviBar)}
//        naviBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: scrollCritical)
        let naviBarH = naviBar.bounds.height
//        naviBar.snp.makeConstraints { (make ) in
//            make.left.top.right.equalTo(self.view)
//            make.height.equalTo(naviBarH)
//        }
//        if let delegate = self as? UIGestureRecognizerDelegate{
            navigationController?.interactivePopGestureRecognizer?.delegate = self
//        }
//            self.navigationController?.interactivePopGestureRecognizer?.delegate =  self as! UIGestureRecognizerDelegate
        self.jianbian(view: self.naviBar)
    }
    func jianbian(view:UIView?)  {
        let colorlayer: CAGradientLayer = CAGradientLayer()
        colorlayer.startPoint = CGPoint(x: 0, y: 0.5)
        colorlayer.endPoint = CGPoint(x: 1, y: 0.5)
        let startColor = UIColor.colorWithHexStringSwift("#6a99fb").cgColor //UIColor.red.cgColor
        //        let midColor  = UIColor.green.cgColor
        let endColor =  UIColor.colorWithHexStringSwift("#4278e6").cgColor //UIColor.blue.cgColor
        colorlayer.colors = [startColor,endColor]
        colorlayer.frame = view?.bounds ?? CGRect.zero
        view?.layer.addSublayer(colorlayer)
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.navigationController!.viewControllers.count == 1){
            return false
        }else{
            return true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏2
        rootNaviVC?.setNavigationBarHidden(true , animated: true )

        self.view.bringSubviewToFront(self.naviBar)
//        mylog(self.navigationController)
    }
    func popToPreviousVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///子类实现
    func contentOffsetInContentInset(scrollView : UIScrollView , scale  : CGFloat)  {//0~1
        //        mylog("contentInset范围内滚动\(scale)")
        //        self.navigationView.changeBackgrouncAlpha(alpha:1 - scale)//改变导航栏透明度
        //        self.navigationView.changeFrame(paramet: scale)//改变导航栏位置
    }
    func contentOffsetBigThanInsetTop(scrollView : UIScrollView ,scale  : CGFloat)  {//0~1
        //        mylog("大于0\(scale)")
    }
    func contentOffsetLessThanInsetTop(scrollView : UIScrollView ,scale  : CGFloat)  {//0~1
        //        mylog("小于0\(scale)")
    }
    func contentOffsetChanged(scrollView : UIScrollView ,contentOffset : CGPoint) {
        //        mylog("监听contentOffsetChanged\(contentOffset)")
    }
    deinit {
        self.removeAllScrollViewObservers()
    }
}

extension DDNoNavibarVC {
    func addObservers(scrollView:UIScrollView) {
        if !scrollViews.contains(scrollView) {
            scrollViews.append(scrollView)
            scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self , forKeyPath: "contentInset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    final func removeAllScrollViewObservers(){
        scrollViews.forEach {self.removeObservers(scrollView: $0)}
        scrollViews.removeAll()
    }
    func removeObservers(scrollView:UIScrollView?) {
        if scrollView == nil  {return}
        scrollView!.removeObserver(self , forKeyPath: "contentOffset")
        scrollView!.removeObserver(self , forKeyPath: "contentInset")
        scrollView!.removeObserver(self , forKeyPath: "contentSize")
    }
    
    
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let scrollView = object as? UIScrollView
        
        if keyPath != nil && keyPath! == "contentOffset" && scrollView != nil {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                self.contentOffsetChanged(scrollView : scrollView! ,contentOffset: newPoint)
                let contentInset  = scrollView!.contentInset
                if contentInset.top < 0 {//应该没人这么干
                }else{
//                    self.naviBar.change(by: scrollView!)
                    if newPoint.y < -contentInset.top {//滚完inset后,继续往下拖动 , y值<-top
                        let cha = -newPoint.y - contentInset.top
                        if cha <= self.scrollCritical {
                            self.contentOffsetLessThanInsetTop(scrollView : scrollView! , scale: cha / self.scrollCritical)
                        }
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: 0)//使inset外继续可以调用这个方法
                    }
                    if newPoint.y >= -contentInset.top && newPoint.y <= 0   {//在inset范围内滚动
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: ((scrollView?.contentInset.top)! + newPoint.y) / (scrollView?.contentInset.top)!)
                    }
                    if newPoint.y >= 0   {//滚到scrollView控件的边缘后 , 继续往上拖动
                        let cha = newPoint.y
                        if cha <= self.scrollCritical {
                            self.contentOffsetBigThanInsetTop(scrollView : scrollView! ,scale: cha / self.scrollCritical)
                        }
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: 1)//使inset外继续可以调用这个方法
                    }
                }
                
                
            }
        }else if keyPath != nil && keyPath! == "contentInset"{
            if  let newContentInset = change?[NSKeyValueChangeKey.newKey] as? CGRectEdge{
                //                mylog("监听contentInset : \(String(describing: newContentInset))")
                
            }
            
        }else if keyPath != nil && keyPath! == "contentSize"{
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                //                mylog("监听contentSize : \(String(describing: newSize))")
                
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}

