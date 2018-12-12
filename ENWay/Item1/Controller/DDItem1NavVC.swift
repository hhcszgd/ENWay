//
//  DDItem1NavVC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDItem1NavVC: DDBaseNavVC {
    convenience init(){
        let rootVC = DDItem1VC()
        
        rootVC.title = "工作"
//        rootVC.title = DDLanguageManager.text("tabbar_item1_title")
        self.init(rootViewController: rootVC)
        self.navigationBar.shadowImage = UIImage()
//        self.tabBarItem.image = UIImage(named:"workunselectedicons")
//        self.tabBarItem.selectedImage = UIImage(named:"workselectedicon")
        
        
        self.tabBarItem.image = UIImage(named:"workunselectediconsTabbar")
        self.tabBarItem.selectedImage = UIImage(named:"workselectediconTabbar")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mylog(DDAccount.share.id)
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
