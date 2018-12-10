//
//  DDHomeModel.swift
//  Project
//
//  Created by WY on 2017/12/5.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit


class test : NSObject , Decodable {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
    private enum CodingKeys: String, CodingKey  {
        case isNeedJudge
        case actionKey
        case keyParameter
    }
    
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)
        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: test.CodingKeys.isNeedJudge)
        //           var container =  try decoder.container(keyedBy: CodingKeys.self)
        //        var container = decoder.container(keyedBy: CodingKeys.self)
        //            try container.decode(isNeedJudge, forKey:.isNeedJudge)
        //        try container.decode(isNeedJudge, forKey: DDActionModel.CodingKeys.isNeedJudge)
    }
}

class DDActionModel: NSObject , DDShowProtocol {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
//    private enum CodingKeys: String, CodingKey  {
//        case isNeedJudge
//        case actionKey
//        case keyParameter2
//    }
//
//    required init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: DDActionModel.CodingKeys.isNeedJudge)
//        actionKey = try container.decode(type(of: actionKey), forKey: DDActionModel.CodingKeys.actionKey)
//        keyParameter = try container.decode(type(of: keyParameter), forKey: DDActionModel.CodingKeys.keyParameter)
//    }
}
///data模型
class HomeDataModel   : NSObject , Codable{
    var banner : [DDHomeBannerModel] = [DDHomeBannerModel]()
    var notice : [DDHomeMsgModel] = [DDHomeMsgModel]()
    var function : [DDHomeFoundation] = [DDHomeFoundation]()
    var myshop : String?
    /// 0:未创建 非0 , 已创建 , 且代表team ID
    var create_team_status : String?
    /// 0:未加入 1:已加入
    var join_team_status : String?
    /// 0:未认证 1:已认证
    ////  -1、待提交 0、待审核 1、审核通过 2、审核不通过
    var member_examine_status : String?
    /// sign_team_type    string    1业务团队2维护团队
    var sign_team_type :   String?
}
///banner图
class DDHomeBannerModel:  DDActionModel , Codable{
    var image_url : String = ""
    var link_url : String = ""
    var target : String?
//    "image_url":"http://i0.bjyltf.com/function/1_1.png",
//    "link_url":"http://www.baidu.com"
}
///轮播消息
class DDHomeMsgModel:  DDActionModel ,Codable {
    var id : String    = ""
    var title : String = ""
//    "id":"1",
//    "title":"公告公告公告公告"
}
///模块儿
class DDHomeFoundation : DDActionModel , Codable {
    var id :  String?
    var name : String = ""
    var image_url  = ""
    var target = ""
    var status : String?
    var link_url : String?
    var shop_id : String?
    var team_id: String?
    var sign_member_type: String?
    var sign_team_type: String?
    
    /*
     "id":"1",
     "name":"安装业务",
     "image_url":"http://i0.bjyltf.com/function/1_1.png",
     "target":"anzhuang",
     "status":"1"
     */
}
