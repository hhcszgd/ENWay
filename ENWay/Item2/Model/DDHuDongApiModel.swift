//
//  DDHuDongApiModel.swift
//  Project
//
//  Created by WY on 2017/12/22.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
class DDHuDongApiModel: NSObject , Decodable {
    var status : Int = 0
    var message : String = ""
    var data : [DDRowMessageModel]?  = [DDRowMessageModel]()
//    enum CodingKeys : String ,CodingKey {
//        case status
//        case message
//        case data
//    }
//    required init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self )
//        status = try container.decode(Int.self , forKey: DDHuDongApiModel.CodingKeys.status)
//        message = try container.decode(String.self , forKey: DDHuDongApiModel.CodingKeys.message)
//        var unKeydContainer = try container.nestedUnkeyedContainer(forKey: DDHuDongApiModel.CodingKeys.data)
//        var tempData = [AnyObject]()
    
//        while !unKeydContainer.isAtEnd {
//            mylog(unKeydContainer.codingPath)
//            mylog(unKeydContainer.count)
//            mylog(unKeydContainer.currentIndex)
//            do{
//                let result = try unKeydContainer.decode(DDCreateBoardModel.self)
//                tempData.append(result)
//                continue;
//            }catch{
//
//            }
//            do{
//                let result = try unKeydContainer.decode(DDSendCommentModel.self)
//                tempData.append(result)
//                continue;
//            }catch{
//
//            }
//            do{
//                let result = try unKeydContainer.decode(DDAboutShopModel.self)
//                tempData.append(result)
//                continue;
//            }catch{}
//            do{
//                let result = try unKeydContainer.decode(DDFruitionModel.self)
//                tempData.append(result)
//                continue;
//            }catch{}
//        }
//        data = tempData
//    }
}

/// 消息模型基类
//class DDRowMessageModel: NSObject , Codable {
//    var data_type = ""
//    var lat = ""
//    var lng = ""
//}
/// data_type=1 //发表了评论的界面模型
class DDRowMessageModel: NSObject  , Codable{

//class DDSendCommentModel: NSObject  , Codable{
    var data_type = ""
    var lat = ""
    var lng = ""
    var member_id : String?
    var nickname = ""
    
    
    
    var comment_id : String?
    var content :String? = ""
    var country_id : String?
    var good_number : Int?
    var hand_image : String? = ""
    var images : [DDHuDongImageModel]?

    var shop_id : String?
    var shop_name :String? = ""
//}
/// data_type=7//创建搭伙的消息
//class DDCreateBoardModel: NSObject  , Codable{
//    var data_type = ""
//    var lat = ""
//    var lng = ""
    
    var board_desc:String? = ""
    var board_id : String?
    var board_name:String? = ""
//    var hand_image = ""
//    var member_id = 0
    var members : [DDHuDongMemberModel]?
//    var nickname = ""
//}
/// data_type=15入住店铺的通知消息界面模型/data_type=10发现店铺/data_type=4关注店铺
//class DDAboutShopModel: NSObject , Codable {
//    var data_type = ""
//    var lat = ""
//    var lng = ""
    var average_consume : String?
    var distance : Int?
    var create_at : String?
//    var country_id = 0
//    var hand_image = ""
//    var member_id = 0
//    var nickname = ""
    var push_id :String? 
    var services : String?
    var shop_classify_name :String? = ""
//    var shop_id = 0
    var shop_logo_image :String? = ""
//    var shop_name = ""
    var shop_score :String? = ""
//}
/// data_type=6//成就
//class DDFruitionModel : NSObject , Codable {
//    var data_type = ""
//    var lat = ""
//    var lng = ""
    var achieve_id :String? = ""
    var achieve_image:String?  = ""
    var achieve_name:String? = ""
//    var hand_image = ""
//    var member_id = 0
//    var nickname = ""
}


class DDHuDongMemberModel : NSObject , Codable{
    var hand_image = ""
    var member_id = ""
    
}
class DDHuDongImageModel : NSObject , Codable{
    var image = ""
    var thumbnail = ""
    var type = ""
    
}







/*
 
 /// 消息模型基类
 //class DDRowMessageModel: NSObject , Codable {
 //    var data_type = ""
 //    var lat = ""
 //    var lng = ""
 //}
 /// data_type=1 //发表了评论的界面模型
 class DDSendCommentModel: NSObject  , Codable{
 var data_type = ""
 var lat = ""
 var lng = ""
 var comment_id : Int = 0
 var content = ""
 var country_id : Int = 0
 var good_number : Int  = 0
 var hand_image : String? = ""
 var images : [DDHuDongImageModel]?
 var member_id : Int  = 0
 var nickname = ""
 var shop_id : Int = 0
 var shop_name = ""
 }
 /// data_type=7//创建搭伙的消息
 class DDCreateBoardModel: NSObject  , Codable{
 var data_type = ""
 var lat = ""
 var lng = ""
 
 var board_desc = ""
 var board_id : Int = 1;
 var board_name = ""
 var hand_image = ""
 var member_id = 0
 var members : [DDHuDongMemberModel]?
 var nickname = ""
 }
 /// data_type=15入住店铺的通知消息界面模型/data_type=10发现店铺/data_type=4关注店铺
 class DDAboutShopModel: NSObject , Codable {
 var data_type = ""
 var lat = ""
 var lng = ""
 var average_consume : Int = 0
 var country_id = 0
 var hand_image = ""
 var member_id = 0
 var nickname = ""
 var push_id = 0
 var services : String?
 var shop_classify_name = ""
 var shop_id = 0
 var shop_logo_image = ""
 var shop_name = ""
 var shop_score = ""
 }
 /// data_type=6//成就
 class DDFruitionModel : NSObject , Codable {
 var data_type = ""
 var lat = ""
 var lng = ""
 var achieve_id = ""
 var achieve_image = ""
 var achieve_name = ""
 var hand_image = ""
 var member_id = 0
 var nickname = ""
 }
 */
