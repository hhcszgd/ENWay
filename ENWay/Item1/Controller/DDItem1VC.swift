//
//  DDItem1VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import CryptoSwift
import CoreLocation
class DDItem1VC: DDNormalVC , UITextFieldDelegate{
    var collection : UICollectionView!
    let sectionHeaderH : CGFloat = 280 * SCALE
//    override var title: String?{
//        set{super.title = title}
//        get{return super.title}
//    }
//    var apiModel = DDHomeApiModel()
    var apiModel = ApiModel<HomeDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DDLocationManager.share.startUpdatingLocation()
//        todoSomethingAfterCheckVersion()
        AppVersionUpdater.appVersionAlertTips()
        configCollectionView()
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        performRequestApi()
        
        self.title = "工作"
//        self.navigationController?.title = nil
        let name = NSNotification.Name.init("ChangeSquenceSuccess")
        NotificationCenter.default.addObserver(self , selector: #selector(changeSquenceSuccess), name: name , object: nil )
        let teamChangedNotificationName = NSNotification.Name.init("DDTeamChanged")
         NotificationCenter.default.addObserver(self , selector: #selector(teamChanged), name: teamChangedNotificationName , object: nil )
        let refreshControl = GDRefreshControl.init(target: self , selector: #selector(refresh))
        let images = [UIImage.init(named: "loading1.png")!, UIImage.init(named: "loading2.png")!, UIImage.init(named: "loading3.png")!, UIImage.init(named: "loading4.png")!, UIImage.init(named: "loading5.png")!]
//        refreshControl.refreshingImages = images
//        refreshControl.pullingImages = images
//        refreshControl.successImage = UIImage.init(named: "loading1.png")!
//        refreshControl.failureImage = UIImage.init(named: "loading2.png")!
//        refreshControl.refreshingImages = [UIImage.init()]
        refreshControl.refreshHeight = 40
        self.collection.gdRefreshControl = refreshControl
  
        
    }
    @objc func teamChanged()  {
        self.performRequestApi { (isSuccess) in
            if isSuccess{
                self.gotoSign(animated: false)
                let vcCount = self.navigationController?.viewControllers.count ?? 0
                if vcCount >= 3 {
                    let targetIndex = vcCount - 2
                    if let _ = self.navigationController?.viewControllers[targetIndex]{
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.59) {
                            self.navigationController?.viewControllers.remove(at: targetIndex)
                        }
                        
                    }
                }
            }else{
                GDAlertView.alert("网络错误,请重试", image: nil, time: 2 , complateBlock: nil)
            }
        }
       
    }
    @objc func refresh() {
        self.performRequestApi()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.performRequestApi()
    }
    
    @objc func changeSquenceSuccess() {
        performRequestApi()
    }
    func performRequestApi(complated:((Bool)->())? = nil )  {
        DDRequestManager.share.homePage( true)?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<HomeDataModel>.self, from: response){
                self.apiModel = apiModel
                self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
                self.collection.reloadData()
                complated?(true)
                
            }else{
                complated?(false)
                self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
            }
        })
    }
    
    func configCollectionView()  {
        let toBorderMargin :CGFloat  = 10
        let itemMargin  : CGFloat = 15
        let itemCountOneRow = 4
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: toBorderMargin, bottom: 0, right: toBorderMargin)
        let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
        let itemH = itemW * 1.33
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  DDNavigationBarHeight , width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.register(HomeItem.self , forCellWithReuseIdentifier: "HomeItem")
        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false 
        collection.backgroundColor = .white
        mylog(self.view.bounds.height)
        
    }

}



extension DDItem1VC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
        var targetVC : UIViewController!
        let model = apiModel.data?.function[indexPath.item]
        let target = model?.target ?? ""
        switch target {
        case "guanggao":
            self.pushVC(vcIdentifier: "DDSalemanmoOrderListVC")
            return
        default:
            return
        }
    }
    
    
    
    
    func gotoSign(animated:Bool = true ) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch DDLocationManager.share.authorizationStatus() {
            case CLAuthorizationStatus.authorizedAlways:
                mylog("现在是前后台定位服务")
            case CLAuthorizationStatus.authorizedWhenInUse:
                mylog("现在是前台定位服务")
            case CLAuthorizationStatus.denied:
                openLoactionService()
                mylog("现在是用户拒绝使用定位服务")
            case CLAuthorizationStatus.notDetermined:
                openLoactionService()
                mylog("用户暂未选择定位服务选项")
            case CLAuthorizationStatus.restricted:
                openLoactionService()
                mylog("现在是用户可能拒绝使用定位服务")
            }
        }else{
            mylog("请开启手机的定位服务")
            let sure = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            }
            self.alert(title: "定位功能不可用", detailTitle: "请前往(设置->隐私->定位服务)开启手机定位功能", style: UIAlertController.Style.alert, actions: [sure ])
        }
      
    }
    func openLoactionService() {
        let sure = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            self.openSetting()
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.default) { (action) in
        }
        self.alert(title: "暂无定位服务权限,是否授权?", detailTitle: nil, style: UIAlertController.Style.alert, actions: [sure , cancel ])
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionView.elementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader", for: indexPath) as? HomeSectionHeader{
//                header.backgroundColor = UIColor.randomColor()
                header.bannerActionDelegate = self
                header.msgActionDelegate = self
                if let model = self.apiModel.data?.notice{
                    header.msgModels =    model
                }
                if let model = self.apiModel.data?.banner{
                    header.bannerModels = model
                }
                header.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: sectionHeaderH)
                return header
                
            }
        }else if kind == UICollectionView.elementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter", for: indexPath)
            footer.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 0)
            return footer
        }
        return UICollectionReusableView.init()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.function.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItem", for: indexPath)
        if let itemUnwrap = item as? HomeItem , let model = self.apiModel.data?.function[indexPath.item]{
            itemUnwrap.model = model
        }
//        item.backgroundColor = UIColor.randomColor()
        return item
    }

}
extension DDItem1VC : BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
        if let data = self.apiModel.data{
            let msgModel = data.notice[indexPath.item % data.notice.count]
            toWebView(messageID: msgModel.id)
            mylog(indexPath)
            
        }
    }
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)?type=notice")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "message/\(messageID)?type=notice"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
   
    func moreBtnClick() {
        mylog("to message page ")
    }
    
    func performBannerAction(indexPath : IndexPath) {
        
        if let data = self.apiModel.data{
            let model = data.banner[indexPath.item % data.banner.count]
            if model.target ?? "" == "share"{
                self.pushVC(vcIdentifier: "DDShareToWeiChatWebVC", userInfo: model.link_url)
            }else{
                self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model.link_url)
            }
        }

//        mylog(indexPath)
//        model.keyParameter = model.link_url
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    
    
}
import SDWebImage
class HomeItem : UICollectionViewCell {
    var model : DDHomeFoundation = DDHomeFoundation(){
        didSet{
            if let url  = URL(string:model.image_url) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
            label.text = model.name
        }
    }
    
    
    let imageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView )
        self.contentView.addSubview(label )
        label.text = "exemple"
        label.textAlignment = .center
        label.textColor = UIColor.DDSubTitleColor
        label.font = GDFont.systemFont(ofSize: 13.4)
        label.adjustsFontSizeToFitWidth = true 
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0 , y : 0 , width : self.bounds.width , height : self.bounds.width)
        label.frame = CGRect(x:0  , y : imageView.frame.maxY , width : self.bounds.width , height : self.bounds.height - self.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HomeSectionHeader: UICollectionReusableView ,BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
        self.msgActionDelegate?.performMsgAction(indexPath: indexPath)
    }
    func moreBtnClick() {
        self.msgActionDelegate?.moreBtnClick()
    }
    
    func performBannerAction(indexPath : IndexPath) {
        self.bannerActionDelegate?.performBannerAction(indexPath: indexPath)
    }
    
    var msgModels : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            message.models = msgModels
        }
    }
    var bannerModels : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            banner.models = bannerModels
        }
    }
    weak var bannerActionDelegate : BannerAutoScrollViewActionDelegate?
    
    weak var msgActionDelegate : DDMsgScrollViewActionDelegate?
    let banner = HomeBannerScrollView.init(frame: CGRect.zero)
    let message : HomeMessageScrollView = HomeMessageScrollView.init(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(message)
        self.addSubview(banner)
        banner.delegate = self
        message.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 0
        message.frame = CGRect(x:toBorder , y : self.bounds.height - 44 , width : self.bounds.width - toBorder * 2 , height : 44 )
        banner.frame = CGRect(x:0 , y : 0 , width : self.bounds.width  , height : self.bounds.height - 44 )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomeBannerScrollView : UIView , BannerAutoScrollViewActionDelegate{
    func performBannerAction(indexPath : IndexPath) {
        self.delegate?.performBannerAction(indexPath: indexPath)
    }
    
    var models : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            self.banner.models = models
        }
    }
    let banner = DDLeftRightAutoScroll.init(frame: CGRect.zero)
    weak var delegate : BannerAutoScrollViewActionDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(banner)
        banner.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        banner.frame = CGRect(x:0  , y: 0  , width : self.bounds.width , height : self.bounds.height)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DDMsgScrollViewActionDelegate : NSObjectProtocol{
    func performMsgAction(indexPath : IndexPath)
    func moreBtnClick()
}
class HomeMessageScrollView : UIView , DDUpDownAutoScrollDelegate{
    var models : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            self.messageScrollView.models = models
        }
    }
    let messageScrollView : DDUpDownAutoScroll = DDUpDownAutoScroll.init(frame: CGRect.zero)
    weak var delegate : DDMsgScrollViewActionDelegate?
    let  leftBtn = UIButton()
    let  rightBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(messageScrollView)
        messageScrollView.delegate = self
//        leftBtn.setTitle("logo", for: UIControl.State.normal)
        leftBtn.setImage(UIImage(named:"notificationicon"), for: UIControl.State.normal)
        rightBtn.setTitle("更多", for: UIControl.State.normal)
        rightBtn.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        leftBtn.setTitleColor(UIColor.DDTitleColor, for: UIControl.State.normal)
//        rightBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControl.State.normal)
        rightBtn.addTarget(self , action: #selector(moreBtnClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        rightBtn.frame = CGRect(x:self.bounds.width - self.bounds.height  , y: self.bounds.height/5  , width : self.bounds.height , height : self.bounds.height/2.5)
        rightBtn.ddSizeToFit()
        rightBtn.bounds = CGRect(x: 0, y: 0, width: rightBtn.bounds.width + 8, height: (rightBtn.titleLabel?.font.lineHeight ?? 13 ) + 3)
        rightBtn.center = CGPoint(x: self.bounds.width - rightBtn.bounds.width/2 - 10 , y: self.bounds.height/2)
        rightBtn.layer.cornerRadius = rightBtn.bounds.height/2
        rightBtn.layer.masksToBounds = true
        rightBtn.backgroundColor = .orange
        leftBtn.frame = CGRect(x:0  , y: 0  , width : self.bounds.height , height : self.bounds.height)
        messageScrollView.frame = CGRect(x: leftBtn.frame.maxX    , y: 0 , width : rightBtn.frame.minX - leftBtn.frame.maxX , height : self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func performMsgAction(indexPath : IndexPath){
        self.delegate?.performMsgAction(indexPath: indexPath)
    }
    @objc func moreBtnClick(sender:UIButton)  {
        self.delegate?.moreBtnClick()
    }

    
}

class HomeSectionFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDItem1VC{
    /*
    func todoSomethingAfterCheckVersion() {
        checkAppVersion { (result , description) in
            
            if let result = result{
                var actions = [DDAlertAction]()
                
                let sure = DDAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
                    print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
                    let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
                    if let url = URL(string: urlStr){
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url )
                        }
                    }
                })
                actions.append(sure)
                if result{
                    print("force update")
                    sure.isAutomaticDisappear = false
                }else{
                    let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
                         print("cancel update")
                    })
                    actions.append(cancel)
                }
                let alertView = DDAlertOrSheet(title: "新版本提示", message: description , preferredStyle: UIAlertController.Style.alert, actions: actions)
                alertView.isHideWhenWhitespaceClick = false 
                UIApplication.shared.keyWindow?.alert(alertView)
            }else{
                print("无最新版本")
            }
        }
            
            
            
            
//            print(result)
//            var actions = [UIAlertAction]()
//            let sure = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
//                print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
//               let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
//                    if let url = URL(string: urlStr){
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.openURL(url )
//                    }
//                }
//            })
//
//            actions.append(sure)
//
//            if let result = result{
//                if result{
//                    print("force update")
//                }else{
//                    let cancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
//                        print("cancel update")
//                    })
//                        actions.append(cancel)
//                }
//                self.alert(title: description ?? "提示", detailTitle: nil , actions: actions)
//            }
//        }
    }
    

    /// checkAppVersion
    ///
    /// - Parameter callBack: callBack block's parameter equal nil means need't update , false means optional update , true means force update
    /// - Parameter description : alert Message
    func checkAppVersion(callBack:@escaping (Bool?,String?) -> Void) {
        DDRequestManager.share.checkLatestAppVersion()?.responseJSON(completionHandler: { (response) in
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<CheckAppVersionResultModel>.self, from: response){
                print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
                dump(apiModel)
                let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                if  apiModel.data?.version ?? "" > currentAppVersion{ // 有新版本了
                    if apiModel.data?.upgrade_type ?? "" == "1"{//强制更新
                        callBack(true , apiModel.data?.desc)
                    }else{//非强制更新
                        callBack(false,apiModel.data?.desc)
                    }
                }else{//无新版本
                    callBack(nil,apiModel.data?.desc)
                }
                
            }
        })
    }
    */
  
    
    func noAuthorizedAlertWhileBandCard() {
        
    }
    func noAuthorizedAlertWhileGetCash() {
      
    }

    
}

struct PublickKeyModel : Codable {
    var public_key : String
}

struct CheckAppVersionResultModel  :  Codable{
    var upgrade_type : String
    var version : String
    var url  : String
    var desc : String
}

class AppVersionUpdater {
    static var alertTimes = 0
    static func checkAppVersion(callBack:@escaping (Bool?,String?) -> Void) {
//        DDRequestManager.share.checkLatestAppVersion()?.responseJSON(completionHandler: { (response) in
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<CheckAppVersionResultModel>.self, from: response){
//                print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
//                dump(apiModel)
//                let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
//                if  apiModel.data?.version ?? "" > currentAppVersion{ // 有新版本了
//                    if apiModel.data?.upgrade_type ?? "" == "1"{//强制更新
//                        callBack(true , apiModel.data?.desc)
//                    }else{//非强制更新
//                        callBack(false,apiModel.data?.desc)
//                    }
//                }else{//无新版本
//                    callBack(nil,apiModel.data?.desc)
//                }
//
//            }
//        })
    }
    
    static func appVersionAlertTips() {
        if let window = UIApplication.shared.keyWindow {
            for subview in window.subviews {
                if subview.isKind(of: DDAlertOrSheet.self){
                    return
                }
            }
        }
        
        checkAppVersion { (result , description) in
            
            if let result = result{
                var actions = [DDAlertAction]()
                
                let sure = DDAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action ) in
                    print("go to app store")// 需要自定义alert , 点击之后 , 弹框继续存在
                    let urlStr =  "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8"
                    if let url = URL(string: urlStr){
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url )
                        }
                    }
                })
                actions.append(sure)
                if result{
                    print("force update")
                    sure.isAutomaticDisappear = false
                    
                }else{
                    if self.alertTimes >= 1 {return}
                    let cancel = DDAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action ) in
                        print("cancel update")
                    })
                    actions.append(cancel)
                }
                let alertView = DDAlertOrSheet(title: "新版本提示", message: description , preferredStyle: UIAlertController.Style.alert, actions: actions)
                alertView.isHideWhenWhitespaceClick = false
                UIApplication.shared.keyWindow?.alert(alertView)
                self.alertTimes += 1
            }else{
                print("无最新版本")
            }
        }
    }
    
}
