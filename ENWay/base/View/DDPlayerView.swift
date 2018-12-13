//
//  DDPlayerView.swift
//  TestAVPlayerLayer
//
//  Created by WY on 2018/6/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//
import UIKit
import AVKit
class DDPlayerView: UIView , DDMediaPlayProtocal {
    var justPlayedHandler : ((MediaModel) -> Void)?
    /// play source
    var mediaType: DDMediaType = .video
    var player: AVPlayer = AVPlayer.init(playerItem:nil)
    var mediaModels: [MediaModel] = []
    override var canBecomeFirstResponder: Bool {return  true}
    internal var currentMediaIndex: Int = -9
    var pdfModels: [MediaModel]?
    var playerLayer : AVPlayerLayer?
    /// subviews
    let imageView = UIImageView()
    let bottomBar = DDPlayerControlBar()
    private var indicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    private var tapCount : Int = 0
    private var needRemoveObserver : Bool = false
    var currentUrl : String?
    init(frame: CGRect , mediaModel: MediaModel ,mediaModels: [MediaModel]) {
        super.init(frame: frame)
        self.addNotification()
        self.mediaModels = mediaModels
        self.backgroundColor = UIColor.white
        self.bottomBar.delegate = self
        _addsubViews()
        playerLayer = AVPlayerLayer.init(player: self.player)
        self.play(mediaModel: mediaModel)
        self.configPlayer()
    }
    deinit {  mylog("video player destroyed")  }
    func destroy()  {
//        self.removePlayerObserver()
        self.playerLayer?.player?.pause()
        self.playerLayer?.player = nil
        self.playerLayer?.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touches")
        self.bottomBar.perfomrTap()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// about player
extension DDPlayerView {
    func configPlayer() {
        if let playLayer = playerLayer{
            self.layer.addSublayer(playLayer)
            playLayer.frame = self.bounds
            playLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            playLayer.contentsScale = UIScreen.main.scale
        }
    }
    /// play call back
    func almostPlayCallback(mediaModel: MediaModel) {
        self.indicatorView.startAnimating()
        self.bringSubviewToFront(self.indicatorView)
    }
    func justPlayedCallback(mediaModel: MediaModel) {
        self.justPlayedHandler?(mediaModel)
    }
    func nextCallback(mediaModel: MediaModel) {
        layoutIfNeeded()
        setNeedsLayout()
    }
    func setPlaceholderImage(imgUrlStr : String?) {
        self.imageView.image = nil
        self.imageView.setImageUrl(url: imgUrlStr)
    }
    func endPlayCallback(mediaModel: MediaModel) {
        self.bottomBar.configUIWhenPlayEnd()
        self.next()
    }
    func pauseCallback(mediaModel: MediaModel) {
        self.bottomBar.configUIWhenPause()
    }
    func updateTimeWhilePlayingCallback(currentItme: CMTime, player: DDMediaPlayProtocal) {
        self.bottomBar.configUIWhenPlaying()
        if let duration = self.player.currentItem?.duration {
            let seconds = duration.seconds
            let maxinumvalue = Float(seconds)
            self.bottomBar.configSlider(minimumValue: 0.0, maximumValue: maxinumvalue.isNaN ? 0.0 : maxinumvalue)
        }else {
            self.bottomBar.configSlider(minimumValue: 0.0, maximumValue: 0.0)
        }
        if self.indicatorView.isAnimating {self.indicatorView.stopAnimating()}
        let value = Float((self.player.currentItem?.currentTime() ?? CMTime.zero).seconds)
        if !value.isNaN , value < 2 {
            self.layoutBottomBar()
        }
        self.bottomBar.configSliderValue(value:value)
    }
}
/// layout subviews
extension DDPlayerView {
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.pause()
        self.playerLayer = nil
        self.playerLayer?.player = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
        self.imageView.frame = self.bounds
        indicatorView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        layoutBottomBar()
        self.superview?.bringSubviewToFront(self)
    }
    func layoutBottomBar() {
        if let size = playerLayer?.player?.currentItem?.presentationSize , size != CGSize.zero{
            var realH = self.bounds.width * size.height / size.width
            if realH > self.bounds.height {//以宽为标准
                realH = self.bounds.height
            }
            let targetFrame =  CGRect(x: 0, y: self.bounds.height / 2 + realH / 2 - 40, width: self.bounds.width, height: 40)
            if targetFrame != self.bottomBar.frame{
                self.bottomBar.frame = targetFrame
            }
            self.bringSubviewToFront(self.bottomBar)
            self.bringSubviewToFront(imageView)
        }
    }
    
    func _addsubViews()  {
        self.addSubview(bottomBar)
        bottomBar.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(indicatorView)
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .gray
        self.bottomBar.isHidden = true
        self.addSubview(imageView)
        self.imageView.isHidden = true
    }
}

extension DDPlayerView : DDPlayerControlDelegate{
    func screenChanged(isFullScreen: Bool) {
        self.next()
    }
    func sliderChanged(sender: DDSlider) {
        let seconds = sender.value
        //        CMTimeMakeWithSeconds
        let targetTime =  CMTimeMakeWithSeconds(Float64(seconds), preferredTimescale: self.playerLayer?.player?.currentItem?.currentTime().timescale ?? Int32(0));
        self.playerLayer?.player?.seek(to: targetTime, completionHandler: { (bool ) in
            
        })
    }
    func pressToPlay() {
        self.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.playerLayer?.player?.rate == 0.0{                
                self.indicatorView.startAnimating()
            }
        }
    }
    func pressToPause() {
        self.pause()
    }
}
