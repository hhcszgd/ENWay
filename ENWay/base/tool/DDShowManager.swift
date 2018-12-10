//
//  DDShowManager.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
enum Actionkey: String {
    ///空，没有设置
    case 空 = "nil"
    ///账户信息
    case account = "account"
    ///姓名
    case name = "name"
    ///二维码
    case twoDimensionalCode = "two-dimensionalCode"
    ///电话
    case mobile = "mobile"
    ///公司信息
    case companyName = "companyName"
    ///公司电话
    case companyMobile = "companyMobile"
    ///余额
    case balance = "balance"
    ///冻结金额
    case amountOfMoney = "amountOfMoney"
    ///账户明细
    case accountDetails = "accountDetails"
    ///协商列表
    case nogatiationList = "nogatiationList"
    ///设置
    case profileSet = "profileSet"
    ///登录
    case login = "login"
    
}

///:the  old  skipManager
class DDShowManager: NSObject {
//    class func whow(currentVC : UIViewController , showParameter : DDShowProtocol){
//        if showParameter.isNeedJudge {
//            //perform login
//            
//            return
//        }
//        guard  let  destinationVC : DDViewController = getDestinationVC(showParameter: showParameter)else { return}
//        destinationVC.showModel  = showParameter
//        if let naviVC  = currentVC as? UINavigationController {
//            naviVC.pushViewController(destinationVC, animated: true )
//        }else{
//            currentVC.navigationController?.pushViewController(destinationVC, animated: true )
//        }
//    }
//    
//    class func skip(current: UIViewController?, model: GDModel) {
//        if model.isNeedJudge {
//            
//            if !DDAccount.share.isLogin {
//                current?.navigationController?.pushViewController(LoginVC(), animated: true)
//                return
//            }
//            
//        }
//        guard let vc = self.nextVC(model: model) as? GDNormalVC else {
//            return
//        }
//        vc.keyModel = model
//        current?.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    private class func getDestinationVC(showParameter:DDShowProtocol) -> DDViewController? {
//        switch showParameter.actionKey {
//        case "WEB":
//            return GDBaseWebVC()
//        default:
//            mylog("找不到对应的控制器")
//            return nil
//        }
//    }
//    private class func nextVC(model: GDModel) -> UIViewController? {
//        switch model.actionKey {
//        
//        default:
//            return nil
//        }
//        
//    }
    
}
