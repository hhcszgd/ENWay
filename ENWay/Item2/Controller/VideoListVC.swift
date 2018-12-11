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
        self.gotResourceInSubBundle()
        
    }
    
    func configTableView() {  
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        
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
            model.url = url
            model.name = url.lastPathComponent + ".\(url.pathExtension)"
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
//                selectedModel?.isSelected = false
//                model.isSelected = true
                selectedModel = model
//                self.tableView.reloadData()//
//            if let player = self.player {
//                    let url = model.url?.absoluteString ?? ""
//                    let currentUrl = self.player?.currentUrl ?? ""
//                    if url != currentUrl {
//                        player.replaceCurrentMovieItemWith(urlStr: url)
//                        self.player?.bottomBar.perfomrTap()
//                    }
//                    player.playerLayer?.player?.play()
//                }else{
//                    self.player =  DDPlayerView.init(frame: CGRect(x: 0, y: 0, width: self.tableHeader.bounds.width , height:self.tableHeader.bounds.height), superView: self.tableHeader, urlStr: model.url?.absoluteString ?? "")
//                    self.player?.playerLayer?.player?.play()
//                }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.movieModels?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPeixunCell") as? DDPeixunCell{
            cell.textLabel?.text = model?.name
            //            cell.keyWorld = self.searchBox.text
            return cell
        }else{
            
            let cell = DDPeixunCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DDPeixunCell")
            //            cell.keyWorld = self.searchBox.text
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
    class DDPeixunCell : UITableViewCell {
//        let icon  = UIImageView()
//        let title = UILabel()
//        let playIdentify = UIView()
//        let bottomLine = UIView()
//
//        var model : DDPeixunSourceModel? {
//            didSet{
//                title.text = model?.name
//                // 1图文2视频
//                if model?.type ?? "" == "2"{//视频
//                    if model?.isSelected ?? false {
//                        icon.image = UIImage(named:"videoplayback")
//                        playIdentify.backgroundColor = UIColor.orange
//                    }else{
//                        icon.image = UIImage(named:"videoisnotplayed")
//                        playIdentify.backgroundColor = UIColor.clear
//                    }
//                }else if model?.type ?? "" == "1"{//网页
//                    icon.image = UIImage(named:"image&text")
//                }
//            }
//        }
//
//        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            self.selectionStyle = .none
//            self.contentView.addSubview(icon)
//            self.contentView.addSubview(title)
//            self.contentView.addSubview(playIdentify)
//            self.contentView.addSubview(bottomLine)
//            title.textColor = UIColor.DDTitleColor
//            title.font = GDFont.systemFont(ofSize: 17)
//            bottomLine.backgroundColor = UIColor.DDLightGray
//        }
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            let margin : CGFloat = 10
//            let bottomLineH : CGFloat = 2
//            let iconTopMargin : CGFloat = 20
//            let iconWH = self.bounds.height - iconTopMargin * 2 - bottomLineH
//            icon.frame = CGRect(x: margin , y: iconTopMargin , width:iconWH, height:iconWH )
//            title.ddSizeToFit()
//            title.frame = CGRect(x: icon.frame.maxX + margin, y: 0 , width: self.frame.width - margin - icon.frame.maxX - margin , height: self.bounds.height)
//            let playIdentifyWH : CGFloat = 14
//            let playIdentifyY : CGFloat = (self.bounds.height - playIdentifyWH ) / 2
//            playIdentify.frame = CGRect(x: self.bounds.width - (playIdentifyWH + margin), y: playIdentifyY , width: playIdentifyWH , height:playIdentifyWH)
//            playIdentify.layer.cornerRadius = playIdentifyWH/2
//            playIdentify.layer.masksToBounds = true
//            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
//
//
//        }
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
    }
    
    
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
