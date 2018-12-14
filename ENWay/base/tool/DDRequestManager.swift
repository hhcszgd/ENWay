
//  DDRequestManager.swift
//  ZDLao
//
//  Created by WY on 2017/10/17.
//  Copyright © 2017年 com.16lao. All rights reserved.
//app address : https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8
/*
 status = 1;
 id = 4;
 name = JohnLock;
 token = 5ebfcf173717960b25b270f06c401d20;
 avatar = http://f0.ugshop.cn/FilF9WGuUGZW5eX-WtfvpFoeTsaY;
 */
/*
 灰度环境地址:
 接口          hapi.bjyltf.com
 支撑平台   hcms.bjyltf.com
 WAP端     hwap.bjyltf.com
 PC端        hpc.bjyltf.com
 
 */
import UIKit
import Alamofire
import CoreLocation

enum DomainType : String  {

    #if DEBUG
    /// 正式环境
        case api  = "https://api.bjyltf.com/"
        case wap = "https://wap.bjyltf.com/"
    
    /// 测试环境
//    case api  = "https://tpi.bjyltf.com/"
//    case wap = "https://tap.bjyltf.com/"

    /// 开发环境
//        case api = "http://api.bjyltf.cc/"
//        case wap = "http://wap.bjyltf.cc/"
    
    
    ///灰度环境
    //        case api = "http://hapi.bjyltf.com/"
    //        case wap = "http://hwap.bjyltf.com/"
    #else
        case api  = "https://api.bjyltf.com/"
        case wap = "https://wap.bjyltf.com/"
    
    #endif

}
class DDRequestManager: NSObject {
//    let version = "v1/"
    let version = "v\(DDCurrentAppVersion)/"
    var sessionManager : SessionManager!
    var token : String? = "token"
    static let share : DDRequestManager = {
        
        
//        let mgr = DDRequestManager()
////        mgr.result.session.configuration.timeoutIntervalForRequest = 10
//        return mgr
        let man = DDRequestManager()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval.init(10)
        //        sessionConfig.timeoutIntervalForResource = TimeInterval.init(10)
        //        let urlSession = URLSession.init(configuration: sessionConfig)
        let sessionDelegate = SessionDelegate()
        let urlSession = URLSession(configuration: sessionConfig, delegate: sessionDelegate, delegateQueue: nil)
        man.sessionManager = SessionManager.init(session: urlSession, delegate: sessionDelegate)
        mylog(man.sessionManager)
        let time = man.sessionManager.session.configuration.timeoutIntervalForRequest
        mylog(time )
        mylog(man.sessionManager.session.configuration.timeoutIntervalForRequest )
        return man
    }()
    var networkStatus : (oldStatus : Bool , newStatus : Bool ) =  (oldStatus : false , newStatus : false )
    lazy var networkReachabilityManager: NetworkReachabilityManager? = {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = {status in
            self.networkStatus.oldStatus = self.networkStatus.newStatus
            switch status {
            case .notReachable:
                mylog("1")
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .unknown :
                mylog("2")
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                self.networkStatus.newStatus = false
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                mylog("3")
                self.networkStatus.newStatus = true
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.networkStatus.newStatus = true
                mylog("4")
                break
            }
            NotificationCenter.default.post(name: NSNotification.Name("DDNetworkChanged"), object: nil, userInfo: ["status":self.networkStatus])
        }
        return reachabilityManager
    }()
//    let result = SessionManager.default
    private func performRequest(url : String,method:HTTPMethod , parameters: Parameters? , alertNetworkError  :Bool = true ,  print : Bool = false  ) -> DataRequest? {
        var errorMessage = ""
        if let status = networkReachabilityManager?.networkReachabilityStatus{
            switch status {
            case .notReachable:
                break
                errorMessage = "连接失败,请检查网络后重试"
//                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
//                return nil
                errorMessage = "连接失败,请检查网络后重试"
            case .unknown :
//                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                break
//                return nil
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
            }
        }
        
        
        var parameters = parameters == nil ? Parameters() : parameters!
        parameters["l"] = DDLanguageManager.languageIdentifier
        parameters["c"] = DDLanguageManager.countryCode
//        let url = replaceHostSurfix(urlStr: url, surfix: hostSurfix)
        var url = (DomainType.api.rawValue + version) + url
//        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? url 
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: method , parameters: parameters ).responseJSON(completionHandler: { (response) in
                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    if errorMessage.count <= 0 {
                        errorMessage = "请求失败,请重试"
                    }
                    if alertNetworkError {
                        GDAlertView.alert(errorMessage, image: nil , time: 2, complateBlock: nil )//请求超时处理
                        
                    }
                    break
                }
            })
            return result
        
//                .responseJSON(completionHandler: { (response) in
//                mylog(String.init(data: response.data ?? Data(), encoding: String.Encoding.utf8))
//                mylog("print request result -->:\(response.result)")
//                "xx".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
//                let testOriginalStr = "http://www.hailao.com/你好世界"
//                let urlEncode = testOriginalStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
//                let urlDecodeStr = urlEncode?.removingPercentEncoding
//                mylog("encode : \(urlEncode)")
//                mylog("decode : \(urlDecodeStr)")
//                
//                let tt = "\\U751f\\U6210key\\U6210\\U529f"
////                mylog("tttt\(tt.u)")
//            })
        }else{
            GDAlertView.alert("url error", image: nil, time: 3, complateBlock: nil)
            return nil
            
        }
    }
    private  func replaceHostSurfix( urlStr : String , surfix : String = "cn") -> String {
//        var urlStr = "http://www.baidu.com/fould/tindex.html?name=name"
        var urlStr  = urlStr
        if let url = URL(string: urlStr) {
            var host = url.host ?? ""
            let http = url.scheme ?? "" //http or https
            let index = host.index(host.endIndex, offsetBy: -3)
            let willReplaceStr = "\(http)://\(host)"
            let willReplaceRange = willReplaceStr.startIndex..<willReplaceStr.endIndex
            host.removeSubrange(index..<host.endIndex)
            if !host.hasSuffix("."){host = "\(host)."}
            host.append(contentsOf: surfix)
            let destinationStr  = "\(http)://\(host)"
            urlStr.replaceSubrange(willReplaceRange, with: destinationStr)
            mylog("converted:\(urlStr)")
        }
        return urlStr
    }
    
 
    /*
     home page api
     */
    @discardableResult
    func homePage(_ print : Bool = false ) -> DataRequest? {
        let url  =  "index"
//        "40d1783fbb98f6ed3b17c661786d5edf"
        let para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /*
     func edit page  api
     */
    @discardableResult
    func funcEditPage(_ print : Bool = false ) -> DataRequest? {
        let url  =  "function"
        let para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
  
    
    /// message page api
    @discardableResult
    func messagePage(keyword:String? = nil  , page : Int = 1, _ print : Bool = false ) -> DataRequest? {
//        dump(DDAccount.share)
        let url  =  "member/\(DDAccount.share.id ?? "0")/message"//TODO 1 要改成真是的memberID
        var para = ["token" : DDAccount.share.token ?? "","page":page] as [String : Any]
        if let  keywordUnwrap = keyword{ para["keyword"] = keywordUnwrap }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// message page api
    @discardableResult
    func changeSquence(json:String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "function"
        let para = ["token" : DDAccount.share.token ?? "","function_content":json]
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// partnerPageApi
    @discardableResult
    func partnerPage(keyword : String? , level : String?,page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/lower"//TODO 1 替换成真实memberID
        var para = ["token" : DDAccount.share.token ?? "","page":page ] as [String : Any]
        if let keyWord =  keyword {para["keyword"] = keyWord}
        if let level =  level {
            para["level"] = (level)
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
  
    
    
    func downFile(mediaModel : MediaModel  , complate:@escaping (String?) -> Void , process:((Progress)->())? = nil ) {
        let urlStr = mediaModel.urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        func deal(url:URL){
            var fullPath = ""
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = mediaModel.name
            let fileURL = documentsURL.appendingPathComponent(fileName)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                //            let fileURL = documentsURL.appendPathComponent("pig.png")
//                fullPath = fileURL.absoluteString
                mylog("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\(fileURL.absoluteString)")
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let request = Alamofire.download(url, to: destination).response { response in
                mylog(response)
                mylog("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\(response.destinationURL)")
                if response.error == nil, let filePath = response.destinationURL?.path {
                    //                let image = UIImage(contentsOfFile: imagePath)
                    complate(fileURL.absoluteString)
                    mylog("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\(filePath)")
                    
                }else{
                    complate(nil)
                }
            }
            request.downloadProgress { (progress ) in
                process?(progress)
                /*
                 totalUnitCount: Int64
                 The total number of units of work tracked for the current progress.
                 var completedUnitCount: Int64
                 */
            }
            
        }
        
        if let url = URL(string: urlStr){
            deal(url: url)
        }else if let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""){
            deal(url: url)
        }else{
            complate(nil)
        }
        
    }
    
    

    

    
    
    func testSha1Encode(imageFilePath:String , imageUrl:String) {
//        let data = UIImagePNGRepresentation(UIImage(named: "60b7a60ee8353be3")!)
        let path = Bundle.main.path(forResource: "1540095110743.jpg", ofType: nil)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let str = data?.sha1().toHexString()
        mylog("sha1 编码之后的字符串\(str)")
    }
    
   
    
    
   
    
    
    
}




class PHPRequestManager : NSObject, URLSessionDelegate{
    static let share = PHPRequestManager()
    var sessiono : URLSession?
    func test() {
        let url = URL(string: "https://wy.local/test1.php?key1=2&key2=4")!
        let request = NSMutableURLRequest(url: url )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let params
        
        var  session1 = URLSession(configuration: URLSessionConfiguration.default, delegate: self , delegateQueue: OperationQueue.main)
        self.sessiono = session1
        let dataTask = session1.dataTask(with: url) { (data , response , error ) in
            let result = String.init(data: data! , encoding:
                String.Encoding.utf8)
            mylog(result )
            mylog("\(data )--\(response)--\(error )")
        }
//        let dataTask = session1.dataTask(with: request){ (data , response , error ) in
//            mylog("\(data )--\(response)--\(error )")
//        }
        dataTask.resume()
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential , card )
        }
    }
}
/// test my server
extension DDRequestManager {
    
    /// request server api
    ///
    /// - Parameters:
    ///   - type: model type
    ///   - method: request method
    ///   - url: url
    ///   - parameters: parameters
    ///   - failure: invoke when mistakes
    ///   - success: invoke when success
    ///   - complate: invoke always (failure or success)
    @discardableResult
    private func requestMyselfServer<T:Codable>(type : T.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = false ,autoAlertWhileFailure : Bool = true  , success:@escaping (T)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
        //        let result = networkReachabilityManager?.startListening()
        //        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
            ////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("网络错误,请检查网络后重试", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
        
        let urlFull = url
        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        para["l"] = DDLanguageManager.languageIdentifier
        //        para["c"] = DDLanguageManager.countryCode
        para["l"] = "110"
        //        if urlFull != DomainType.api.rawValue + "Initkey/rest"{//初始化接口不需要token
        if needToken {
            if let tokenReal = DDAccount.share.token {
                para["token"] = tokenReal
            }else{
                
                
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                if autoAlertWhileFailure {
                    GDAlertView.alert("token为空,请退出并重新登录", image: nil, time: 2, complateBlock: nil)
                }
                return nil
            }
        }
        
        //            if let tokenReal = DDAccount.share.token {
        //                para["token"] = tokenReal
        //            }else{
        //
        //
        //                mylog("token is nil")
        //                failure?(DDError.noToken)
        //                complate?()
        //                return nil
        //            }
        //        }
        
        //        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
        if let url  = URL(string: urlFull){
            let task = DDRequestManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
                mylog(response.debugDescription.unicodeStr)
                switch response.result{
                case .success :
                    if let a = DDJsonCode.decode(T.self  , from: response.data){
//                    if let a = DDJsonCode.decodeAlamofireResponse(T.self, from: response){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                        if autoAlertWhileFailure {
                            GDAlertView.alert("服务器数据格式错误", image: nil, time: 2, complateBlock: nil)
                        }
                    }
                    //                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
                    //                        success(a)
                    //                        complate?()
                    //                    }else{
                    //                        failure?(DDError.modelUnconvertable)
                    //                        complate?()
                //                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("请求超时"))
                            if autoAlertWhileFailure {
                                GDAlertView.alert("请求超时", image: nil, time: 2, complateBlock: nil)
                            }
                        }else if error.code == -999{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("取消请求", image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError("取消请求"))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("服务器错误", image: nil, time: 2, complateBlock: nil)
                                }
                            }else{
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("服务器数据错误", image: nil, time: 2, complateBlock: nil)
                                }
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            if autoAlertWhileFailure {
                                GDAlertView.alert("服务端错误", image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("服务端数据错误", image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("url不合法", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
    }
    
    /// GET
    func getVideosFromMyselfServer(complated:@escaping (([String])->())){
        let url = "http://172.16.4.36/get_video.php"
        self.requestMyselfServer(type: [String].self , method: HTTPMethod.get, url: url , parameters: nil , needToken: false , autoAlertWhileFailure: true , success: { (result ) in
            mylog(result)
            complated(result)
            
        }, failure: { (error ) in
            complated([])
        }) {
            
        }
        
//        self.requestMyselfServer(type: String.self , method: HTTPMethod.get, url: "http://101.200.45.131/phpOfPublic/ConnectMysql.php", success: (T) -> ())
    }
}
extension DDRequestManager{
    
    

    
    
    
    /// request server api
    ///
    /// - Parameters:
    ///   - type: model type
    ///   - method: request method
    ///   - url: url
    ///   - parameters: parameters
    ///   - failure: invoke when mistakes
    ///   - success: invoke when success
    ///   - complate: invoke always (failure or success)
    @discardableResult
    private func requestServer<T>(type : ApiModel<T>.Type , method: HTTPMethod, url : String ,parameters: Parameters?  = nil  , needToken: Bool  = true,autoAlertWhileFailure : Bool = true  , success:@escaping (ApiModel<T>)->(),failure: ((_ error:DDError)->Void)? = nil   ,complate:(()-> Void)? = nil ) -> DataRequest? {
        //        let result = networkReachabilityManager?.startListening()
        //        mylog("是否  监听  成功  \(result)")
        mylog("\(networkReachabilityManager?.networkReachabilityStatus)")
        if let status = networkReachabilityManager?.isReachable , !status {
            ////            GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
            failure?(DDError.networkError)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("网络错误,请检查网络后重试", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
        
        let urlFull = DomainType.api.rawValue + version + url
        var para = Parameters()
        if let parametersUnwrap = parameters{para = parametersUnwrap}
        para["l"] = DDLanguageManager.languageIdentifier
        //        para["c"] = DDLanguageManager.countryCode
        para["l"] = "110"
//        if urlFull != DomainType.api.rawValue + "Initkey/rest"{//初始化接口不需要token
        if needToken {
            if let tokenReal = DDAccount.share.token {
                para["token"] = tokenReal
            }else{
                
                
                mylog("token is nil")
                failure?(DDError.noToken)
                complate?()
                if autoAlertWhileFailure {
                    GDAlertView.alert("token为空,请退出并重新登录", image: nil, time: 2, complateBlock: nil)
                }
                return nil
            }
        }
        
//            if let tokenReal = DDAccount.share.token {
//                para["token"] = tokenReal
//            }else{
//
//
//                mylog("token is nil")
//                failure?(DDError.noToken)
//                complate?()
//                return nil
//            }
//        }
        
        //        let language = DDLanguageManager.countryCode
        let language = "110"
        var header = [String : String]()
        header["APPID"] = "2"
        header["VERSIONMINI"] = "20160501"
        header["DID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["VERSIONID"] = "2.0"
        header["language"] = language
        
        if let url  = URL(string: urlFull){
            let task = DDRequestManager.share.sessionManager.request(url , method: method , parameters: para , headers:header).responseJSON(completionHandler: { (response) in
                //                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    
                    if let a = DDJsonCode.decodeAlamofireResponse(ApiModel<T>.self, from: response){
                        success(a)
                        complate?()
                    }else{
                        failure?(DDError.modelUnconvertable)
                        complate?()
                        if autoAlertWhileFailure {
                            GDAlertView.alert("服务器数据格式错误", image: nil, time: 2, complateBlock: nil)
                        }
                    }
//                    if let a = DDJsonCode.decodeToModel(type: ApiModel<T>.self , from: response.value as? String){
//                        success(a)
//                        complate?()
//                    }else{
//                        failure?(DDError.modelUnconvertable)
//                        complate?()
//                    }
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    mylog(response.result.error?.localizedDescription)
                    if let error = response.result.error as? NSError{
                        if error.code == -1001{
                            failure?(DDError.serverError("请求超时"))
                            if autoAlertWhileFailure {
                                GDAlertView.alert("请求超时", image: nil, time: 2, complateBlock: nil)
                            }
                        }else if error.code == -999{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("取消请求", image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError("取消请求"))
                        }else{
                            if let errorMsg = response.result.error?.localizedDescription {
                                failure?(DDError.serverError(errorMsg))
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("服务器错误", image: nil, time: 2, complateBlock: nil)
                                }
                            }else{
                                if autoAlertWhileFailure {
                                    GDAlertView.alert("服务器数据错误", image: nil, time: 2, complateBlock: nil)
                                }
                                failure?(DDError.otherError(nil))
                            }
                        }
                    }else{
                        if let errorMsg = response.result.error?.localizedDescription {
                            if autoAlertWhileFailure {
                                GDAlertView.alert("服务端错误", image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.serverError(errorMsg))
                        }else{
                            if autoAlertWhileFailure {
                                GDAlertView.alert("服务端数据错误", image: nil, time: 2, complateBlock: nil)
                            }
                            failure?(DDError.otherError(nil))
                        }
                    }
                    complate?()
                }
            })
            return task
        }else{
            failure?(DDError.urlUnconvertable)
            complate?()
            if autoAlertWhileFailure {
                GDAlertView.alert("url不合法", image: nil, time: 2, complateBlock: nil)
            }
            return nil
        }
    }
    
    
    
    ///获取签到界面数据
    @discardableResult
    func
        getBussinessSignPageData<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/sign"
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    ///搜索dianpu
    @discardableResult
    func shopSearch<T>(type : ApiModel<T>.Type,keyWord:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/shop-search"
        var para = [String:String ]()
        if let longitude = DDLocationManager.share.locationManager.location?.coordinate.longitude,let latitude = DDLocationManager.share.locationManager.location?.coordinate.latitude{
            para["longitude"] = "\(longitude)"
            para["latitude"] = "\(latitude)"
        }
        para["word"] = keyWord
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    ///  维护签到选择店铺列表
    func selectRepairShopList<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        var url =  "sign/shop-list"
        if let longitude = DDLocationManager.share.locationManager.location?.coordinate.longitude,let latitude = DDLocationManager.share.locationManager.location?.coordinate.latitude{
            url.append("/\(longitude)/\(latitude)")
            
        }
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    //    ///维护签到选择店铺列表未签到人
    //    @discardableResult
    //    func selectMaintainShopList<T>(type : ApiModel<T>.Type,create_at:String , team_id:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
    //        var url =  "shop-list"
    //        if let longitude = DDLocationManager.share.locationManager.location?.coordinate.longitude,let latitude = DDLocationManager.share.locationManager.location?.coordinate.latitude{
    //            url.append("/\(longitude)/\(latitude)")
    //
    //        }
    //        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil   , success: success, failure: failure, complate: complate)
    //    }

    ///团队足迹
    @discardableResult
    func teamFootprintPage<T>(type : ApiModel<T>.Type,page:Int, create_at : String? = nil,team_id:String? = nil   , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/team-footmark"
        var para = [String:String]()
        para["page"] = "\(page)"
//        if let create_at = create_at{
//            if create_at.contains("年"){
//                let dataFormate = DateFormatter()
//                dataFormate.dateFormat = "yyyy年MM月dd日"
//                let rempDate = dataFormate.date(from: create_at)
//                dataFormate.dateFormat = "yyyy-MM-dd"
//                let string = dataFormate.string(from: rempDate ?? Date())
//                para["create_at"] = string
//
//            }else{
//                para["create_at"] = create_at
//            }
//        }
        if let t = create_at{
            para["create_at"] = self.convertTime(time: t)
        }
        if let team_id = team_id{
            para["team_id"] = team_id
        }
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
   
    ///未签到人
    @discardableResult
    func notSignData<T>(type : ApiModel<T>.Type,create_at:String , team_id:String , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/not-sign"
        let string = self.convertTime(time: create_at)
        let para = ["create_at":string ,"team_id":team_id ]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    /// 足迹-管理员选择团队列表
    /// 负责人：    高建波
    /// Url地址：   sign/choose-team
    /// GET
    @discardableResult
    func selectTeam<T>(type : ApiModel<T>.Type , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/choose-team"
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    /// GET
    @discardableResult
    func getServerTime<T>(type : ApiModel<T>.Type , showDate : Bool = false , shouTime:Bool = true, minute : Bool = false , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        var url =  "system/get-date-time/\(showDate ? "1" : "0")/\(shouTime ? "1" : "0")"
        if minute{
            url.append("?minute=1")
        }
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:nil  , success: success, failure: failure, complate: complate)
    }
    
    /// GET
    @discardableResult
    func getPersonalSignDetail<T>(type : ApiModel<T>.Type , create_at : String , member_id:String, team_id : String,page:Int  , success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/single-sign-view"
        let para = ["create_at" :create_at ,"member_id" : member_id,"team_id" : team_id , "page":"\(page)"]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    /// GET
    @discardableResult
    func getOneTimeSignDetail<T>(type : ApiModel<T>.Type , id : String , member_id:String,success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/single-detail"
        let para = ["id" :id ,"member_id" : member_id]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    /// GET
    @discardableResult
    func getAllSignPoint<T>(type : ApiModel<T>.Type , team_id : String , create_at:String,success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        let url =  "sign/team-all-data"
        let string = self.convertTime(time: create_at)
        let para = ["team_id" :team_id ,"create_at" : string]
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    

    
    /// type : 1:累计收益 , 2:订单信息
    @discardableResult
    func getRewardDetail<T>(type : ApiModel<T>.Type , requestType : Int,page:Int = 1,id:String? = nil ,shop_id : String? = nil , head_id:String? = nil ,success:@escaping (ApiModel<T>)->() ,failure:( (_ error:DDError)->Void)? = nil  ,complate:(()-> Void)? = nil ) -> DataRequest?{
        var url = ""
        var  para = [String:String]()
        if requestType == 2{
            url = "reward/order-list"
            para["id"] =  id
            para["page"] = "\(page)"
        }else{//累计收益
            url = "reward/all"
            para["page"] = "\(page)"
            if let value = shop_id{
                    para["shop_id"] = "\(value)"
            }else if let value = head_id{
                para["head_id"] = "\(value)"
            }
        }
        
        return self.requestServer(type: type , method: HTTPMethod.get, url: url,parameters:para  , success: success, failure: failure, complate: complate)
    }
    
    
    func convertTime(time:String) -> String{
        if time.contains("年"){
            let dataFormate = DateFormatter()
            dataFormate.dateFormat = "yyyy年MM月dd日"
            let rempDate = dataFormate.date(from: time)
            dataFormate.dateFormat = "yyyy-MM-dd"
            let string = dataFormate.string(from: rempDate ?? Date())
            return string
        }else{
            return time
        }
    }
}

