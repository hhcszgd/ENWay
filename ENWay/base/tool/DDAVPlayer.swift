//
//  DDAVPlayer.swift
//  ENWay
//
//  Created by WY on 2018/12/10.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
class DDAVPlayer: NSObject {
    let player : AVPlayer = AVPlayer(playerItem: nil )
    static let share : DDAVPlayer =  {
        let p = DDAVPlayer()
        return p
    }()
    var musics : [MusicModel]?
    var pdfModels : [MusicModel]?
    var currentMusicIndex = -1111
    override init() {
        super.init()
        self.setupLockScreen()
    }
    
    /// 后两个参数只在第一次调用时传 即可
    func playMusic1()  {
        //        if let value = musicArr{self.musics = value}
        //        if let value = pdfModels{self.pdfModels = value}
        //        var musicName = ""
        //
        //        if musicArr != nil && musicArr!.count > 0 {
        //            self.musics = musicArr
        //            musicName = self.musics?[currentNusicIndex].name ?? ""
        //        }
        //        musicName = self.musics?[currentNusicIndex].name ?? ""
        //        self.performPlay(musicName: musicName)
        
        self.playWith(url: self.musics?[currentMusicIndex].url)
        
        
    }
    
    func audioPlayerDidFinishPlaying( successfully flag: Bool){
        self.nextSong()
        NotificationCenter.default.post(name:  Notification.Name("ReloadPdfNotification"), object: self)
    }
    
}
/// play control
extension DDAVPlayer{
    func stop() {
        self.player.pause()
    }
}
/// config 
extension DDAVPlayer{
    func setupLockScreen(){
        let commandCenter = MPRemoteCommandCenter.shared()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "1111"]//要显示的歌名
        
        commandCenter.nextTrackCommand.isEnabled = true//下一曲
        commandCenter.nextTrackCommand.addTarget(self, action:#selector(nextSong))
        
        commandCenter.previousTrackCommand.isEnabled = true//上一曲
        commandCenter.previousTrackCommand.addTarget(self , action: #selector(priviousSong))
        
        commandCenter.pauseCommand.isEnabled = true//暂停
        commandCenter.pauseCommand.addTarget(self , action: #selector(pauseSong))
        
        commandCenter.playCommand.isEnabled = true//播放
        commandCenter.playCommand.addTarget(self , action: #selector(playSongControlFromBackground))
        
        //        commandCenter.skipForwardCommand.isEnabled = true//快进
        //        commandCenter.skipForwardCommand.addTarget(self , action: #selector(skipForwardAction(sender:)))
        //
        //        commandCenter.skipBackwardCommand.isEnabled = true//快退
        //        commandCenter.skipBackwardCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        
        commandCenter.changePlaybackRateCommand.isEnabled = true//
        commandCenter.changePlaybackRateCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        
        
        commandCenter.changePlaybackRateCommand.isEnabled = true//
        commandCenter.changePlaybackRateCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        commandCenter.changeRepeatModeCommand.isEnabled = true//
        commandCenter.changeRepeatModeCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        commandCenter.changeShuffleModeCommand.isEnabled = true//
        commandCenter.changeShuffleModeCommand.addTarget(self , action: #selector(skipBackforwardAction(sender:)))
        
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.addTarget { (event ) -> MPRemoteCommandHandlerStatus in
            
            mylog(event)
            return MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        //        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPositionAction(sender:)))
        commandCenter.changePlaybackPositionCommand.addTarget {[weak self] (event ) -> MPRemoteCommandHandlerStatus in
            if let eventPosition = event as? MPChangePlaybackPositionCommandEvent{
                mylog(eventPosition.positionTime)
                
                self?.player.seek(to: CMTime(seconds: eventPosition.positionTime, preferredTimescale: CMTimeScale(1)), completionHandler: { (bool ) in
                    
                })
//                self?.player.playImmediately(atRate: 1)
                if let url = self?.musics?[self?.currentMusicIndex ?? 0].url{
                    let musicName = url.lastPathComponent + ".\(url.pathExtension)"
                    self?.configureNowPlayingInfo(musicName:musicName)
                }
            }
            
            return  MPRemoteCommandHandlerStatus.success
        }
        
    }
    
    
    
    func changedThumbSliderOnLockScreen(event :MPChangePlaybackPositionCommandEvent ) -> MPRemoteCommandHandlerStatus{
        //        [self setCurrentPlaybackTime:event.positionTime];
        // update  MPNowPlayingInfoPropertyElapsedPlaybackTime
        //        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        return .success;
        
    }
    
    
    
    func configureNowPlayingInfo(musicName:String) {
//        mylog(self.player!.duration)
//        mylog(self.player!.currentTime)
//        mylog(self.player!.deviceCurrentTime)
        let nowPlayingInfo = [MPMediaItemPropertyTitle: musicName,
                              MPMediaItemPropertyPlaybackDuration: (self.player.currentItem?.duration ?? CMTime.zero).value,
                              MPNowPlayingInfoPropertyElapsedPlaybackTime: self.player.currentTime,
                              MPNowPlayingInfoPropertyPlaybackRate: Double(self.player.rate),
                              MPMediaItemPropertyMediaType: MPMediaType.movie.rawValue] as [String : Any]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        //        if let image = media.mediumCoverImage ?? media.mediumBackgroundImage, let request = try? URLRequest(url: image, method: .get) {
        //            ImageDownloader.default.download(request) { (response) in
        //                guard let image = response.result.value else { return }
        //                if #available(iOS 10.0, tvOS 10.0, *) {
        //                    self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
        //                        return image
        //                    }
        //                } else {
        //                    self.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
        //                }
        //            }
        //        }
    }
    @objc func changePlaybackPositionAction(sender:MPChangePlaybackPositionCommandEvent){
        dump(sender)
        mylog("positionTime : \(sender.positionTime)||| timestamp: \(sender.timestamp) ")
        
    }
    
    @objc func changePlaybackRateAction(sender:Any){
        dump(sender)
    }
    @objc func changeRepeatModeAction(sender:Any){
        dump(sender)
    }
    
    
    @objc func changeShuffleAction(sender:Any){
        dump(sender)
    }
    
    
    
    @objc func skipForwardAction(sender:MPSkipIntervalCommandEvent){
        dump(sender)
    }
    
    @objc func skipBackforwardAction(sender:MPSkipIntervalCommandEvent){
        dump(sender)
    }
    
    
    @objc func nextSong()
    {
        self.currentMusicIndex += 1
        if musics?.count ?? 0 > 0 && self.currentMusicIndex >= musics!.count {
            self.currentMusicIndex = 0
        }
        self.playMusic(currentNusicIndex: self.currentMusicIndex)
        mylog("dddddddddddddd")
    }
    @objc func priviousSong()
    {
        self.currentMusicIndex -= 1
        if  (musics?.count ?? 0 ) > 0 && currentMusicIndex < 0   {
            currentMusicIndex = musics!.count - 1
        }
        self.playMusic(currentNusicIndex: self.currentMusicIndex)
        
        mylog("dddddddddddddd")
    }
    func playMusic(currentNusicIndex:Int , musicArr: [MusicModel]? = nil )  {
        self.playWith(url: self.musics?[currentMusicIndex].url)
    }
    func playWith(url:URL?) {
        guard let url = url  else {
            return
        }
        //        var  docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //        docuPath = docuPath + "/\(musicName)"
        //        player?.stop()
        //        let url = URL(fileURLWithPath: docuPath)
        let musicName = url.lastPathComponent + ".\(url.pathExtension)"
        let avplayitem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: avplayitem)
//        let p = try? AVAudioPlayer.init(contentsOf: url )
        
//        p?.delegate = self
//        self.player = p
        configureNowPlayingInfo(musicName:musicName)
        self.player.play()
//        p?.play()
        
    }
    
    @objc func pauseSong()
    {
        mylog("pauseSong")
    }
    
    @objc func playSongControlFromBackground()
    {
        mylog("playSongContro lFromBackground")
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
