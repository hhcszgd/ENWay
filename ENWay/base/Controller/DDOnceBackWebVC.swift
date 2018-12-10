//
//  DDOnceBackWebVC.swift
//  Project
//
//  Created by WY on 2018/9/1.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import WebKit
class DDOnceBackWebVC: DDNormalVC , WKScriptMessageHandler ,  WKNavigationDelegate,WKUIDelegate {


    let webView : WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.webView)
        self.layoutsubviews()
        // Do any additional setup after loading the view.
    }
    
    
    func layoutsubviews() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.configuration.preferences.javaScriptEnabled = true
        self.webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        //        self.webView.allowsBackForwardNavigationGestures = true //会出现不愿看到的返回列表
        //- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;
        self.webView.configuration.userContentController.add(self , name : "ylcm")//传值的关键 , 释放的时候记得移除
        
        
        var  webViewY = 64
//        if DDDevice.type == .iphoneX {webViewY = 88}
        if DDDevice.isFullScreen {webViewY = 88}
        var webViewH = UIScreen.main.bounds.height - DDNavigationBarHeight
//        if DDDevice.type == .iphoneX {webViewH -= 34}
        if DDDevice.isFullScreen {webViewH -= 34}
        self.webView.frame = CGRect(x: 0.0, y: DDNavigationBarHeight, width: UIScreen.main.bounds.width, height: webViewH)
        //        guard let model = self.showModel else {
        ////            mylog("webViewController的关键模型为nil\(self.showParameter)")
        //            return
        //        }
        //        guard let keyParamete = self.showModel?.keyParameter else {
        ////            mylog("webViewController的模型关键参数为空\(self.showParameter)")
        //            return
        //        }
        guard let urlStr = self.userInfo as? String else {
            //            mylog("webViewController对应的url字符串不存在\(self.showParameter)")
            return
        }
        
        if let token = DDAccount.share.token {
            
            var urlStrAppendToken  = ""
            if urlStr.contains("?"){
                urlStrAppendToken = urlStr.appending("&token=\(token)")
            }else{
                urlStrAppendToken = urlStr.appending("?token=\(token)")
            }
            mylog(urlStrAppendToken)
            if  urlStrAppendToken.hasPrefix("https://") || urlStrAppendToken.hasPrefix("http://") {
                guard let url  = URL.init(string: urlStrAppendToken ) else {
                    mylog("webViewController的urlStr字符串转换成URL失败")
                    return
                }
                
                let urlRequest = URLRequest.init(url: url)
                self.webView.load(urlRequest)
                
            }else if urlStrAppendToken.hasPrefix("file://"){
                guard let url  = URL.init(string: urlStrAppendToken ) else {
                    mylog("webViewController的urlStr字符串转换成URL失败")
                    return
                }
                
                let urlRequest = URLRequest.init(url: url)
                self.webView.load(urlRequest)
            }
        }else{
            if let  urlstring = self.userInfo as? String  {
                guard let url  = URL.init(string: urlstring  ) else {
                    mylog("webViewController的urlStr字符串转换成URL失败")
                    return
                }
                
                let urlRequest = URLRequest.init(url: url)
                self.webView.load(urlRequest)
                
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //MARK:接受js传过来的参数
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        mylog(message.body)
        mylog(message.name)
        self.analysisTheDateFromJS(message:message)
    }
    //MARK:解析js传过来的数据 , 并执行相应的操作
    func analysisTheDateFromJS(message : WKScriptMessage)  {
        if (message.name == "ylcm") {
            if let dict = message.body as? [String:String?] {//字典的值都为字符串
                if let actionOption  = dict["action"] {
                    if let action  = actionOption /* as? String */ {
                        performJumpBy(stringIdentify:action ,  dict : dict as [String : AnyObject])
                        
                    }
                    
                }
            }else {
                
                let jsonDecode = JSONDecoder.init()
                if let string = message.body as? String{
                    if let data = string.data(using: String.Encoding.utf8){
                        if let result = try?  jsonDecode.decode([String:String].self , from: data ){
                            performJumpBy(stringIdentify:result["action"] ?? "" , dict : result as [String : AnyObject])
                        }
                        
                    }
                }
                
            }
        }else{
            mylog("js的方法名未在本地注册")
        }
    }
    
    
    func performJumpBy(stringIdentify:String , dict : [String : AnyObject] ) {
        let action = stringIdentify
        switch action  {
        case "alert"://弹框操作
            self.performAlertWith(dictParamete: dict as [String : AnyObject])
            break
        case "confirm"://确认操作
            self.performConfirmWith(dictParamete: dict as [String : AnyObject])
            break
        case "jump"://跳转操作
            self.performJumpWith(dictParamete: dict as [String : AnyObject])
            break
        case "pay"://支付操作
            self.performPayWith(dictParamete: dict as [String : AnyObject])
            break
        case "share"://分享操作
            self.performShareWith(dictParamete: dict as [String : AnyObject])
            break
        case "dissolveteam"://分享操作
            self.dissolveTeam()
            break
        case "closewebview", "closewebviewbycreateshop"://关闭webView
            
            _ = self.navigationController?.popViewController(animated: true)
            break
        case "scan"://分享操作
            var id = ""
            if let tempID = dict["scanid"] as? String {id = tempID}
            let vc = QRCodeScannerVC()
            vc.complateHandle = {[weak self ] resultStr in
                mylog(resultStr)
                self?.webView.evaluateJavaScript("scan_end(\"\(id)\",\"\(resultStr)\"", completionHandler: { (result , error ) in
                    mylog(result)
                })
            }
            self.navigationController?.pushViewController(vc , animated: true )
            //                            self.pushVC(vcIdentifier: "QRCodeScannerVC")
            //回调函数js : scan_end(id,value)
            break
        default:
            if action.hasPrefix("up"){//上传图片
                self.uploadImage1(imageid: action)
            }
            break
        }
    }
    func dissolveTeam() {
        mylog("tttttttttttttttt")
        self.pushVC(vcIdentifier: "DDSetWithoutGroupVC", userInfo: nil )
    }
    func uploadImage1(imageid: String) {
       
        
    }
    
    func addWaterImage(_ waterImage : UIImage , in backgroundImage : UIImage) -> UIImage {
        let backgroundImage = backgroundImage.compressImageQuality(quality: 0.1)
        let img = backgroundImage.compressImageSize()
        let img2 = img.addWaterImage(waterImage)
        let img3 = img2.compressImageQuality(quality: 0.1)
        let img4 = img3.compressImageSize()
        return img4
    }
    
    
    
    //MARK:弹框
    func performAlertWith(dictParamete : [String:AnyObject]) {
        mylog("执行弹框操作")
    }
    //MARK:确认收货
    func performConfirmWith(dictParamete : [String:AnyObject]) {
        mylog("执行确认收货操作")
    }
    //MARK:跳转
    func performJumpWith(dictParamete : [String:AnyObject]) {
        guard   let typeOption = dictParamete["type"] else {
            mylog("跳转类型为空")
            return
        }
        guard let type = typeOption as? String else {
            return
        }
        let model = DDShowModel()
        model.isNeedJudge = true
        mylog("执行跳转 到 商品详情页")
        
        
    }
    //MARK:支付
    func performPayWith(dictParamete : [String:AnyObject]) {
        mylog("执行支付操作")
       
    }
    //MARK:分享
    func performShareWith(dictParamete : [String:AnyObject]) {
        mylog("执行分享操作")
    }
    //MARK:返回上一页
//    func popToPreviousVCXX (){
//        if self.webView.canGoBack  {
//            self.webView.goBack()
//        }else{
//            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
//            super.popToPreviousVC()  /*继承自internalVC时实现*/
//            //            self.smartGoBack()//继承自normalVC时实现
//        }
//    }
    func smartGoBack()  {
        self.webView.stopLoading()
        if (self.webView.canGoBack) {
            let count : Int = self.webView.backForwardList.backList.count
            for i in 0  ..< count {
                let   item :  WKBackForwardListItem = self.webView.backForwardList.backList[count - 1 - i]
                
                if (item.url.absoluteString.contains("nottaken")) {
                    if (i==count-1) {//如果栈底的还不需要在返回的时候显示,就直接pop到上一个控制器
                        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
                        _ =  self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    self.webView.go(to: item)
                    if (item.url.absoluteString.contains("orderlist")) {//待评价页面返回时需要重新加载
                        self.webView.reload()
                    }
                    break
                }
            }
        }else{
            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
            _ =  self.navigationController?.popViewController(animated: true)
            
        }
    }
    //MARK:返回上一页
    //继承自internalVC时实现
//    override func popToPreviousVC (){
//
//        self.webView.stopLoading()
//        if (self.webView.canGoBack) {
//            let count : Int = self.webView.backForwardList.backList.count
//            for i in 0  ..< count {
//                let   item :  WKBackForwardListItem = self.webView.backForwardList.backList[count - 1 - i]
//
//                if (item.url.absoluteString.contains("nottaken")) {
//                    if (i==count-1) {//如果栈底的还不需要在返回的时候显示,就直接pop到上一个控制器
//                        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
//                        _ =  self.navigationController?.popViewController(animated: true)
//                    }
//                }else{
//                    self.webView.go(to: item)
//                    if (item.url.absoluteString.contains("orderlist")) {//待评价页面返回时需要重新加载
//                        self.webView.reload()
//                    }
//                    break
//                }
//            }
//        }else{
//            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "ylcm")
//            _ =  self.navigationController?.popViewController(animated: true)
//
//        }
//    }
    
    
    /*
     -(void)navigationBack
     {
     
     NSLog(@"_%d_%@",__LINE__,self.webview.backForwardList.currentItem.URL.absoluteString );
     [self.webview stopLoading];
     if (self.webview.canGoBack) {
     NSUInteger count = self.webview.backForwardList.backList.count ;
     NSLog(@"_%d_%@,%lu",__LINE__,@"总个数",count);
     for (int i = 0 ; i < count; i++) {
     WKBackForwardListItem * item = self.webview.backForwardList.backList[count - 1 - i];
     NSLog(@"_%d_下标%d_%@",__LINE__,i,item.URL.absoluteString);
     if ([item.URL.absoluteString containsString:@"nottaken"]) {
     if (i==count-1) {//如果栈底的还不需要在返回的时候显示,就直接pop到上一个控制器
     
     [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"zjlao"];
     [self.navigationController popViewControllerAnimated:YES];
     
     }
     
     }else{
     [self.webview goToBackForwardListItem:item];
     if ([item.URL.absoluteString containsString:@"orderlist"]) {//待评价页面返回时需要重新加载
     [self.webview reload];
     }
     break ;
     }
     }
     
     }else{
     
     [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"zjlao"];
     [self.navigationController popViewControllerAnimated:YES];
     
     }
     }
     
     */
    
    //MARK:webViewDelegate
    
    //MARK:WKNavigationDelegate
    
    /*! @abstract Decides whether to allow or cancel a navigation.
     @param webView The web view invoking the delegate method.
     @param navigationAction Descriptive information about the action
     triggering the navigation request.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
     @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    /*! @abstract Decides whether to allow or cancel a navigation after its
     response is known.
     @param webView The web view invoking the delegate method.
     @param navigationResponse Descriptive information about the navigation
     response.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
     @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void){
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    
    /*! @abstract Invoked when a main frame navigation starts.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    
    /*! @abstract Invoked when a server redirect is received for the main
     frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    
    /*! @abstract Invoked when an error occurs while starting to load data for
     the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        
    }
    
    
    /*! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    
    
    /*! @abstract Invoked when a main frame navigation completes.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
//        self.title = webView.title
        webView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            webView.alpha = 1
        }
        mylog(webView.title)
    }
    
    
    /*! @abstract Invoked when an error occurs during a committed main frame
     navigation.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
//        self.title = webView.title
        mylog(webView.title)
    }
    
    
    /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
     @param webView The web view that received the authentication challenge.
     @param challenge The authentication challenge.
     @param completionHandler The completion handler you must invoke to respond to the challenge. The
     disposition argument is one of the constants of the enumerated type
     NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
     the credential argument is the credential to use, or nil to indicate continuing without a
     credential.
     @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling , nil )
    }
    
    
    /*! @abstract Invoked when the web view's web content process is terminated.
     @param webView The web view whose underlying web content process was terminated.
     @available(iOS 9.0, *)
     */
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        
    }
    
    //MARK: WKUIDelegate
    
    
    /*! @abstract Creates a new web view.
     @param webView The web view invoking the delegate method.
     @param configuration The configuration to use when creating the new web
     view.
     @param navigationAction The navigation action causing the new web view to
     be created.
     @param windowFeatures Window features requested by the webpage.
     @result A new web view or nil.
     @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
     
     If you do not implement this method, the web view will cancel the navigation.
     @available(iOS 8.0, *)
     */
    //     func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
    //        return nil
    //    }
    
    
    /*! @abstract Notifies your app that the DOM window object's close() method completed successfully.
     @param webView The web view invoking the delegate method.
     @discussion Your app should remove the web view from the view hierarchy and update
     the UI as needed, such as by closing the containing browser tab or window.
     @available(iOS 9.0, *)
     */
    func webViewDidClose(_ webView: WKWebView){
        
    }
    
    
    /*! @abstract Displays a JavaScript alert panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this
     call.
     @param completionHandler The completion handler to call after the alert
     panel has been dismissed.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have a single OK button.
     
     If you do not implement this method, the web view will behave as if the user selected the OK button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        completionHandler()
    }
    
    
    /*! @abstract Displays a JavaScript confirm panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the confirm
     panel has been dismissed. Pass YES if the user chose OK, NO if the user
     chose Cancel.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        completionHandler(true)
    }
    
    
    /*! @abstract Displays a JavaScript text input panel.
     @param webView The web view invoking the delegate method.
     @param message The message to display.
     @param defaultText The initial text to display in the text entry field.
     @param frame Information about the frame whose JavaScript initiated this call.
     @param completionHandler The completion handler to call after the text
     input panel has been dismissed. Pass the entered text if the user chose
     OK, otherwise nil.
     @discussion For user security, your app should call attention to the fact
     that a specific website controls the content in this panel. A simple forumla
     for identifying the controlling website is frame.request.URL.host.
     The panel should have two buttons, such as OK and Cancel, and a field in
     which to enter text.
     
     If you do not implement this method, the web view will behave as if the user selected the Cancel button.
     @available(iOS 8.0, *)
     */
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void){
        completionHandler("提交已经输入的文字,如果没有输入的话就传nil")
    }
    
    
    /*! @abstract Allows your app to determine whether or not the given element should show a preview.
     @param webView The web view invoking the delegate method.
     @param elementInfo The elementInfo for the element the user has started touching.
     @discussion To disable previews entirely for the given element, return NO. Returning NO will prevent
     webView:previewingViewControllerForElement:defaultActions: and webView:commitPreviewingViewController:
     from being invoked.
     
     This method will only be invoked for elements that have default preview in WebKit, which is
     limited to links. In the future, it could be invoked for additional elements.
     @available(iOS 10.0, *)
     */
    //    @available(iOS 10.0, *)
    //    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool{
    //        return true
    //    }
    
    
    /*! @abstract Allows your app to provide a custom view controller to show when the given element is peeked.
     @param webView The web view invoking the delegate method.
     @param elementInfo The elementInfo for the element the user is peeking.
     @param defaultActions An array of the actions that WebKit would use as previewActionItems for this element by
     default. These actions would be used if allowsLinkPreview is YES but these delegate methods have not been
     implemented, or if this delegate method returns nil.
     @discussion Returning a view controller will result in that view controller being displayed as a peek preview.
     To use the defaultActions, your app is responsible for returning whichever of those actions it wants in your
     view controller's implementation of -previewActionItems.
     
     Returning nil will result in WebKit's default preview behavior. webView:commitPreviewingViewController: will only be invoked
     if a non-nil view controller was returned.
     @available(iOS 10.0, *)
     */
    //    @available(iOS 10.0, *)
    //    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController?{
    //        return nil
    //    }
    
    
    /*! @abstract Allows your app to pop to the view controller it created.
     @param webView The web view invoking the delegate method.
     @param previewingViewController The view controller that is being popped.
     @available(iOS 10.0, *)
     */
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController){
        
    }
    
    
    
}
