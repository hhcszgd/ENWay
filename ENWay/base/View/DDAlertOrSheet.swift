//
//  DDAlertOrSheet.swift
//  Project
//
//  Created by WY on 2018/8/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit




class DDAlertOrSheet: DDAlertContainer {
    var subviewsContainer = UIView()
    
    lazy var titleLabelBackview  = UIView()
    lazy var titleLabel  = UILabel()
    lazy var messageLabelBackview  = UIView()
    lazy var messageLabel  = UILabel()
    var title: String?
    var message: String?
    
    open var preferredStyle: UIAlertController.Style = .alert
    
    public  init(title: String? = nil , message: String? = nil , preferredStyle: UIAlertController.Style = .alert, actions:[DDAlertAction]){
        super.init(frame: CGRect.zero)
        self._actions = actions
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.addSubview(subviewsContainer)
        subviewsContainer.backgroundColor = UIColor.gray(0.08)
        if title != nil {
            self.title = title
            self.titleLabel.text = title!
            self.titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.darkGray
            titleLabelBackview.addSubview(titleLabel)
            self.subviewsContainer.addSubview(titleLabelBackview)
            //            subviewsContainer.addSubview(titleLabel)
            titleLabel.numberOfLines = 0
            titleLabel.backgroundColor = UIColor.white
            titleLabelBackview.backgroundColor = UIColor.white
        }
        
        if message != nil {
            self.message = message
            self.messageLabel.text = message!
            self.messageLabel.textAlignment = .center
            messageLabel.textColor = UIColor.lightGray
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabelBackview.addSubview(messageLabel)
            self.subviewsContainer.addSubview(messageLabelBackview)
            //            subviewsContainer.addSubview(messageLabel)
            messageLabel.numberOfLines = 0
            messageLabel.backgroundColor = UIColor.white
            messageLabelBackview.backgroundColor = UIColor.white
        }
        for (index,action)  in _actions.enumerated() {
            let button = UIButton()
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            button.setTitle(action._title, for: UIControl.State.normal)
            button.tag = index
            subviewsContainer.addSubview(button)
            actionButtons.append(button)
            button.addTarget(self , action: #selector( buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func buttonAction(sender:UIButton) {
        self._actions[sender.tag].handler?(self._actions[sender.tag])
        if self._actions[sender.tag].isAutomaticDisappear{self.remove()}
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var maxY : CGFloat = 0
        let subviewsContainerW : CGFloat = self.bounds.width - 60
        let rowH : CGFloat = 44
        let borderW : CGFloat = 10
        let margin : CGFloat = 1
        let titleMaxW = subviewsContainerW - borderW  * 2
        
        if self.title != nil {
            var titleLabelH = self.titleLabel.text?.sizeWith(font: self.titleLabel.font, maxWidth: titleMaxW).height ?? 44
            titleLabelH = titleLabelH > 44 ? titleLabelH : 44
            self.titleLabelBackview.frame = CGRect(x: 0, y: 0, width: subviewsContainerW, height: titleLabelH + borderW * 2)//高度是动态的
            self.titleLabel.frame = CGRect(x: borderW, y: borderW, width: titleMaxW, height: titleLabelH)//高度是动态的
            maxY = self.titleLabelBackview.frame.maxY
        }
        if self.message != nil {
            var messageLabelH = self.messageLabel.text?.sizeWith(font: self.messageLabel.font, maxWidth: titleMaxW).height ?? 44
            messageLabelH = messageLabelH > 44 ? messageLabelH : 44
            self.messageLabelBackview.frame = CGRect(x: 0, y: maxY , width: subviewsContainerW, height: messageLabelH + borderW * 2)
            self.messageLabel.frame =  CGRect(x: borderW, y:  borderW, width: titleMaxW, height: messageLabelH)//高度是动态的
            maxY =  self.messageLabelBackview.frame.maxY
        }
        mylog(maxY)
        if _actions.count == 2{// action 横向排列
            if self.preferredStyle == .alert {
                let buttonY = maxY + margin
                for (index , button ) in actionButtons.enumerated(){
                    
                    if index == 0 {
                        button.frame = CGRect(x: 0, y: maxY + margin , width: (subviewsContainerW - margin ) / 2, height: rowH)
                    }else{
                        button.frame = CGRect(x:  subviewsContainerW/2 + margin/2, y: maxY + margin , width:(subviewsContainerW - margin ) / 2, height: rowH)
                    }
                }
                maxY = buttonY + rowH
            }else{
                for button in actionButtons{
                    button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                    maxY = button.frame.maxY
                }
            }
        }else{// action 纵向排列
            for  button  in actionButtons{
                button.frame = CGRect(x: 0, y: maxY + margin , width: subviewsContainerW, height: rowH)
                maxY = button.frame.maxY
            }
        }
        subviewsContainer.bounds = CGRect(x: 0, y: 0, width: subviewsContainerW, height: maxY)
        if self.preferredStyle == .alert {
            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }else{
            self.subviewsContainer.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - self.subviewsContainer.bounds.height/2 - 20)
        }
        self.subviewsContainer.embellishView(redius: 10)
    }

    
}

