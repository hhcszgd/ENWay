//
//  SettingVC.swift
//  PHPAPI
//
//  Created by WY on 2018/10/18.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class SettingVC: DDNormalVC {
    let timeButton = UIButton()
    let timeTextfield = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        // Do any additional setup after loading the view.
        configTime()
    }
    func configTime()  {
        self.view.addSubview(timeButton)
        self.view.addSubview(timeTextfield)
        timeTextfield.keyboardType = .numberPad
        timeButton.frame = CGRect(x: self.view.bounds.width - 88, y: DDNavigationBarHeight, width: 64, height: 44)
        timeButton.layer.cornerRadius = 10
        timeButton.layer.masksToBounds = true
        timeButton.backgroundColor = .orange
        timeTextfield.frame = CGRect(x: 20, y: DDNavigationBarHeight, width:  timeButton.frame.minX - 20 - 20, height: 44)
            timeTextfield.placeholder = "请输入睡眠分钟数"
        timeButton.setTitle("睡眠", for: UIControl.State.normal)
        timeButton.addTarget(self , action: #selector(performCountNumber), for: UIControl.Event.touchUpInside)
    }
    @objc func performCountNumber()  {
        if let timeInterval = Int(self.timeTextfield.text ?? "10") {
            SettingManager.share.addTimer(timeInterval: timeInterval)
        }
        self.navigationController?.popViewController(animated: true )
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
