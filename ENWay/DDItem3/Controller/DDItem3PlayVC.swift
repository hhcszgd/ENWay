//
//  DDItem3PlayVC.swift
//  ENWay
//
//  Created by WY on 2018/12/14.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit

class DDItem3PlayVC: DDNormalVC {

    //视频比例是960 * 540
    var movieModel :   MediaModel = MediaModel()
    var movieModels :   [MediaModel] = [MediaModel]()
    var statusIsHidden = false
    lazy var playView : DDPlayerView = {
        let playView : DDPlayerView =  DDPlayerView.init(frame: CGRect.zero, mediaModel: movieModel , mediaModels: movieModels)
        //        playView.mediaModels = movieModels
        playView.backgroundColor = UIColor.green
        playView.justPlayedHandler = {[weak self] mediamodel in
            self?.title = mediamodel.name
        }
        return playView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playView)
        self.title = movieModel.name
        self.playView.snp.remakeConstraints { (make ) in
            let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
            make.top.equalTo(self.view).offset(h)
            make.left.right.bottom.equalTo(self.view)
        }
        self.addNotificationObserver()
        
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self , selector: #selector(hideStatusBar), name: NSNotification.Name(rawValue: "PeiXunMovieFullScreen"), object: nil )
        NotificationCenter.default.addObserver(self , selector: #selector(showStatusBar), name: NSNotification.Name(rawValue: "PeiXunMovieSmallScreen"), object: nil )
    }
    @objc func hideStatusBar() {
        statusIsHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @objc func showStatusBar() {
        statusIsHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self )
    }
    func configTableView() {
        self.playView.snp.remakeConstraints { (make ) in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return statusIsHidden //return make for hidding statusBar , and navigationBar become shortter than normal
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        //        super.preferredStatusBarUpdateAnimation
        return UIStatusBarAnimation.fade
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > size.height{//横
            self.hideStatusBar()
            self.navigationController?.setNavigationBarHidden(true , animated: false )
        }else{//竖
            self.showStatusBar()
            self.navigationController?.setNavigationBarHidden(false  , animated: false )
        }
        coordinator.animateAlongsideTransition(in: self.view, animation: { (context ) in
            mylog("animating")
            mylog("1 -> \(size)")
        }) { (context ) in
            mylog("complated animate")
            var  h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
            if size.width > size.height{//横
                h = 0
            }
            self.playView.snp.remakeConstraints { (make ) in
                
                make.top.equalTo(self.view).offset(h)
                make.left.right.bottom.equalTo(self.view)
                mylog("2 -> \(size)")
            }
            
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    deinit {
        mylog("is pei xun vc desdroyed ? ")
        self.playView.destroy()
        self.removeNotificationObserver()
    }
}


import SDWebImage
extension DDItem3PlayVC{
    class DDPeixunCell : UITableViewCell {
        
    }
    
    
}
