//
//  DDMediaPlayProtocal.swift
//  ENWay
//
//  Created by WY on 2018/12/11.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
enum DDMediaType : Int , Codable{
    case sound
    case video
}
enum DDMediaPlayResult : Error{
    case success(String)
    case failue(String)
}
class MediaModel: NSObject , Codable {
    var name  = ""
//    var urlStr = ""
    var size = ""
    var url : URL?{
        didSet{
            if let url = url {
                name = url.lastPathComponent + ".\(url.pathExtension)"
            }else{
                name = "unknownName"
            }
        }
    }
    var mediaType : DDMediaType = .sound
}
protocol DDMediaPlayProtocal: NSObjectProtocol {
    /*proterty*/
    /// common
    var mediaType : DDMediaType{get  set}
    var player : AVPlayer{get  set}
    var mediaModels : [MediaModel]{get  set}
    var canBecomeFirstResponder: Bool{get}
    var currentMediaIndex : Int{get set} // internal
    /// video
    var playerLayer : AVPlayerLayer? {get set }
    /// audio
    var pdfModels : [MediaModel]?{get set }
    /*method*/
    /// common
    
    /// needn't implement
    @discardableResult
    func play(mediaModel:MediaModel?) -> DDMediaPlayResult 
    /// needn't implement
    func pause()
    /// needn't implement
    func next()
    /// needn't implement
    func privious()
   
    
    /// video
    
    /// audio
    
    /// call back
    func almostPlayCallback(mediaModel:MediaModel)
    func justPlayedCallback(mediaModel:MediaModel)
    func nextCallback(mediaModel:MediaModel)
    func pauseCallback(mediaModel:MediaModel)
    func continueCallback(mediaModel:MediaModel)
    func priviousCallback(mediaModel:MediaModel)
    func endPlayCallback(mediaModel:MediaModel)
    func updateTimeWhilePlayingCallback(currentItme : CMTime , player:DDMediaPlayProtocal)
}
// call back implement
extension DDMediaPlayProtocal{
    func almostPlayCallback(mediaModel:MediaModel){mylog("almostPlayCallback -> protocal")}
    func justPlayedCallback(mediaModel:MediaModel){mylog("justPlayedCallback-> protocal")}
    func nextCallback(mediaModel:MediaModel){mylog("nextCallback-> protocal")}
    func pauseCallback(mediaModel:MediaModel){mylog("pauseCallback-> protocal")}
    func continueCallback(mediaModel:MediaModel){mylog("continueCallback->  protocal")}
    func priviousCallback(mediaModel:MediaModel){mylog("priviousCallback-> protocal")}
    func endPlayCallback(mediaModel:MediaModel){mylog("endPlayCallback -> protocal")}
    func updateTimeWhilePlayingCallback(currentItme : CMTime , player:DDMediaPlayProtocal){mylog("updateTimeWhilePlayingCallback -> protocal")}
}
/// play control method
extension DDMediaPlayProtocal{
    @discardableResult
    func play(mediaModel:MediaModel? = nil ) -> DDMediaPlayResult {
        
        
        var mediaModel  =  mediaModel
        if mediaModel == nil  {
            if self.mediaModels.count >= currentMediaIndex{
                mediaModel = self.mediaModels[currentMediaIndex]
            }else{
                return DDMediaPlayResult.failue("no mediaModels")
            }
        }
        
        almostPlayCallback(mediaModel: mediaModel!)
        if let avurlAsset = self.player.currentItem?.asset as? AVURLAsset {
            if let url = mediaModel?.url?.absoluteString{
                if avurlAsset.url.absoluteString == url{
                    switch  self.player.timeControlStatus {
                    case .playing:
                        return DDMediaPlayResult.success("is playing")
                    case .paused:
                        self.player.play()
                        self.continueCallback(mediaModel: mediaModel!)
                        return DDMediaPlayResult.success("success")
                    case .waitingToPlayAtSpecifiedRate:
                        return judgePlay(mediaModel: mediaModel!)
                        //                return DDMediaPlayResult.failue("loading")
                    }
                }else{
                    return judgePlay(mediaModel: mediaModel!)
                }
            }else{
                return DDMediaPlayResult.failue("invalid url ")
            }
           
        }else{
            return judgePlay(mediaModel: mediaModel!)
        }
    }
    @discardableResult
    private func judgePlay(mediaModel:MediaModel) ->  DDMediaPlayResult {
        guard let url = mediaModel.url  else {
            return DDMediaPlayResult.failue("invalid url")
        }
        let musicName = url.lastPathComponent + ".\(url.pathExtension)"
        let avplayitem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: avplayitem)
        configureNowPlayingInfo(musicName:musicName)
        mylog(self.mediaModels.index(of: mediaModel))
        mylog(self.mediaModels.firstIndex(of: mediaModel))
        mylog(self.mediaModels)
        if let index  = self.mediaModels.index(of: mediaModel){
            self.currentMediaIndex = index
        }
        self.player.play()
        justPlayedCallback(mediaModel: mediaModel)
        return DDMediaPlayResult.success("success")
    
    }
    
    func pause() {
        self.player.pause()
        if self.mediaModels.count >= currentMediaIndex{
            pauseCallback(mediaModel: self.mediaModels[currentMediaIndex])
        }else{
            pauseCallback(mediaModel: MediaModel())
        }
    }
    func next()
    {
        if self.mediaModels.count == 0 {return}
        mylog(currentMediaIndex)
        mylog(mediaModels.count)
        self.currentMediaIndex += 1
        if mediaModels.count  > 0 && self.currentMediaIndex >= mediaModels.count {
            self.currentMediaIndex = 0
        }
        if self.mediaModels.count >= currentMediaIndex{
            self.play(mediaModel: self.mediaModels[currentMediaIndex])
            nextCallback(mediaModel: self.mediaModels[currentMediaIndex])
        }else{
            currentMediaIndex = 0
            nextCallback(mediaModel: MediaModel())
        }
    }
    func privious()
    {
        if self.mediaModels.count == 0 {return}
        self.currentMediaIndex -= 1
        if  mediaModels.count > 0 && currentMediaIndex < 0   {
            currentMediaIndex = mediaModels.count - 1
        }
        if self.mediaModels.count > currentMediaIndex{
            self.play(mediaModel: self.mediaModels[currentMediaIndex])
            priviousCallback(mediaModel: self.mediaModels[currentMediaIndex])
        }else{
            currentMediaIndex = 0
            priviousCallback(mediaModel: MediaModel())
        }
        mylog("dddddddddddddd")
    }
}
///private function
extension DDMediaPlayProtocal{
    
    func configureNowPlayingInfo(musicName:String) {
       
        let nowPlayingInfo = [MPMediaItemPropertyTitle: musicName,
                              MPMediaItemPropertyPlaybackDuration: (self.player.currentItem?.duration ?? CMTime.zero).value,
                              MPNowPlayingInfoPropertyElapsedPlaybackTime: self.player.currentTime,
                              MPNowPlayingInfoPropertyPlaybackRate: Double(self.player.rate),
                              MPMediaItemPropertyMediaType: MPMediaType.movie.rawValue] as [String : Any]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupLockScreen(){
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.changeShuffleModeCommand.isEnabled = true//
        commandCenter.changeRepeatModeCommand.isEnabled = true//
        commandCenter.changePlaybackRateCommand.isEnabled = true//
        commandCenter.changePlaybackRateCommand.isEnabled = true//
        commandCenter.playCommand.isEnabled = true//播放
        commandCenter.pauseCommand.isEnabled = true//暂停
        commandCenter.nextTrackCommand.isEnabled = true//下一曲
        commandCenter.previousTrackCommand.isEnabled = true//上一曲
        
        commandCenter.pauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.pause()
            return  MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.playCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.play(mediaModel: self.mediaModels[self.currentMediaIndex] )
            return  MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.stopCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.pause()
            return  MPRemoteCommandHandlerStatus.success
        }
        
//        open var togglePlayPauseCommand: MPRemoteCommand { get }
        
//        @available(iOS 9.0, *)
//        open var enableLanguageOptionCommand: MPRemoteCommand { get }
        
//        @available(iOS 9.0, *)
//        open var disableLanguageOptionCommand: MPRemoteCommand { get }
        
//        open var changePlaybackRateCommand: MPChangePlaybackRateCommand { get }
        
//        open var changeRepeatModeCommand: MPChangeRepeatModeCommand { get }
        
//        open var changeShuffleModeCommand: MPChangeShuffleModeCommand { get }
        
        
        // Previous/Next Track Commands
        commandCenter.nextTrackCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.next()
            return  MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.previousTrackCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            self.privious()
            return  MPRemoteCommandHandlerStatus.success
        }
        
        
        // Skip Interval Commands
//        open var skipForwardCommand: MPSkipIntervalCommand { get }
        
//        open var skipBackwardCommand: MPSkipIntervalCommand { get }
        
        
        // Seek Commands
//        open var seekForwardCommand: MPRemoteCommand { get }
        
//        open var seekBackwardCommand: MPRemoteCommand { get }
        
        commandCenter.changePlaybackPositionCommand.addTarget {[weak self] (event ) -> MPRemoteCommandHandlerStatus in
            if let eventPosition = event as? MPChangePlaybackPositionCommandEvent{
                mylog(eventPosition.positionTime)
                
                self?.player.seek(to: CMTime(seconds: eventPosition.positionTime, preferredTimescale: CMTimeScale(1)), completionHandler: { (bool ) in
                    
                })
            }
            
            return  MPRemoteCommandHandlerStatus.success
        }
    }
    
    
    static func canPlayBackground()  {
        let session  = AVAudioSession.sharedInstance()
        do{
            
            try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback, options: [])
            
        }catch{
            mylog(error)
        }
        do{
            try session.setActive(true)
            
        }catch{
            mylog(error)
        }
        
        
    }
}
// play deledate
extension DDMediaPlayProtocal{
    // you should invok this method in init method  if you want to know when play end
    func addNotification() {
//        NotificationCenter.default.addObserver(self , selector: #selector(playEnd(notifi:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil )
        
        NotificationCenter.default.addObserver(forName:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil  , queue: OperationQueue.current) {[weak self ] (notification) in
            if let ssss = self{
                var mo = MediaModel()
                if ssss.mediaModels.count > ssss.currentMediaIndex{
                    if let playerItem = notification.object as? AVPlayerItem , let urlAsset = playerItem.asset as? AVURLAsset {
                        if urlAsset.url.absoluteString == ssss.mediaModels[ssss.currentMediaIndex].url?.absoluteString ?? ""{
                            mo = ssss.mediaModels[ssss.currentMediaIndex]
                        }else{
                            mo.url = urlAsset.url
                        }
                    }
                }else{
                    if let playerItem = notification.object as? AVPlayerItem , let urlAsset = playerItem.asset as? AVURLAsset {
                        mo.url = urlAsset.url
                    }
                }
                ssss.endPlayCallback(mediaModel: mo)
            }
        }
//        NotificationCenter.default.addObserver(forName:
//        NSNotification.Name.AVPlayerItemTimeJumped, object: nil  , queue: OperationQueue.current) {[weak self ] (notification) in
//            mylog("jump time \(notification)")
//
//        }
        self.addPeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        // Invoke callback every 1 second
        let interval = CMTime(seconds: 1,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Add time observer
        _ =
            player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) {
                [weak self] time in
                // update player transport UI
                self?.updateTimeWhilePlayingCallback(currentItme: time  , player: self!)
        }
    }
}
