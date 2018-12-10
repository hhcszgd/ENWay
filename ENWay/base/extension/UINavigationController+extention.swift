//
//  UINavigationController+extention.swift
//  Project
//
//  Created by WY on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

extension UINavigationController{
@discardableResult

    func popToSpecifyVC(_ vcType : UIViewController.Type , animate:Bool = true ) -> UIViewController? {
        for vc  in self.viewControllers{
            if vc.isKind(of: vcType){
                self.popToViewController(vc , animated: animate)
                return vc
            }
        }
        return nil
    }
    
    @discardableResult
    func removeSpecifyVC(_ vcType : UIViewController.Type  ) -> UIViewController? {
        
        
        for index in  0..<self.viewControllers.count {
            let targetIndex = self.viewControllers.count - 1 - index
            let targetVC = self.viewControllers[targetIndex]
            if targetVC.isKind(of: vcType){
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.59) {
                        self.viewControllers.remove(at: targetIndex)
                }
                
//                self.viewControllers.remove(at: targetIndex)
                //                targetVC.removeFromParentViewController()
                //                targetVC.willMove(toParentViewController: nil)
                //                targetVC.view.removeFromSuperview()
                //                mylog(targetIndex)
                //                dump(targetVC)
                return targetVC
            }
        }
        return nil
    }
}
