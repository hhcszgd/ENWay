//
//  DDMusicPlayVC.swift
//  ENWay
//
//  Created by WY on 2018/12/10.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit

import SnapKit
class DDMusicPlayVC: DDOnceBackWebVC {

    var currentIndex : Int = -111
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let controlBUtton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        if  currentIndex != DDAVPlayer.share.currentMusicIndex{
            DDAVPlayer.share.currentMusicIndex = currentIndex
            DDAVPlayer.share.playMusic1()
        }
        //        self.view.backgroundColor = UIColor.orange
        let lastPathComponent = DDAVPlayer.share.musics?[DDAVPlayer.share.currentMusicIndex].url?.lastPathComponent ?? "name"
        let pathExtension = DDAVPlayer.share.musics?[DDAVPlayer.share.currentMusicIndex].url?.pathExtension ?? "extexsion"
        
        self.title = lastPathComponent + pathExtension
        //       self.loadPdf()
        NotificationCenter.default.addObserver(self , selector: #selector(loadPdf), name: Notification.Name("ReloadPdfNotification"), object: DDAVPlayer.share)
        self.confitRightButton()
        // Do any additional setup after loading the view.
    }
    func confitRightButton() {
        button.setTitle("下一篇", for: UIControl.State.normal)
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
        DDAVPlayer.share.player.pause()
    }
    func performPlay() {
        DDAVPlayer.share.player.play()
    }
    @objc func testReloadPdf() {
        DDAVPlayer.share.audioPlayerDidFinishPlaying( successfully: true)
    }
    @objc func loadPdf() {
        mylog("重载")
        let lastPathComponent = DDAVPlayer.share.musics?[DDAVPlayer.share.currentMusicIndex].url?.lastPathComponent ?? "name"
        let pathExtension = DDAVPlayer.share.musics?[DDAVPlayer.share.currentMusicIndex].url?.pathExtension ?? "extexsion"
        
        self.title = lastPathComponent + pathExtension
        let pdfModel = DDAVPlayer.share.pdfModels?[DDAVPlayer.share.currentMusicIndex]
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
                    DDAVPlayer.share.player.pause()
                    
                case .remoteControlPlay://
                    DDAVPlayer.share.player.play()
                    
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
