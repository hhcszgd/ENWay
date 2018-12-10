//
//  DDShopVC.swift
//  Project
//
//  Created by WY on 2017/12/15.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
import Alamofire
class DDItem2VC: DDNormalVC , UITextFieldDelegate{
    enum ShowType:String {
        case multipleSelection
        case cancle
        case done
    }
    let noMsgNoticeLabel = UILabel()
//    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
//    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    
    var naviBarStartShowH : CGFloat =  DDDevice.isFullScreen ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.isFullScreen ? 100 : 80
    var pageNum : Int  = 1
    var currentKeyWord : String? = ""
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    let searchBox = UITextField.init()
    var multipleSelection : Bool = false
    var showType  = ShowType.multipleSelection
    var apiModel = ApiModel<[DDMessageModel]>(){
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
        
        self.view.addSubview(noMsgNoticeLabel)
        noMsgNoticeLabel.frame = CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: 44)
        noMsgNoticeLabel.textColor = UIColor.DDSubTitleColor
        self.switchNoMsgStatus(show: false)
        noMsgNoticeLabel.textAlignment = .center
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false 
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestApi(loadType: LoadDataType.reload)
    }
    func switchNoMsgStatus(show:Bool)  {
        if show {
            self.noMsgNoticeLabel.isHidden = false
        }else{
            self.noMsgNoticeLabel.isHidden = true
        }
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.configTableHeaderView()
        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        tableView.gdLoadControl?.loadHeight = 40
       requestApi(loadType: LoadDataType.initialize)
    }
    @objc func loadMore() {
        requestApi(loadType: LoadDataType.loadMore)
    }
    func requestApi(loadType : LoadDataType )  {
        if loadType == .loadMore {
            pageNum += 1
        }else if loadType == .initialize{
            pageNum = 1
            noMsgNoticeLabel.text = "您还没有消息"
        }else{
            noMsgNoticeLabel.text = "找不到相关消息"
            pageNum = 1
        }
        DDRequestManager.share.messagePage(keyword:self.currentKeyWord,page:pageNum,true )?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            switch response.result {
            case .failure :
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.failure)
                return 
            default:
                break
            }
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[DDMessageModel]>.self , from: response){
                if loadType == .loadMore {
                    if (apiModel.data?.count ?? 0) > 0{
                        self.apiModel.data?.append(contentsOf: apiModel.data!)
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                        self.switchNoMsgStatus(show: false)
                    }else{
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                    }
                }
//                else if loadType == .initialize{
//                    if (apiModel.data?.count ?? 0) > 0{
//                        self.switchNoMsgStatus(show: false)
//                    }else{
//                        self.switchNoMsgStatus(show: true)
//                    }
//                    self.apiModel = apiModel
//                }
                else{
                    self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
//                    self.tableView.gdLoadControl?.showStatus = .idle
                    if (apiModel.data?.count ?? 0) > 0{
                        self.switchNoMsgStatus(show: false)
                    }else{
                        self.switchNoMsgStatus(show: true)
                    }
                    self.apiModel = apiModel
                    
                }
                
                self.tableView.reloadData()
            }
        })
    }
    func configNaviBar() {
        self.title = "video"
//        self.navigationController?.title = nil 
    }
    
    
    //textfieldDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.title = "消息搜索"
        self.navigationController?.title = "消息"
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        self.title = "消息"
        self.navigationController?.title =  "消息"
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.currentKeyWord = self.searchBox.text ?? ""
        self.requestApi(loadType: LoadDataType.reload)
        self.tableView.reloadData()
        self.searchBox.resignFirstResponder()
        return true
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
//        return true
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 && textField.text?.count == 1 {
            self.currentKeyWord = nil
            self.requestApi(loadType: LoadDataType.reload)
        }
        return true
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.tableView.reloadData()
//        return true
//    }
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
    
    func configTableHeaderView() -> UIView{
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width , height: 64 * SCALE))
        let searchBoxEdgeInset = UIEdgeInsets(top: 15 * SCALE, left: 10, bottom: 15 * SCALE, right: 10)
        searchBox.delegate =  self //UITextFieldDelegate
        searchBox.returnKeyType = .search
        tableHeader.addSubview(searchBox)
        searchBox.frame = CGRect(x: searchBoxEdgeInset.left, y: searchBoxEdgeInset.top, width: UIScreen.main.bounds.width - searchBoxEdgeInset.left - searchBoxEdgeInset.right, height: tableHeader.bounds.height - searchBoxEdgeInset.top - searchBoxEdgeInset.bottom)
        
        tableHeader.backgroundColor = UIColor.colorWithHexStringSwift("#eeeeee")
        searchBox.backgroundColor = UIColor.white
        searchBox.borderStyle = UITextField.BorderStyle.roundedRect
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        rightView.setImage(UIImage(named: "search"), for: UIControl.State.normal)
        rightView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "请输入消息关键词搜索"
        return tableHeader
    }
}

extension DDItem2VC : UITableViewDelegate , UITableViewDataSource {
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 9
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let titles =  ["a"  , "b" , "c" , "d" , "e" , "f" , "g" , "h" , "i"]
//        let label = UILabel()
//        label.text = "  " +  titles[section]
//        label.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
//        return label
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.apiModel.data?[indexPath.row]{
//            if model.message_type == "1"{//公告
//                let vc = AnnouncementVC()
//                vc.showModel = model
//                self.navigationController?.pushViewController(vc , animated: true )
//            }else if model.message_type == "2"{//系统消息
//
//                let vc = DDSystemMsgVC()
//                vc.showModel = model
//                self.navigationController?.pushViewController(vc , animated: true )
//            }
            toWebView(messageID: model.id)
            
        }
        
        requestApi(loadType: LoadDataType.initialize)
    }
    
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "message/\(messageID)"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.searchBox.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.apiModel.data?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDMessageCell") as? DDMessageCell{
            cell.model = model
            cell.keyWorld = self.searchBox.text
            return cell
        }else{
            
            let cell = DDMessageCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDMessageCell")
            cell.keyWorld = self.searchBox.text
            cell.model = model
            return cell
        }
    }
}
import SDWebImage
extension DDItem2VC{
    class DDMessageCell : UITableViewCell {
        let icon  = UIImageView()
        let title = UILabel()
        let subTitle = UILabel()
        let time = UILabel()
        let messageStatus = UIView()
        var model : DDMessageModel? {
            didSet{
                
//                title.text = model?.id
                if let messageType = model?.message_type , messageType == "1"{
                    icon.image = UIImage(named:"bulletinicons")
                    title.text = "公告"
                }else{
                    icon.image = UIImage(named:"systemmessageicon")
                    title.text = "系统消息"
                }
                if let messageStatus  = model?.status , messageStatus == "1" {
                    self.messageStatus.isHidden = true
                }else{self.messageStatus.isHidden = false}
                subTitle.text = model?.title
                time.text = model?.create_at
            }
        }
        var keyWorld : String? = ""{
            didSet{
                
                if let title = model?.title, let keyWorkUnwrap = keyWorld{
                    let attributeStr = title.setColor(color: UIColor.red, keyWord: keyWorkUnwrap)
                    subTitle.attributedText = attributeStr
                }else{
//                    subTitle.attributedText = nil
//                    subTitle.text = model?.title
                }

            }
        }
        
        let bottomLine = UIView()
//        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//            <#code#>
//        }
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.contentView.addSubview(icon)
            self.contentView.addSubview(messageStatus)
            self.contentView.addSubview(title)
            self.contentView.addSubview(subTitle)
            self.contentView.addSubview(bottomLine)
            self.contentView.addSubview(time)
            time.textColor = UIColor.DDTitleColor
            messageStatus.backgroundColor = .red
            title.textColor = UIColor.DDTitleColor
            title.font = GDFont.systemFont(ofSize: 17)
            bottomLine.backgroundColor = UIColor.DDLightGray
            //        icon.image = UIImage(named: "groupchatbackground")
//            icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
            title.text = "姓名"
            self.messageStatus.isHidden = true
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let bottomLineH : CGFloat = 2
            let iconTopMargin : CGFloat = 20
            let iconWH = self.bounds.height - iconTopMargin * 2 - bottomLineH
            icon.frame = CGRect(x: margin , y: iconTopMargin , width:iconWH, height:iconWH )
            title.ddSizeToFit()
            title.frame = CGRect(x: icon.frame.maxX + margin, y: margin , width: self.frame.width - margin - icon.frame.maxX - margin , height: title.font.lineHeight)
            subTitle.frame = CGRect(x: icon.frame.maxX + margin, y: self.bounds.height - margin - subTitle.font.lineHeight , width: self.frame.width - margin - icon.frame.maxX - margin , height: subTitle.font.lineHeight)
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
            let messageStatusWH : CGFloat = 10
            messageStatus.frame = CGRect(x: icon.frame.maxX - messageStatusWH/2 , y: icon.frame.minY, width: messageStatusWH, height: messageStatusWH)
            messageStatus.layer.cornerRadius = messageStatusWH/2
            messageStatus.layer.masksToBounds = true
            time.sizeToFit()
            time.frame = CGRect(x: self.bounds.width - time.bounds.width - 15, y: title.frame.minY, width: time.bounds.width, height: time.bounds.height)
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}
