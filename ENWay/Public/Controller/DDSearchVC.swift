//
//  DDSearchVC.swift
//  Project
//
//  Created by WY on 2017/11/7.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSearchVC: DDNormalVC {
    var apiModel : DDHotSearchApiModel = DDHotSearchApiModel()
    let searchBox = UITextField.init()
    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: DDSearchLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.configCollectionView()
//        self.testapi()
        // Do any additional setup after loading the view.
    }
//    func testapi() {
//        DDRequestManager.share.hotSearch(true)?.responseJSON(completionHandler: { (response ) in
//            let decoder = JSONDecoder.init()
//
//            if let model  = try? decoder.decode(DDHotSearchApiModel.self , from: response.data ?? Data()){
//                self.apiModel = model
//                self.collectionView.reloadData()
//            }
////            mylog(mode)
////            mylog(mode?.data)
////            mylog(String(data: self.getJson() ?? Data(), encoding: String.Encoding.utf8)?.unicodeStr)
//        })
//    }

    func configNavigationBar()  {
        self.navigationItem.titleView = searchBox
        searchBox.delegate = self
        searchBox.returnKeyType = UIReturnKeyType.search
        searchBox.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 44 * 2, height: 30)
//        searchBox.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
//        searchBox.borderStyle = UITextBorderStyle.none // UITextBorderStyle.roundedRect
        searchBox.borderStyle =  UITextField.BorderStyle.roundedRect
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        let img = UIImage(named: "search")
        img?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        rightView.setImage(img, for: UIControl.State.normal)
        rightView.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1)
//        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "热销"
        let searchButton =  UIBarButtonItem.init(title: "搜索", style: UIBarButtonItem.Style.plain, target: self, action: #selector(search))
        searchButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        searchButton.setTitlePositionAdjustment(UIOffset.init(horizontal: 9, vertical: 0), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    func configCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = self.view.bounds
        collectionView.register(DDSearchItem.self, forCellWithReuseIdentifier: "DDSearchItem")
        collectionView.register(DDSearchSessionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DDSearchCollectionHeader")
        collectionView.register(DDSearchSessionFooter.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DDSearchCollectionFooter")
        if let searchLayout = collectionView.collectionViewLayout as? DDSearchLayout {
            searchLayout.delegate = self
        }
        
//        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)//not work
    }
    @objc func search()  {
        self.searchBox.resignFirstResponder()
        var keyWord = ""
        if let tempKeyWord =  self.searchBox.text, !tempKeyWord.isEmpty{keyWord = tempKeyWord}else{
            if let placeHolderWork =  self.searchBox.placeholder , !placeHolderWork.isEmpty{keyWord = placeHolderWork}else{return}
        }
        self.performSearch(keyWord:keyWord)
    }
    func performSearch(keyWord:String ){
        mylog("perform search : \(keyWord)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBox.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        testapi()
    }
}


extension DDSearchVC : DDSearchSessionHeaderDelegate , UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        mylog("press return key")
        self.search()
        return true
    }
    func performAction(){
        let vc =  UIAlertController.init(title: "删除全部历史记录", message: nil, preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.default) { (action ) in
            
        }
        let action2 = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.default) { (ation ) in
            
        }
        vc.addAction(action2)
        vc.addAction(action1)
        self.present(vc , animated: true) {
            
        }
        mylog("perform action")
    }
}
extension DDSearchVC : DDSearchLayoutProtocol{
    func provideItemHeight(layout:DDSearchLayout?) -> CGFloat{//定值
    return 30.0
    }
    func provideItemWidth(layout: DDSearchLayout? ,indexPath:IndexPath) -> CGFloat{//变值
//        return ((collectionView.bounds.width - 40.000000001 ) / 3)
//        let str = datas[indexPath.section][indexPath.item]
        var str  = ""
        if indexPath.section == 0 {
            str =  apiModel.data!.hotSearch![indexPath.item].keyword
        }else if indexPath.section == 1{
            str =  apiModel.data!.searchLog![indexPath.item].keyword
        }
        let label = UILabel()
        label.text = str
        label.sizeToFit()
        return (label.bounds.width  + 10)
        
    }
    func provideColumnMargin(layout:DDSearchLayout?) -> CGFloat{
        return 10
    }
    func provideRowMargin(layout:DDSearchLayout?) -> CGFloat{
        return 10
    }
    func provideEdgeInsets(layout:DDSearchLayout?) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func provideSessionHeaderHeight(layout:DDSearchLayout?) -> CGFloat{//定值
        return 30
    }
//    func provideSessionFooterHeight(layout:DDSearchLayout?) -> CGFloat{//定值
//        return 44
//    }
    
}
extension DDSearchVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchBox.resignFirstResponder()
//        let keyWord = datas[indexPath.section][indexPath.item]
        var keyWord : String = ""
        if indexPath.section == 0 {
            keyWord = apiModel.data?.hotSearch?[indexPath.item].keyword ?? ""
            
        }else if indexPath.section == 1{
            keyWord = apiModel.data?.searchLog?[indexPath.item].keyword ?? ""
        }
        self.performSearch(keyWord:keyWord)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if apiModel.data?.hotSearch != nil && section == 0  {
            return apiModel.data!.hotSearch!.count
        }else if apiModel.data?.searchLog != nil  && section == 1{
            return apiModel.data!.searchLog!.count
        }
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "DDSearchItem", for: indexPath)
        if let realItem = item as? DDSearchItem {
            if apiModel.data?.hotSearch != nil && indexPath.section == 0  {
                realItem.title = apiModel.data!.hotSearch![indexPath.item].keyword
            }else if apiModel.data?.searchLog != nil  && indexPath.section == 1{
                realItem.title = apiModel.data!.searchLog![indexPath.item].keyword
            }
//            realItem.title = datas[indexPath.section][indexPath.item]
            return realItem
        }
        return item
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        if apiModel.data?.hotSearch != nil && apiModel.data?.searchLog != nil  {
            return 2
        }else if apiModel.data?.hotSearch != nil {
            return 1
        }
        return 0
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBox.resignFirstResponder()
    }
    // The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DDSearchCollectionHeader", for: indexPath)
            if let realheader = header as? DDSearchSessionHeader{
                
                if indexPath.section == 0 {
                    realheader.label.text = "热门搜索"
                    realheader.button.isHidden = true
                    realheader.button.setImage(nil , for: UIControl.State.normal)
                }else{
                    realheader.delegate = self
                    realheader.label.text = "历史记录"
                    realheader.button.isHidden = false
                    realheader.button.setImage(UIImage(named:"del_icon"), for: UIControl.State.normal)
                }
            }
            return header
        }else{
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DDSearchCollectionFooter", for: indexPath)
        }
    }

}

class DDSearchItem: UICollectionViewCell {
    let titleLabel  = UILabel()
    
    var title :  String = "000"{
        didSet{
            self.titleLabel.text = title
            self.layoutIfNeeded()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.setupSubviews()
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    func setupSubviews()  {
        self.contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.textAlignment = NSTextAlignment.center
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = self.contentView.bounds
        self.layer.cornerRadius = self.bounds.height * 0.1
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
protocol DDSearchSessionHeaderDelegate : NSObjectProtocol {
    func performAction()
}
class DDSearchSessionHeader: DDCollectionReusableView {
    let label = UILabel()
    let button = UIButton()
    weak var delegate : DDSearchSessionHeaderDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(label)
        
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.11)
//        label.text = "主标题"
        label.font = GDFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        self.addSubview(button)
        button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)
        self.button.isHidden = true
//        button.setImage(UIImage(named:"search"), for: UIControl.State.normal)
    }
    @objc func buttonClick(sender:UIButton){
        self.delegate?.performAction()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 20, y: 0, width: 150, height: self.bounds.height)
        let buttonWH : CGFloat = self.bounds.height * 0.89
        button.frame = CGRect(x: self.bounds.width - (10 + buttonWH), y:(self.bounds.height - buttonWH) / 2, width: buttonWH, height: buttonWH)
        
//        func showSubviews(isShow:Bool){
//            for (_ , subview ) in self.subviews.enumerated(){
//                subview.isHidden = !isShow
//            }
//        }
//        if self.bounds.height <= 0  {
//            showSubviews(isShow: false)
//        }else{
//            showSubviews(isShow: true)
//        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DDSearchSessionFooter: DDCollectionReusableView {
    let label1 = UILabel()
    let label2 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(label1)
        self.backgroundColor = UIColor.blue
        label1.text = "主标题"
        label1.font = GDFont.systemFont(ofSize: 14)
        label1.textColor = UIColor.lightGray
        self.addSubview(label2)
        label2.textColor = UIColor.gray
        label2.text = "副标题"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label1.frame = CGRect(x: 20, y: 0, width: 150, height: 44)
        label2.frame = CGRect(x: 150, y: 0, width: 150, height: 44)
        
//        func showSubviews(isShow:Bool){
//            for (_ , subview ) in self.subviews.enumerated(){
//                subview.isHidden = !isShow
//            }
//        }
//        if self.bounds.height <= 0  {
//            showSubviews(isShow: false)
//        }else{
//            showSubviews(isShow: true)
//        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class ActionModel: NSObject , DDShowProtocol,Codable {
//    var isNeedJudge: Bool = false
//    var actionKey: String = ""
//    var keyParameter: Any?
//}
//protocol ApiDataProtocol {
//    var data :  [String:Array<DActionModel>]?{get set }
//}
class APIModel : NSObject , Codable {
    var status : Int = -1
    var message : String = ""
//    enum CodingKeys: String, CodingKey {
//        case status
//        case message
//        // or: case hobbies = "customHobbiesKey" if you want to encode to a different key
//    }
//    required init(from decoder: Decoder)throws{
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        status = try values.decode(Int.self, forKey: .status)
//        message = try values.decode(String.self, forKey: .message)
//    }
//    func encode(to encoder: Encoder) throws {
//        do {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(status, forKey: .status)
//            try container.encode(message, forKey: .message)
//        } catch {
//            print(error)
//        }
//    }
}

class DDHotSearchApiModel:NSObject , Codable {
    var status : Int = -1
    var message : String = ""
    var data: DDHotSearchApiDataModel?
}
class DDHotSearchApiDataModel : NSObject ,Codable{
    var hotSearch :  [SearchPageItemModel]?
    var searchLog : [SearchPageItemModel]?
}
class SearchPageItemModel: Codable {
    var id : Int = 0
    var keyword : String = ""
}
//class DActionModel: NSObject , DDShowProtocol , Codable{
//    var isNeedJudge: Bool = false
//    var actionKey: String = ""
//    var keyParameter: Any?
//
//    enum CodingKeys: String, CodingKey {
//        case isNeedJudge
//        case actionKey
//        case keyParameter
//        // or: case hobbies = "customHobbiesKey" if you want to encode to a different key
//    }
//    required init(from decoder: Decoder)throws{
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        isNeedJudge = try values.decode(Bool.self, forKey: .isNeedJudge)
//        actionKey = try values.decode(String.self, forKey: .actionKey)
//        keyParameter = try values.decode(Any?.self, forKey: .keyParameter)
//
//    }
//    func encode(to encoder: Encoder) throws {
//        do {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(isNeedJudge, forKey: .isNeedJudge)
//            try container.encode(actionKey, forKey: .actionKey)
//            try container.encode(keyParameter, forKey: .keyParameter)
//        } catch {
//            print(error)
//        }
//    }
//
//}
