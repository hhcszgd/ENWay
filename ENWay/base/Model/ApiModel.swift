//
//  ApiModel.swift
//  Project
//
//  Created by WY on 2018/3/29.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ApiModel<T : Codable>: NSObject , Codable{
    var status : Int = 0
    var message : String = ""
    var data: T?
}
///class T example
class ExampleModel: NSObject , Codable {
    var a = 0
}
private func testDecode(){
    if let model = DDJsonCode.decode(ApiModel<ExampleModel>.self, from: nil ){
        mylog(model.data)
    }
}
extension Decodable{
    static func decodeProterty<Key>(container :  KeyedDecodingContainer<Key> , codingKey :  KeyedDecodingContainer<Key>.Key) -> String {
        do {
            let stringValue  = try container.decode(String.self , forKey: codingKey)//按String处理
            return stringValue
        } catch  {
            do {
                let intValue =  try container.decode(Int.self , forKey: codingKey)//再按Int处理
                let stringValue  = "\(intValue)"
                return stringValue
            } catch  {
                do {
                    let floatValue =  try container.decode(Float.self , forKey: codingKey)//再按float处理
                    let stringValue  = "\(floatValue)"
                    return stringValue
                } catch  {
                    return ""
                }
            }
        }
    }
}
