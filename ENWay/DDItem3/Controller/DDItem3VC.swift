//
//  DDItem3VC.swift
//  ENWay
//
//  Created by WY on 2018/12/13.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit

class DDItem3VC: DDNormalVC {
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    var movieModels :  [MediaModel]?
    var statusIsHidden = false
    
    var player : DDPlayerView?
    var selectedModel : MediaModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "online"
        configTableView()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        self.requestMyApi()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestMyApi()
    }
    
    func requestMyApi() {
        DDRequestManager.share.getVideosFromMyselfServer { (mp4Array) in
            if mp4Array.count == 0 {
                self.gotResourceFromDocumentDir()
            }else{
                self.movieModels = mp4Array.map({ (str ) -> MediaModel in
                    let m = MediaModel()
                    m.urlString = str
                    return m
                })
            }
            self.tableView.reloadData()
        }
        
        
        
        
    }
    func configTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = DDBackgroundColor1
        
        self.tableView.snp.remakeConstraints { (make ) in
            let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
            make.top.equalTo(self.view).offset(h)
            make.left.right.bottom.equalTo(self.view)
        }
//        gotResourceInSubBundle()
    }
    func gotResourceFromDocumentDir() {
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        FileManager.default.urls(for: FileManager.SearchPathDirectory.documentationDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
        let files = try? FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
        let videoNames = files?.filter({ (fileName) -> Bool in
            return fileName.contains("mp4")
        })
        movieModels = videoNames?.map({ (videoName ) -> MediaModel in
            let model = MediaModel()
            model.fileURLStr =  documentsURL.absoluteString + "\(videoName)"
            //            model.name = url.lastPathComponent + ".\(url.pathExtension)"
            return model
        })
        movieModels?.sort(by: { (modelLeft, modelRight) -> Bool in
            modelLeft.name < modelRight.name
        })
        
    }
    
    func gotResourceInSubBundle() {
        let bundle = Bundle.main
        guard let subBundlePath = bundle.path(forResource: "Movie", ofType: "bundle") else {return }
        guard let subBundle = Bundle(path: subBundlePath) else {return   }
        let urls = subBundle.urls(forResourcesWithExtension: "mp4", subdirectory: nil)
        movieModels = urls?.map({ (url ) -> MediaModel in
            let model = MediaModel()
            model.fileURLStr = url.absoluteString
//            model.name = url.lastPathComponent + ".\(url.pathExtension)"
            return model
        })
        movieModels?.sort(by: { (modelLeft, modelRight) -> Bool in
            modelLeft.name < modelRight.name
        })
        
    }
    override var prefersStatusBarHidden: Bool{
        return statusIsHidden //return make for hidding statusBar , and navigationBar become shortter than normal
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        //        super.preferredStatusBarUpdateAnimation
        return UIStatusBarAnimation.fade
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: tableView, animation: { (context ) in
            mylog("animating")
            mylog("1 -> \(size)")
        }) { (context ) in
            
            self.tableView.snp.remakeConstraints { (make ) in
                let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
                make.top.equalTo(self.view).offset(h)
                make.left.right.bottom.equalTo(self.view)
                mylog("2 -> \(size)")
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    deinit {
        mylog("is pei xun vc desdroyed ? ")
        self.player?.destroy()
    }
}

extension DDItem3VC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        type    string    1图文2视频
        
        guard  let cell = tableView.cellForRow(at: indexPath) as? DDPeixunCell else {
            return
        }
        
        if let model = self.movieModels?[indexPath.row]{
            let fileName = model.name
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(fileName)
            let localPath = documentsURL.path
            if FileManager.default.fileExists(atPath:localPath) {
                let vc = DDItem3PlayVC()
                vc.movieModels  = self.movieModels ?? []
                vc.movieModel = model
                self.navigationController?.pushViewController(vc, animated: true )
                selectedModel = model
            }else{
                mylog("去下载")
                DDRequestManager.share.downFile(mediaModel: model , complate: { (filePath) in
                    mylog("下载完成")
                    self.tableView.reloadData()
                }) { (progress ) in
                    let hasDownload = Float(progress.completedUnitCount)
                    let total = Float(progress.totalUnitCount)
                    cell.processView.progress = hasDownload/total
                    mylog(hasDownload/total)
                }
                
            }
            
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.movieModels?[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPeixunCell") as? DDPeixunCell{
            cell.textLabel?.text = model?.name
            cell.contentView.backgroundColor = DDBackgroundColor1
            cell.textLabel?.textColor = DDTitleColor1
            cell.mediaModel = model
            return cell
        }else{
            
            let cell = DDPeixunCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDPeixunCell")
            cell.contentView.backgroundColor = DDBackgroundColor1
            cell.textLabel?.textColor = DDTitleColor1
            cell.textLabel?.text = model?.name
            cell.mediaModel = model
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let model = self.movieModels?[indexPath.row]{
            let fileName = model.name
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            let localPath = documentsURL.path
            if FileManager.default.fileExists(atPath:localPath) {
               try? FileManager.default.removeItem(atPath: localPath)
                tableView.reloadData()
            }
            
            
            
            
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
import SDWebImage
extension DDItem3VC{
    class DDPeixunDataModel : NSObject , Codable{
        var items : [DDPeixunSourceModel]?
        var top_img : String?
    }
    class DDPeixunSourceSuperModel : NSObject{
        var isSelected = false
    }
    class DDPeixunSourceModel : DDPeixunSourceSuperModel , Codable{
        var content : String?
        var name : String?
        var thumbnail : String?
        var type : String?
        var id : String?
    }
    class DDPeixunCell : UITableViewCell {
        let processView = UIProgressView(frame: CGRect.zero)
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(processView)
            processView.trackTintColor =  UIColor.DDLightGray
            processView.tintColor =  UIColor.orange
            processView.snp.makeConstraints { (make ) in
                make.left.bottom.right.equalTo(self.contentView)
                make.height.equalTo(1)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
        }
        var mediaModel  : MediaModel?{
            didSet{
                self.processView.progress = 0
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(mediaModel?.name ?? "")
                let localPath = documentsURL.path
                if FileManager.default.fileExists(atPath:localPath) {
                    self.accessoryType = .checkmark
//                    self.processView.isHidden = true
                    self.processView.progress = 1
                }else{
                    self.processView.progress = 0
                    self.accessoryType = .none
//                    self.processView.isHidden = false
                }
                layoutIfNeeded()
                setNeedsLayout()
            }
        }
        
    }
}

