//
//  DDMusicPlayVC.swift
//  ENWay
//
//  Created by WY on 2018/12/10.
//  Copyright © 2018 WY. All rights reserved.
//
import UIKit
import SnapKit
import AVKit
class DDMusicPlayVC1: DDOnceBackWebVC {
    
    var currentMediaModel : MediaModel?
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let controlBUtton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model  = self.currentMediaModel{
            DDAVPlayer1.share.play(mediaModel: model)
        }
        
        //        self.view.backgroundColor = UIColor.orange
        let lastPathComponent = DDAVPlayer1.share.mediaModels[DDAVPlayer1.share.currentMediaIndex].url?.lastPathComponent ?? "name"
        let pathExtension = self.currentMediaModel?.url?.pathExtension ?? "extexsion"
        
        self.title = lastPathComponent + pathExtension
        //       self.loadPdf()
        NotificationCenter.default.addObserver(self , selector: #selector(loadPdf), name: Notification.Name("ReloadPdfNotification"), object: DDAVPlayer1.share)
        self.confitRightButton()
        // Do any additional setup after loading the view.
    }
    func confitRightButton() {
        button.setTitle("next", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.addTarget(self , action: #selector(testReloadPdf), for: UIControl.Event.touchUpInside)
        
        
        controlBUtton.setTitle("停/播", for: UIControl.State.normal)
        controlBUtton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        controlBUtton.addTarget(self , action: #selector(control(sender:)), for: UIControl.Event.touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button),UIBarButtonItem(customView: controlBUtton)]
    }
    @objc func control(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.stopPlay()
        }else{
            self.performPlay()
        }
    }
    func stopPlay() {
        DDAVPlayer1.share.pause()
    }
    func performPlay() {
            DDAVPlayer1.share.play()
    }
    @objc func testReloadPdf() {
        DDAVPlayer1.share.next()
        self.loadPdf()
    }
    @objc func loadPdf() {
        mylog("重载")
        let lastPathComponent = DDAVPlayer1.share.mediaModels[DDAVPlayer1.share.currentMediaIndex].url?.lastPathComponent ?? "name"
        let pathExtension = DDAVPlayer1.share.mediaModels[DDAVPlayer1.share.currentMediaIndex].url?.pathExtension ?? "extexsion"
        
        self.title = lastPathComponent + pathExtension
        let pdfModel = DDAVPlayer1.share.pdfModels?[DDAVPlayer1.share.currentMediaIndex]
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
                    DDAVPlayer1.share.player.pause()
                    
                case .remoteControlPlay://
                    DDAVPlayer1.share.player.play()
                    
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
