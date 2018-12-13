//
//  DDPlayerControlBar.swift
//  ENWay
//
//  Created by WY on 2018/12/13.
//  Copyright © 2018 WY. All rights reserved.
//

import UIKit
enum DDPlayerControlBarStyle : Int  {
    case smallScreen = 0
    case fullScreen
}
protocol DDPlayerControlDelegate : NSObjectProtocol{
    func screenChanged(isFullScreen:Bool)
    func sliderChanged(sender:DDSlider)
    func pressToPlay()
    func pressToPause()
}

class DDPlayerControlBar: UIView {
    var style : DDPlayerControlBarStyle = .smallScreen{
        didSet{
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    let playButton = UIButton()
    let slider = DDSlider()
    private var currentItemTotalTime : Double = 0
    internal let fullScreenButton = UIButton()
    private var tapCount : Int = 0
    weak var delegate : DDPlayerControlDelegate?
    private var hasPlayedTimeLabel : UILabel = UILabel()
    private var leftTimeLabel : UILabel = UILabel()
    private var fullScreenTimeLabel : UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        _addsubViews()
    }
    func _addsubViews()  {
        
        self.addSubview(playButton)
        self.addSubview(slider)
        self.addSubview(fullScreenButton)
        
        self.addSubview(hasPlayedTimeLabel)
        self.addSubview(leftTimeLabel)
        self.addSubview(fullScreenTimeLabel)
        //        fullScreenButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        playButton.imageEdgeInsets =  UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        fullScreenButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //        fullScreenButton.contentVerticalAlignment = .fill
        //        fullScreenButton.contentHorizontalAlignment = .fill
        //        playButton.imageView?.contentMode = .scaleAspectFill
        //        fullScreenButton.imageView?.contentMode = .scaleAspectFill
        hasPlayedTimeLabel.font = GDFont.systemFont(ofSize: 14)
        leftTimeLabel.font = GDFont.systemFont(ofSize: 14)
        fullScreenTimeLabel.font = GDFont.systemFont(ofSize: 14)
        hasPlayedTimeLabel.textAlignment = .center
        leftTimeLabel.textAlignment = .center
        fullScreenTimeLabel.textAlignment = .center
        
        hasPlayedTimeLabel.textColor = UIColor.white
        leftTimeLabel.textColor = UIColor.white
        fullScreenTimeLabel.textColor = UIColor.white
        
        slider.addTarget(self , action: #selector(sliderChanged(sender:)), for: UIControl.Event.valueChanged)
        fullScreenButton.setTitle("next", for: UIControl.State.normal)//full screen
        fullScreenButton.setTitle("next", for: UIControl.State.selected)//not full screen
        playButton.setTitle("播放", for: UIControl.State.normal)//play
        playButton.setTitle("暂停", for: UIControl.State.selected)//pause
        //        fullScreenButton.setImage(UIImage(named:"fullscreenbutton"), for: UIControlState.normal)
        //        fullScreenButton.setImage(UIImage(named:"shrinkscreen"), for: UIControlState.selected)
        //        playButton.setImage(UIImage(named:"playbutton"), for: UIControlState.normal)
        //        playButton.setImage(UIImage(named:"stopbutton"), for: UIControlState.selected)
        playButton.addTarget(self , action: #selector(playButtonAction(sender:)), for: UIControl.Event.touchUpInside)
        //        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        fullScreenButton.addTarget(self , action: #selector(fullScreenButtonAction(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func sliderChanged(sender:DDSlider){
        self.delegate?.sliderChanged(sender: sender)
    }
    @objc func playButtonAction(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.delegate?.pressToPlay()
        }else{
            self.delegate?.pressToPause()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonToBorder : CGFloat = 0
        let buttonY = buttonToBorder
        let buttonH = self.bounds.height - buttonToBorder * 2
        let buttonToScreen : CGFloat = 20
        leftTimeLabel.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        let smallScreenTimeLabelWidth : CGFloat = leftTimeLabel.bounds.width
        
        hasPlayedTimeLabel.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        let smallScreenHasPlayedTimeLabelWidth : CGFloat = hasPlayedTimeLabel.bounds.width
        switch style {
        case .smallScreen:
            playButton.frame = CGRect(x: buttonToScreen, y: buttonY,width: buttonH, height: buttonH)
            fullScreenButton.frame = CGRect(x: self.bounds.width - (buttonToScreen + buttonH), y: buttonY,width: buttonH, height: buttonH)
            
            
            hasPlayedTimeLabel.frame = CGRect(x: playButton.frame.maxX , y: buttonY,width: smallScreenHasPlayedTimeLabelWidth, height: buttonH)
            leftTimeLabel.frame = CGRect(x: fullScreenButton.frame.minX - smallScreenTimeLabelWidth, y: buttonY,width: smallScreenTimeLabelWidth, height: buttonH)
            fullScreenTimeLabel.isHidden = true
            hasPlayedTimeLabel.isHidden = false
            leftTimeLabel.isHidden = false
            let sliderLeftRightMargin : CGFloat = 1
            let sliderH : CGFloat = 26
            slider.frame =  CGRect(x: hasPlayedTimeLabel.frame.maxX + sliderLeftRightMargin, y: self.bounds.height/2 - sliderH/2,width: leftTimeLabel.frame.minX - (hasPlayedTimeLabel.frame.maxX + sliderLeftRightMargin * 2), height: sliderH)
            //            slider.center = CGPoint(x:self.bounds.width/2  , y : self.bounds.height/2)
            
        case .fullScreen:
            fullScreenTimeLabel.isHidden = false
            hasPlayedTimeLabel.isHidden = true
            leftTimeLabel.isHidden = true
            playButton.frame = CGRect(x: buttonToScreen, y: buttonY,width: buttonH, height: buttonH)
            fullScreenButton.frame = CGRect(x: self.bounds.width - (buttonToScreen + buttonH), y: buttonY,width: buttonH, height: buttonH)
            
            let sliderLeftRightMargin : CGFloat = 10
            slider.bounds =  CGRect(x: 0, y: 0,width: fullScreenButton.frame.minX - (playButton.frame.maxX + sliderLeftRightMargin * 2), height: 40)
            slider.center = CGPoint(x:self.bounds.width/2  , y : playButton.frame.minY)
            fullScreenTimeLabel.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            fullScreenTimeLabel.frame = CGRect(x: slider.frame.minX, y: playButton.frame.midY, width: fullScreenTimeLabel.bounds.width, height: playButton.bounds.height/2)
            
        }
    }
    func configSlider(minimumValue:Float ,maximumValue : Float){
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
    }
    func configSliderValue(value : Float){
        let value = value.isNaN ? 0 : value
        slider.value = value
        let hasPlayHours = Int(value) / 3600
        let hasPlayHoursString = String(format: "%02d", hasPlayHours)
        
        let hasPlayMinuts = (Int(value) % 3600) / 60
        let hasPlayMinutsString = String(format: "%02d", hasPlayMinuts)
        
        let hasPlaySeconds = (Int(value) % 60)
        let hasPlaySecondsString = String(format: "%02d", hasPlaySeconds)
        
        let leftPlayHours = Int(slider.maximumValue - value) / 3600
        let leftPlayHoursString = String(format: "%02d", leftPlayHours)
        
        let leftPlayMinuts = (Int(slider.maximumValue - value) % 3600) / 60
        let leftPlayMinutsString = String(format: "%02d", leftPlayMinuts)
        
        let leftPlaySeconds = (Int(slider.maximumValue - value) % 60)
        let leftPlaySecondsString  = String(format: "%02d", leftPlaySeconds)
        
        let totalPlayHours = Int(slider.maximumValue ) / 3600
        let totalPlayHoursString = String(format: "%02d", totalPlayHours)
        
        let totalPlayMinuts = (Int(slider.maximumValue) % 3600) / 60
        let totalPlayMinutsString = String(format: "%02d", totalPlayMinuts)
        
        let totalPlaySeconds = (Int(slider.maximumValue) % 60)
        let totalPlaySecondsString = String(format: "%02d", totalPlaySeconds)
        //        let hasPlayStr = hasPlayHours == 0 ? "\(hasPlayMinuts):\(hasPlaySeconds)" : "\(hasPlayHours):\(hasPlayMinuts):\(hasPlaySeconds)"
        let hasPlayStr = hasPlayHours == 0 ? "\(hasPlayMinutsString):\(hasPlaySecondsString)" : "\(hasPlayHoursString):\(hasPlayMinutsString):\(hasPlaySecondsString)"
        let leftStr =  leftPlayHours == 0 ? "\(leftPlayMinutsString):\(leftPlaySecondsString)" : "\(leftPlayHoursString):\(leftPlayMinutsString):\(leftPlaySecondsString)"
        let totalStr =  totalPlayHours == 0 ? "\(totalPlayMinutsString):\(totalPlaySecondsString)" : "\(totalPlayHoursString):\(totalPlayMinutsString):\(totalPlaySecondsString)"
        self.hasPlayedTimeLabel.text = hasPlayStr
        self.leftTimeLabel.text = leftStr
        self.fullScreenTimeLabel.text = "\(hasPlayStr)/\(totalStr)"
        self.leftTimeLabel.sizeToFit()
        self.fullScreenTimeLabel.sizeToFit()
        layoutIfNeeded()
        setNeedsLayout()
    }
    @objc func fullScreenButtonAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{//
            //            self.style = .fullScreen
            self.delegate?.screenChanged(isFullScreen: true )
            rootNaviVC?.setNeedsStatusBarAppearanceUpdate()
        }else{//小屏
            //            self.style = .smallScreen
            self.delegate?.screenChanged(isFullScreen: false  )
        }
    }
    func updateTime(time:TimeInterval) {
        
    }
    func configUIWhenPause() {
        self.playButton.isSelected = false
    }
    func configUIWhenPlaying() {
        self.playButton.isSelected = true
    }
    func configUIWhenPlayEnd() {
        UIView.animate(withDuration: 1, animations: {
            self.isHidden = false
        })
        self.playButton.isSelected = false
        self.slider.value = 0.0
    }
    func perfomrTap() {
        
        if self.isHidden{
            UIView.animate(withDuration: 1, animations: {
                self.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 1, animations: {
                self.isHidden = true
            })
        }
    }
}
