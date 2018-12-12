//
//  SettingManager.swift
//  PHPAPI
//
//  Created by WY on 2018/10/18.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class SettingManager: NSObject {
    static let share = SettingManager()
    var timer : Timer?
    var timeInterval : Int = 6
    
    /// 睡眠时间
    ///
    /// - Parameter timeInterval: 分钟数
    func addTimer(timeInterval:Int) {
        self.removeTimer()
        self.timeInterval  = timeInterval
        //        self.sendCodeBtn.isEnabled = false
        self.timeInterval -= 1
        //        self.sendCodeBtn.setTitle("\(self.timeInterval)秒后重发", for: UIControlState.disabled)
        timer = Timer.init(timeInterval: 60, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func daojishi() {
        self.timeInterval -= 1
        
        if self.timeInterval <= 0 {
            removeTimer()
            abort()
        }else{
            
        }
    }
}
