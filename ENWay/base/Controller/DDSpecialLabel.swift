//
//  DDSpecialLabel.swift
//  Project
//
//  Created by WY on 2018/2/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSpecialLabel: UIView {
    enum DDShouldDirection {
        case left
        case right
    }
    private var timer : CADisplayLink?
    let label:UILabel = UILabel()
    private var dynamicX : CGFloat = 0
    private var priviousX : CGFloat = 0
    private var direction = DDShouldDirection.left
    private var timeMargin : CGFloat = 0.4
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.textAlignment = .center
        self.isUserInteractionEnabled = false
    }
    override func removeFromSuperview(){
        super.removeFromSuperview()
        self.invalidTimer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        label.sizeToFit()
        label.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        dynamicX = -timeMargin //先左偏
        self.invalidTimer()
        if label.bounds.size.width > self.bounds.width {
            label.frame = CGRect(x: 0, y: 0, width: label.bounds.width, height: self.bounds.height)
            addTimer()
        }else{ label.frame = self.bounds}
    }
    func addTimer()  {
        self.invalidTimer()
        timer = CADisplayLink.init(target: self, selector: #selector(scroll))
        timer?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    @objc func scroll()  {
        if dynamicX <= -(self.label.bounds.size.width - self.bounds.size.width) {
            dynamicX = -(self.label.bounds.size.width - self.bounds.size.width - timeMargin)
            priviousX = -(self.label.bounds.size.width - self.bounds.size.width)
            direction = .right
        }else if dynamicX > -(self.label.bounds.size.width - self.bounds.size.width) && dynamicX < 0{
            if self.direction == .left {//向左
                dynamicX -= timeMargin
            }else  if self.direction == .right{
                dynamicX += timeMargin
            }
            priviousX = dynamicX
        }else if dynamicX >= 0{ // > 0  的情况
            dynamicX = -timeMargin
            priviousX = 0
            direction = .left
        }
        label.frame = CGRect(x: dynamicX, y: 0, width: label.bounds.width, height: self.bounds.height)
    }
    private func invalidTimer() {
        if let tempTimer  = timer {
            tempTimer.invalidate()
            timer = nil
        }
    }
    deinit { self.invalidTimer() }
}
