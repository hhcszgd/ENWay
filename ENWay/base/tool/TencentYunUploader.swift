//
//  TencentYunUploader.swift
//  Project
//
//  Created by WY on 2018/8/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
/*
class TencentYunUploader: NSObject {
    static var clients : [COSClient] = [COSClient]()

    
    static func uploadMediaToTencentYun(image:UIImage ,progressHandler:@escaping ( Int,  Int, Int)->(),compateHandler : @escaping (_ imageUrl:String?)->())  {
        let client = COSClient.init(appId: "1255626690", withRegion: "sh")
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath = docuPath  {
            var fileNameInServer = "\(Date().timeIntervalSince1970 )"
            if fileNameInServer.contains("."){
                if let index = fileNameInServer.index(of: "."){
                    fileNameInServer.remove(at: index)
                }
            }
            let filePath = realDocuPath + "/\(fileNameInServer).JPEG"
            let filePathUrl = URL(fileURLWithPath: filePath, isDirectory: true )
            mylog(filePath)
            do{
                let _ = try UIImageJPEGRepresentation(image, 0.5)?.write(to: filePathUrl)
                DDRequestManager.share.requestTencentSign(true)?.responseJSON(completionHandler: { (response) in
                    guard  let dict =  response.value as? [String:String] else{
                        compateHandler(nil); return}
                    let signStr = dict["token"]
                    let id = DDAccount.share.id ?? "0"
                    let uploadTask = COSObjectPutTask.init(path: filePath, sign: signStr, bucket: "yulongchuanmei", fileName: fileNameInServer + ".JPEG", customAttribute: "temp", uploadDirectory: "member/\(id)", insertOnly: true)
                    
                    client?.completionHandler = {(/*COSTaskRsp **/resp, /*NSDictionary */context) in
                        try? FileManager.default.removeItem(atPath: filePath)
                        if let  resp = resp as? COSObjectUploadTaskRsp{
                            //                            mylog(context)
                            //                            mylog(resp.descMsg)
                            //                            mylog(resp.fileData)
                            //
                            mylog(resp.data)
                            dump(resp)
                            mylog(resp.sourceURL)//发给服务器
                            mylog(resp.httpsURL)
                            mylog(resp.objectURL)
                            mylog(resp.retCode)
                            if (resp.retCode == 0) {
                                //sucess
                                compateHandler(resp.sourceURL)
                            }else{
                                
                                compateHandler("failure")
                                GDAlertView.alert("图片上传失败", image: nil, time: 1, complateBlock: nil)
                            }
                        }
                        if let c = client , let index = clients.index(of: c){
                            clients.remove(at: index)
                        }
                    };
                    client?.progressHandler = {( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        progressHandler(Int(bytesWritten), Int(totalBytesWritten), Int(totalBytesExpectedToWrite))
                        mylog("\(bytesWritten)---\(totalBytesWritten)---\(totalBytesExpectedToWrite)")
                        //progress
                    }
                    client?.putObject(uploadTask)
                    if let c = client{
                        clients.append(c)
                    }
                    
                })
                
                
                
                
            }catch{
                mylog(error)
                compateHandler(nil)
            }
            
            //            let filePath = realDocuPath.append//appendingPathComponent("Account.data")
        }
    }
    
    
    
    
    
    
    
}
*/
