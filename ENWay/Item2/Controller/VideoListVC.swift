//
//  VideoListVC.swift
//  PHPAPI
//
//  Created by WY on 2018/10/18.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
class VideoListVC: DDNormalVC {

 
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    var movieModels :  [MediaModel]?
    var statusIsHidden = false
    
    var player : DDPlayerView?
    var selectedModel : MediaModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频列表"
        configTableView()
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.reloadData()
        
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
            mylog("2 -> \(size)")
        }
//        tableView.tableHeaderView = self.tableHeader
        //        DDPlayerView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH , height:SCREENWIDTH * 0.7), superView: self.tableHeader, urlStr: "http://1252719796.vod2.myqcloud.com/e7d81610vodgzp1252719796/27444c997447398156401949676/QHAfaCW5HiEA.mp4")
        gotResourceInSubBundle()
    }
    func gotResourceInSubBundle() {
        //        let bundle : Bundle = Bundle(for: AHPAPI.self)       //refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MJRefreshComponent class]] pathForResource:@"MJRefresh" ofType:@"bundle"]];
        
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

extension VideoListVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        type    string    1图文2视频
        
        if let model = self.movieModels?[indexPath.row]{
            let vc = DDVideoPlayVC()
            vc.movieModels  = self.movieModels ?? []
            vc.movieModel = model
            self.navigationController?.pushViewController(vc, animated: true )
                selectedModel = model
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
            return cell
        }else{
            
            let cell = DDPeixunCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDPeixunCell")
            cell.contentView.backgroundColor = DDBackgroundColor1
            cell.textLabel?.textColor = DDTitleColor1
            cell.textLabel?.text = model?.name
            return cell
        }
    }
}
import SDWebImage
extension VideoListVC{
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
    class DDPeixunCell : UITableViewCell {  }
}
class DDPeixunHeader : UIView{
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.image = UIImage(named: "view")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
