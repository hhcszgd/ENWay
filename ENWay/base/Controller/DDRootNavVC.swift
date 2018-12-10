//
//  DDRootVC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDRootNavVC: DDBaseNavVC  ,UITabBarControllerDelegate{
    var priviousVC = UINavigationController() //记录上一次控制器
    var tabBarVC : DDRootTabBarVC{
        return self.children[0] as! DDRootTabBarVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    convenience  init() {
        let rootTabBarVC = DDRootTabBarVC()
        self.init(rootViewController: rootTabBarVC)
        rootTabBarVC.delegate = self
        self.setNavigationBarHidden(true , animated: false )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: tabbarViewControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        self.priviousVC = tabBarVC.selectedViewController as! UINavigationController //记录上一次控制器
        return true
//        guard  let _ =  viewController as? ShopCarNaviVC else {  return true}//cancle shopCar judging
        
        /// cancle shopCar judging
//        if Account.shareAccount.isLogin {
//            return true
//        }else{
//            let loginVC = LoginVC()
//            loginVC.loginDelegate = self
//            let loginNaviVC = LoginNaviVC.init(rootViewController: loginVC)
//            loginNaviVC.navigationBar.isHidden = true
//            UIApplication.shared.keyWindow!.rootViewController!.present(loginNaviVC, animated: true, completion: nil)
//            return false
//        }
        
        
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        if let bool = tabBarVC.selectedViewController?.isKind(of: DDItem1NavVC.self) {
            if bool && self.priviousVC == viewController{
                mylog("tabBarItem1 reclick notification")
                NotificationCenter.default.post(name: DDTabBarItem1Reclick, object: nil, userInfo: nil)
            }
        }
        if let bool = tabBarVC.selectedViewController?.isKind(of: DDItem2NavVC.self) {
            if bool && self.priviousVC == viewController {
                NotificationCenter.default.post(name: DDTabBarItem2Reclick, object: nil, userInfo: nil)
                mylog("tabBarItem2 reclick notification")
            }
        }

        
    }
    
//    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
//
//        let ani : TabBarVCAnimat = TabBarVCAnimat()
//        //mylog(fromVC)
//        //mylog(toVC)
//        //mylog(self.mainTabbarVC?.selectedViewController)
//        return ani
//    }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.keyVCDelegate?.languageHadChanged()
//    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func selectChildViewControllerIndex(index : Int) -> () {
        if let naviVC = tabBarVC.selectedViewController as? UINavigationController{
            naviVC.popToRootViewController(animated: false)
        }
        var selectedIndex = index
        if selectedIndex < 0  {
            selectedIndex = 0
        }else if selectedIndex >= 4{
            selectedIndex = 4
        }
//        else if selectedIndex == 3 {//cancle shopCar judging
//            if DDAccount.shareAccount.isLogin {
//                tabBarVC.selectedIndex = selectedIndex
//            }else{
//                let loginVC = LoginVC()
//                loginVC.loginDelegate = self
//                let loginNaviVC = LoginNaviVC.init(rootViewController: loginVC)
//                UIApplication.shared.keyWindow!.rootViewController!.present(loginNaviVC, animated: true, completion: nil)
//
//            }
//        }
        tabBarVC.selectedIndex = selectedIndex
    }
    
    ////cancle shopCar judging
//    func loginResult(result: Bool) {
//        if result {
//            mainTabbarVC?.selectedIndex = 3
//        }
//    }
    
}
