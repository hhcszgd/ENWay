//
//  DDMessageApiModel.swift
//  Project
//
//  Created by WY on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

//class DDMessageApiModel: DDActionModel , Codable{
//    var status:Int = -1
//    var message:String = ""
//    var data:[DDMessageModel]?
//}
class DDMessageModel : DDActionModel , Codable{
    var id:String = ""
    var message_type:String = ""
    var title:String = ""
    /// 1 : 已读  , 0 : 未读
    var status : String? = ""
    var create_at : String?
//    var status : Int? = 0 
}
