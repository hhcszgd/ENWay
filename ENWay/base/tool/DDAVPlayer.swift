//
//  DDAVPlayer.swift
//  ENWay
//
//  Created by WY on 2018/12/10.
//  Copyright © 2018 WY. All rights reserved.
//
/*
 @available(iOS 5.0, *)
 public static let AVPlayerItemTimeJumped: NSNotification.Name
 
 @available(iOS 4.0, *)
 public static let AVPlayerItemDidPlayToEndTime: NSNotification.Name // item has played to its end time
 
 */
import UIKit
import AVKit
import MediaPlayer
class DDAVPlayer1: NSObject , DDMediaPlayProtocal{
    var mediaType: DDMediaType = .sound
    
    
    var mediaModels: [MediaModel] = []{
        didSet{
            self.currentMediaIndex = -1
        }
    }
    var canBecomeFirstResponder: Bool = true
    
    internal var currentMediaIndex: Int = -1
    
    var playerLayer: AVPlayerLayer?
    
    var pdfModels: [MediaModel]?
    
    var player : AVPlayer = AVPlayer(playerItem: nil )
    static let share : DDAVPlayer1 =  {
        let p = DDAVPlayer1()
        return p
    }()
    override init() {
        super.init()
        self.setupLockScreen()
        self.addNotification()
    }
    func endPlayCallback(mediaModel: MediaModel) {
        self.next()
        NotificationCenter.default.post(name:  Notification.Name("ReloadPdfNotification"), object: self)
    }
    
}

/* change play time
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
    DDAVPlayer1.share.player.seek(to: CMTime(seconds: 300, preferredTimescale: CMTimeScale(1))) { (bb) in
        
    }
}
*/
