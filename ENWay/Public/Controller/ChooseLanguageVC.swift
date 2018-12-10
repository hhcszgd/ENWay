//
//  ChooseLanguageVC.swift
//  zjlao
//
//  Created by WY on 16/10/19.
//  Copyright © 2016年 WY. All rights reserved.
/*进来时  确定按钮不可用 , 只有选择非当前语言后 确定按钮才可用**/

import UIKit


//import GDRefreshControl
class ChooseLanguageVC: DDNormalVC,UITableViewDelegate ,  UITableViewDataSource {
//    let languages : [String] = [/*LFollowSystemLanguage,*/LEnglish,LChinese]
    let languages : [(String,String)] = [
        /*(LFollowSystemLanguage,"跟随系统"),*/
        (LEnglish,"English"),
        (LChinese,"简体中文"),
        (LJapanese,"日本語"),
        (LTraditionsal,"繁体中文"),
        (LVietnamese,"Tiếng Việt"),
        (LThai,"ภาษาไทย"),
        (LKorean,"한국어"),
        (LMalay,"Melayu"),
        (LRussian,"русский ")
    ]
    /*
     let LJapanese = "Japanese"
     let LTraditionsal = "Traditional"
     let LVietnamese = "Vietnamese"
     let LThai = "Thai"
     */
//    let bottomButton = UIButton()
//    var  currentLanguageIndexPath = IndexPath(row: 111, section: 0)
//    var  selectedLanguageIndexPath = IndexPath(row: 1111, section: 0)
    
//    var choosedIndexPaths = [String : IndexPath]()
    
    var selectedLanguage : String = ""
    lazy var tableView : UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)//
        self.view.addSubview(temp)
        temp.dataSource = self
        temp.delegate = self
        temp.frame = self.view.bounds
        temp.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return temp
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择语言"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.automaticallyAdjustsScrollViewInsets = false
//        self.view.addSubview(bottomButton)
        self.gdSetupContentAndFrame()
        self.navigationController?.navigationBar.isHidden = false
    }

     func gdSetupContentAndFrame(){
        let margin : CGFloat = 20.0
        
        let btnW : CGFloat = SCREENWIDTH - margin * 2
        let btnH : CGFloat = 44
        let btnX : CGFloat = margin
        let btnY : CGFloat = SCREENHEIGHT - margin - btnH
//        self.bottomButton.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        
        let tableViewX : CGFloat = 0
//        let tableViewY : CGFloat = NavigationBarHeight
        let tableViewY : CGFloat = 0
        let tableViewW : CGFloat = SCREENWIDTH
        let tableViewH : CGFloat = SCREENHEIGHT - tableViewY - margin
        self.tableView.frame = CGRect(x: tableViewX, y: tableViewY, width: tableViewW, height: tableViewH)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
//        self.bottomButton.embellishView(redius: 5)
//        self.bottomButton.backgroundColor = UIColor.red
//        self.bottomButton.setTitle(DDLanguageManager.text("confirm"), for: UIControl.State.normal)
//        self.bottomButton.addTarget(self, action: #selector(sureClick(sender:)), for: UIControl.Event.touchUpInside)
//        self.bottomButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        self.bottomButton.setTitleColor(UIColor.gray, for: UIControl.State.disabled)
//        self.bottomButton.isEnabled = false
        
    }
    //MARK:UITableViewDelegate and UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.languages.count ;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil  {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.languages[indexPath.row].1
//        cell?.selectionStyle = UITableViewCellSelectionStyle.blue
//        if let  currentLanguage = DDLanguageManager.LanguageTableName   {
//
//            if self.selectedLanguageIndexPath.row == 1111 {//第一次
//                if currentLanguage == languages[indexPath.row] {
//                    cell?.isSelected = true
//                    cell?.detailTextLabel?.text = "选中"
//                    self.currentLanguageIndexPath = indexPath
//                }else{
//                    cell?.detailTextLabel?.text = "未选中"
//                }
//
//            }else{//点击了任何行以后
//                if indexPath == self.selectedLanguageIndexPath {
//                    cell?.detailTextLabel?.text = "选中"
//                }else{
//                    cell?.detailTextLabel?.text = "未选中"
//                }
//                if self.currentLanguageIndexPath == self.selectedLanguageIndexPath {
//                    self.bottomButton.isEnabled = false
//
//                }else{
//                    self.bottomButton.isEnabled = true
//                }
//            }
//
//        }
        
//        cell?.separatorInset
        cell?.separatorInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 0)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //无关紧要
//        let currentStr = "\(indexPath.row)"
//        if  let _ = self.choosedIndexPaths[currentStr] {//键能找到值
//            self.choosedIndexPaths.removeValue(forKey: currentStr)
//        }else{//找不到就加进去
//            self.choosedIndexPaths[currentStr] = indexPath
//        }
        //        self.tableView.beginUpdates()
        //        self.tableView.endUpdates()

        
        
        //重要
//        self.selectedLanguageIndexPath = indexPath
        self.selectedLanguage = self.languages[indexPath.row].0
        DDLanguageManager.performChangeLanguage(targetLanguage: self.selectedLanguage)
        //        NotificationCenter.default.post(name: GDLanguageChanged, object: nil, userInfo: nil)
        GDAlertView.alert("保存成功", image: nil , time: 2) {
            rootNaviVC?.tabBarVC.reset()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         let currentStr = "\(indexPath.row)"
//        if  let _ = self.choosedIndexPaths[currentStr] {
            return 66
//        }else{return 44}
        
    }
    //MARK:customMethod
//    @objc func sureClick(sender : UIButton) {
//        mylog(GDStorgeManager.standard.object(forKey: "AppleLanguages"))
//        mylog(DDLanguageManager.gotcurrentSystemLanguage())
//        if self.selectedLanguage == "" {
//            GDAlertView.alert("请选择目标语言", image: nil, time: 2, complateBlock: nil)
//            return
//        }
//        DDLanguageManager.performChangeLanguage(targetLanguage: self.selectedLanguage)
////        NotificationCenter.default.post(name: GDLanguageChanged, object: nil, userInfo: nil)
//        GDAlertView.alert("保存成功", image: nil , time: 2) {
////            let _ = self.navigationController?.popViewController(animated: true)
//            rootNaviVC?.tabBarVC.reset()
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
