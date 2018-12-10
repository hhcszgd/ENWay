//
//  GDStorgeManager.swift
//  zjlao
//
//  Created by WY on 17/11/18.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

/*
 获取历史消息逻辑步骤 :
 1.1 , 当服务器没有聊天历史 ,就标记noServerMessage , 只操作本地数据
 1.2 , 当服务器有了聊天历史 ,标记hadServerMessage , 第一次进入聊天界面就请求一次接口 , 以获取一个最小的消息id , 并保存minMessageID
 1.3 , 如果本地存消息 , 一定要保证有准确的最小sort_key对应的消息id
 2.1 , 每次上拉到上限以后 , 用minMessageID去请求服务器历史消息 并插入数据库
 3.1 , 以后再进入聊天界面 , 最小的sort_key对应的serverID一定有值(非空) , 就拿它来去服务器请求
 
 
 1 , 先从数据库取
 1,1 本地能取到就加载 , 取到最后一条时再从网络获取聊天记录并插入数据库 , 再接着从数据库读取并展示 , 新的聊天记录正常插入数据库
 1.2 本地取不到的话 , 就去网络获取聊天记录并插入数据库 , 再从数据库读取并展示 , 新的聊天记录正常插入数据库
 1.3 本地取不到 , 服务器也取不到的话 , 新的聊天记录不做数据库存储
 */

import UIKit
import FMDB
/// 存储类
class DDStorgeManager: UserDefaults {
    //MARK:单例
    static  let share : DDStorgeManager  = {
        let tempShare  = DDStorgeManager.init()
        
        return tempShare
    }()
    var dbPath : String {
        let dbName = "LocalDB"
        let libraryDirectoryPath  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true ).first!;
        let dbPath = libraryDirectoryPath.appending("/\(dbName).db")
        return dbPath
    }
    lazy var dbQueue = {
        return FMDatabaseQueue.init(path: self.dbPath)
    }
    
    func createTable(SQLSentence:String)  {
        gotCurrentDBQueue().inDatabase({ (db) in
            let isMessageSuccessOption =  (db.executeStatements(SQLSentence))
            if(isMessageSuccessOption){
                mylog("建表成功:\(SQLSentence)")
            }else{
                mylog("建表失败:\(SQLSentence)")
            }
            
        })
    }
    
    func deleteDB( callBack:@escaping ((_ isSucess:Bool ,_ resultStr : String)->())) -> () {//done
//        let libr  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true ).first;
        do {
            try FileManager.default.removeItem(atPath: dbPath)
            mylog("文件删除成功")
            callBack(true,"文件删除成功")
        } catch  {
            mylog("文件删除失败\(error)")
            callBack(false,"文件删除失败")
        }
    }
    
//////////////////////////////////////////////////////
    
    
    
    
    
    func sqlSentenceTest() {
        let  SQLStr = "insert into message (full_message_xml, other_account ,my_account, time_stamp , body , server_id ,local_id ,from_account ,to_account , sort_key ) values (?,?,?,?,?,?,?,?,?,?)"
        let delete = "delete from contact where other_account = '\("userName")'"
        let select = "select *   from message  group by other_account HAVING max(time_stamp) order by time_stamp DESC"
        let update = "update message set server_id = '\("serverID")' where local_id = '\("localID")'"
    }
    
    func gotCurrentDBQueue() -> (FMDatabaseQueue) {
        let que  = FMDatabaseQueue.init(path: dbPath)
        
        let  sqlContact = "CREATE TABLE IF NOT EXISTS contact(id INTEGER PRIMARY KEY AUTOINCREMENT ,last_message varchar(255),my_account varchar(255),other_account varchar(255) , time_stamp int , server_id varchar(32) , local_id varchar(32) , has_read int NOT NULL DEFAULT '0',from_account varchar(255))"
        
        let  sqlMessage = "CREATE TABLE IF NOT EXISTS message(id INTEGER PRIMARY KEY AUTOINCREMENT ,full_message_xml varchar(255),body varchar(255),my_account varchar(255),other_account varchar(255) , time_stamp int , server_id varchar(32) , local_id varchar(32) , has_read int NOT NULL DEFAULT '0',send_success int NOT NULL DEFAULT '1', from_account varchar(255)  ,  to_account varchar(255), sort_key int) ";
        que?.inDatabase({ (db) in
            let isContactSuccessOption =  (db.executeStatements(sqlContact))
            if(isContactSuccessOption){
                mylog("建立Contact表成功")
            }else{
                mylog("建表Contact失败,重复创建")
            }
        })
        que?.inDatabase({ (db) in
            let isMessageSuccessOption =  (db.executeStatements(sqlMessage))
            if(isMessageSuccessOption){
                mylog("建立Message表成功")
            }else{
                mylog("建表Message失败,重复创建")
            }
            }
        )
        return que!
    }
}
