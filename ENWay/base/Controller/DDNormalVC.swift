//
//  DDNormalVC.swift
//  ZDLao
//
//  Created by WY on 2017/10/19.
//  Copyright © 2017年 com.16lao. All rights reserved.
//
///:导航栏用系统的 , 并且一定有导航栏 , 如果没有导航栏请使用DDInternalVC类
import UIKit

class DDNormalVC: DDProvideForceTouchVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        ///:设置导航栏返回键
        self.navigationController?.navigationBar.topItem?.backBarButtonItem =   UIBarButtonItem.init(title: nil , style: UIBarButtonItem.Style.plain, target: nil , action: nil )//去掉title
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:/*header_leftbtn_nor*/"returnImage")//返回按键
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"returnImage")
        ///:设置导航栏返回键内容颜色
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        ///:设置导航栏背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.DDThemeColor
//        self.jianbian(view: self.navigationController?.navigationBar)
        // Do any additional setup after loading the view.
        ///标题颜色
        //backgroundImage
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigation_ibackground"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        self.automaticallyAdjustsScrollViewInsets = false
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false  , animated: true )
    }
    deinit {
        mylog("销毁*******************************************")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        super.preferredStatusBarStyle
//        return UIStatusBarStyle.lightContent
//    }
//    override var prefersStatusBarHidden: Bool{
//        return true//return make for hidding statusBar , and navigationBar become shortter than normal
//    }
    //    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    //        super.preferredStatusBarUpdateAnimation
    //        return UIStatusBarAnimation.slide
    //
    //    }
}
