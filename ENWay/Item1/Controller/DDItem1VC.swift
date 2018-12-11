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

class MusicModel: NSObject , Codable {
    var name  = ""
    var urlStr = ""
    var size = ""
    var url : URL?
}



class DDItem1VC: DDNormalVC {
    var musicModels : [MediaModel]?
    var pdfModels : [MediaModel]?
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐列表"
        self.configTableView()
        
        musicModels = self.gotResourceInSubBundle()?.map({ (url ) -> MediaModel in
            let model = MediaModel()
            model.url = url
            model.name = url.lastPathComponent + ".\(url.pathExtension)"
            return model
        })
        musicModels?.sort(by: { (modelLeft, modelRight) -> Bool in
            modelLeft.name < modelRight.name
        })
        self.pdfModels = self.gotPDFInSubBundle()
        
        if DDAVPlayer1.share.mediaModels  != self.musicModels ?? [] {
            DDAVPlayer1.share.mediaModels = self.musicModels ?? []
        }
        if DDAVPlayer1.share.pdfModels != self.pdfModels ?? []{
            DDAVPlayer1.share.pdfModels = self.pdfModels
        }
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        configNaviBar()
    }
    
    func configNaviBar() {
        let editBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        editBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        //        editBtn.setImage(UIImage.init(named: "history"), for: UIControlState.normal)
        editBtn.setTitle("设置", for: UIControl.State.normal)
        editBtn.backgroundColor = UIColor.clear
        editBtn.addTarget(self, action: #selector(setting(sender:)), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        
    }
    @objc func setting(sender:UIButton) {
//        self.navigationController?.pushViewController(SettingVC(), animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func gotResourceInSubBundle() -> [URL]? {
        //        let bundle : Bundle = Bundle(for: AHPAPI.self)       //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
        
        let bundle = Bundle.main
        guard let subBundlePath = bundle.path(forResource: "Music", ofType: "bundle") else {return nil}
        guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        return subBundle.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        
        //    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
        //    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        //    if let tempDirectory = directory {
        //        guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: tempDirectory) else {return nil}
        //        return itemPath
        //    }else{
        //        guard let  itemPath = subBundle.path(forResource: name, ofType: type) else {  return nil  }
        //        return itemPath
        //    }
    }
    func gotPDFInSubBundle() -> [MediaModel]? {
        //        let bundle : Bundle = Bundle(for: AHPAPI.self)       //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
        
        let bundle = Bundle.main
        guard let subBundlePath = bundle.path(forResource: "Music", ofType: "bundle") else {return nil}
        guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        var pdfs = subBundle.urls(forResourcesWithExtension: "pdf", subdirectory: nil)
        var temp  = pdfs?.map({ (url ) -> MediaModel in
            let model = MediaModel()
            model.url = url
            model.name = url.lastPathComponent + ".\(url.pathExtension)"
            return model
        })
        temp?.sort(by: { (modelLeft, modelRight) -> Bool in
            modelLeft.name < modelRight.name
        })
        
        return temp
        
        
        //    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
        //    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
        //    if let tempDirectory = directory {
        //        guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: tempDirectory) else {return nil}
        //        return itemPath
        //    }else{
        //        guard let  itemPath = subBundle.path(forResource: name, ofType: type) else {  return nil  }
        //        return itemPath
        //    }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: tableView, animation: { (context ) in
            mylog("animating")
            mylog("1 -> \(size)")
        }) { (context ) in
            mylog("complated animate")
            self.tableView.snp.remakeConstraints { (make ) in
                let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
                make.top.equalTo(self.view).offset(h)
                make.left.right.bottom.equalTo(self.view)
                mylog("2 -> \(size)")
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}



extension DDItem1VC : UITableViewDelegate , UITableViewDataSource{
    
    func configTableView()  {
        self.view.frame.size.height = self.view.bounds.height - DDTabBarHeight
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        MusicPlayer.share.currentMusicIndex = indexPath.row
        //        if let name = musicModels?[indexPath.row].name {
        //            var  para  = [String: Any]()
        //            para["currentSong"] = indexPath.row
        //            para["songsArr"] = musicModels
        //            para["pdfs"] = self.pdfModels
        
//        let vc = PlayVC()
        let vc = DDMusicPlayVC1()
        
        //        vc.musicModel = musicModels
        //        vc.pdfModels = pdfModels
        vc.currentMediaModel = self.musicModels?[indexPath.row]
        vc.userInfo = pdfModels?[indexPath.row].url?.absoluteString
        self.navigationController?.pushViewController(vc , animated: true )
        //            self.pushVC(vcIdentifier: "PlayVC", userInfo:para)
        //        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.musicModels?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell_music"){
            cell = tempCell
        }else{
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "UITableViewCell_music")
        }
        //        cell.backgroundColor = UIColor.init(red:CGFloat (arc4random() % 256) / 256, green: CGFloat((arc4random() % 256) / 256), blue:CGFloat((arc4random() % 256) / 256), alpha: 1)
        
        cell.textLabel?.text = self.musicModels?[indexPath.row].name
        return cell
    }
}

