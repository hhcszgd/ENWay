//
//  PlayVC.swift
//  PHPAPI
//
//  Created by WY on 2018/3/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class PlayVC: DDOnceBackWebVC {
    
//    var musicModel : [MusicModel]?
//    var pdfModels : [MusicModel]?
    var currentIndex : Int = -111
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        if  currentIndex != MusicPlayer.share.currentMusicIndex{
            MusicPlayer.share.currentMusicIndex = currentIndex
            MusicPlayer.share.playMusic1()
        }
//        self.view.backgroundColor = UIColor.orange
        let lastPathComponent = MusicPlayer.share.musics?[MusicPlayer.share.currentMusicIndex].url?.lastPathComponent ?? "name"
        let pathExtension = MusicPlayer.share.musics?[MusicPlayer.share.currentMusicIndex].url?.pathExtension ?? "extexsion"
        
        self.title = lastPathComponent + pathExtension
//       self.loadPdf()
        NotificationCenter.default.addObserver(self , selector: #selector(loadPdf), name: Notification.Name("ReloadPdfNotification"), object: MusicPlayer.share)
        self.confitRightButton()
        // Do any additional setup after loading the view.
    }
    func confitRightButton() {
        button.setTitle("下一篇", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.addTarget(self , action: #selector(testReloadPdf), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func testReloadPdf() {
        MusicPlayer.share.audioPlayerDidFinishPlaying(MusicPlayer.share.player!, successfully: true)
    }
    @objc func loadPdf() {
        mylog("重载")
        let lastPathComponent = MusicPlayer.share.musics?[MusicPlayer.share.currentMusicIndex].url?.lastPathComponent ?? "name"
        let pathExtension = MusicPlayer.share.musics?[MusicPlayer.share.currentMusicIndex].url?.pathExtension ?? "extexsion"
        
        self.title = lastPathComponent + pathExtension
        let pdfModel = MusicPlayer.share.pdfModels?[MusicPlayer.share.currentMusicIndex]
        if let url = pdfModel?.url {
            self.webView.load(URLRequest(url: url))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    override var canBecomeFirstResponder: Bool{
        get{return true }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.endReceivingRemoteControlEvents()
//        self.resignFirstResponder()
    }

    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        if let eventUnwrap = event{
            if eventUnwrap.type == UIEvent.EventType.remoteControl {
                switch eventUnwrap.subtype{
                case .remoteControlPause://
                    MusicPlayer.share.player?.pause()
                    
                case .remoteControlPlay://
                    MusicPlayer.share.player?.play()
                    
                case .remoteControlPreviousTrack:////上一曲
//                    MusicPlayer.share.player?.pause()
                    break
                case .remoteControlNextTrack://
//                    MusicPlayer.share.player?.pause()
                    break
                default :
                    break
                }
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: webView, animation: { (context ) in
            mylog("animating")
            mylog("1 -> \(size)")
        }) { (context ) in
            mylog("complated animate")
            self.webView.snp.remakeConstraints { (make ) in
                let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
                make.top.equalTo(self.view).offset(h)
                make.left.right.bottom.equalTo(self.view)
                mylog("2 -> \(size)")
            }
            self.button.snp.remakeConstraints({ (make ) in
                make.bottom.right.equalTo(self.navigationController!.navigationBar)
                make.width.height.equalTo(44)
            })
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
