//
//  DDShowModel.swift
//  ZDLao
//
//  Created by WY on 2017/10/17.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDShowModel: NSObject , DDShowProtocol{
    var isNeedJudge : Bool = false
    var actionKey : String = ""
    var keyParameter : Any?
    convenience init(_ actionKey:String, _ keyParameter:Any? = nil , _ isNeedLogin:Bool=false) {
        self.init()
        self.isNeedJudge = isNeedLogin
        self.actionKey = actionKey
        self.keyParameter = keyParameter
    }
}
