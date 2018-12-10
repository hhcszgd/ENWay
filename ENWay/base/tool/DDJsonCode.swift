//
//  DDJsonCode.swift
//  Project
//
//  Created by WY on 2018/3/29.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import Alamofire
class DDJsonCode: NSObject {
    ///静态加载，派发方式是直接派发。相当于class final,禁止被重写。
    static func decode<T>(_ type: T.Type, from jsonData: Data?)  -> T? where T : Decodable {
        var jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        mylog(jsonString)
        let jsonDecoder = JSONDecoder.init()
        
        if jsonData == nil {
            mylog(" to be decoded object is nil value")
            return nil
        }
        do{
            let t = try jsonDecoder.decode(T.self, from: jsonData!)
            return t
        }catch{
            mylog("jsonDecoderFailure:\(error)")
            mylog("jsonData : \(String(describing: String(data: jsonData!, encoding: String.Encoding.utf8)))")
            return nil
        }
    }
    static func decodeToModel<T>(type : ApiModel<T>.Type ,from string: String? ) -> ApiModel<T>?{
//        guard let JsonResult = String.AESDecode( codeStr: string ?? "" ) else{
//            mylog("AES 解密失败 服务器返回数据为: \(string)")
//            return nil
//        }
//        if printJson{mylog(JsonResult)}
        guard let s = string else{
            mylog("服务器返回Json为空")
            return nil
        }
        if let apiModel = DDJsonCode.decodeApiData(type: ApiModel<T>.self, from: s.data(using: String.Encoding.utf8) ?? Data()){
            return apiModel
        }else{
            return nil
        }
    }
    static func decodeApiData<T>(type : ApiModel<T>.Type ,from jsonData: Data? ) -> ApiModel<T>? {
        return self.decode(type, from: jsonData)
    }
    static func decodeAlamofireResponse<T>(_ type:  ApiModel<T>.Type, from alamofireResponse: DataResponse<Any>)  -> ApiModel<T>? {
        return self.decodeApiData(type: type, from: alamofireResponse.data)
    }
    ///    open func encode<T>(_ value: T) throws -> Data where T : Encodable

    static func encode<T:Encodable>(_ encodeAbleObj: T)  -> String? {
        let jsonEncoder = JSONEncoder.init()
        do{
            let jsonData = try  jsonEncoder.encode(encodeAbleObj)
            if let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonStr
            }else{
                mylog("the will be encode json is not utf8 code")
                return nil
            }
        }catch{
            mylog("jsonDecoderFailure:\(error)")
            return nil
        }
    }
}
