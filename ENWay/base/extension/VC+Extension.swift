//
//  VC+Extension.swift
//  Project
//
//  Created by WY on 2018/2/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
extension UIViewController {
    func pushVC(vcIdentifier : String , userInfo:Any? = nil ) {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as! String
        var clsName = vcIdentifier
        if !vcIdentifier.hasPrefix(namespace + ".") {
            clsName = namespace + "." + vcIdentifier
        }
        //UICollectionViewController
        if let cls = NSClassFromString(clsName) as? UICollectionViewController.Type{
            let vc = cls.init(collectionViewLayout: UICollectionViewFlowLayout())
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else if let cls = NSClassFromString(clsName) as? UIViewController.Type{
            let vc = cls.init()
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("there is no class:\(vcIdentifier)  from string:\(vcIdentifier)")
        }
    }
    static var userInfo: Void?
    /** key parameter of viewController */
    @IBInspectable var userInfo: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.userInfo)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.userInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    @discardableResult
    func alert(title:String = "提示",detailTitle:String? = nil ,style :UIAlertController.Style = UIAlertController.Style.alert ,actions:[UIAlertAction] ) -> UIAlertController{
        let actionVC = UIAlertController.init(title: title, message:detailTitle, preferredStyle: style)
        for action in actions{
            actionVC.addAction(action)
        }
        self.present(actionVC, animated: true, completion: nil)
        return actionVC
    }
    func openSetting(){
        DispatchQueue.main.async {
            let url : URL = URL(string: UIApplication.openSettingsURLString)!
            if UIApplication.shared.canOpenURL(url ) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: { (bool ) in
                        
                    })
                } else {
                    // Fallback on earlier versions
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
}
