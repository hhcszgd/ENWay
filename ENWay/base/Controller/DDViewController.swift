//
//  DDViewController.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
enum DDLoadType : String {
    case refresh
    case initialize
    case loadMore
}
class DDViewController: UIViewController {
    var showModel : DDShowProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension DDViewController{
    var isFirstVCInNavigationVC : Bool{
        if let navigationVC = self.navigationController {
            if let index = navigationVC.viewControllers.index(of: self) , index == 0{
                return true
            }
        }
        return false
    }
    var indexInTabBarVC : Int?{
        if let tabBarVC = self.navigationController?.tabBarController {
            if let index = tabBarVC.viewControllers?.index(of: self.navigationController!) {
                return index
            }
        }
        if let tabBarVC = self.tabBarController {
            if let index = tabBarVC.viewControllers?.index(of: self) {
                return index
            }
        }
        return nil
    }
    
}
