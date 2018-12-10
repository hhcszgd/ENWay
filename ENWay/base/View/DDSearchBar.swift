//
//  DDSearchBar.swift
//  Project
//
//  Created by WY on 2018/10/16.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit

class DDSearchBar: UIView {
    private let searchIcon = UIImageView()
    let textField = DDTextField()
//    let clearButton = UIButton()
    var doneAction : ((String?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white 
//        self.addSubview(searchIcon)
        self.addSubview(textField)
//        self.addSubview(clearButton)
        textField.clearButtonMode = .always
        textField.leftViewMode = .always
//        searchIcon.backgroundColor = UIColor.red
        searchIcon.image = UIImage(named: "search")
//        clearButton.setImage(UIImage(named: ""), for: UIControl.State.normal)
//        clearButton.adjustsImageWhenHighlighted = false
        textField.delegate = self
        textField.returnKeyType = .search
        textField.placeholder = "搜索店铺"
        textField.leftView = searchIcon
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        self.textField.frame = CGRect(x:  margin, y: margin, width: self.bounds.width -  margin * 2, height: self.bounds.height - margin * 2)
        let clearButtonToRightBorder : CGFloat = 13
        let searchIconWH = self.bounds.height - clearButtonToRightBorder * 2
       searchIcon.frame = CGRect(x: 30, y: 0, width: searchIconWH, height: searchIconWH)
//        if clearButton.isHidden {
//            self.textField.frame = CGRect(x: searchIcon.frame.maxX + margin, y: 0, width: self.bounds.width - self.searchIcon.frame.maxX - margin * 2, height: self.bounds.height)
//        }else{
//            let clearButtonToRightBorder : CGFloat = 10
//            let searchIconWH = self.bounds.height - clearButtonToRightBorder * 2
//            self.clearButton.frame = CGRect(x: self.bounds.width - clearButtonToRightBorder - searchIconWH, y: clearButtonToRightBorder, width: searchIconWH, height: searchIconWH)
//            self.textField.frame = CGRect(x: searchIcon.frame.maxX + margin, y: 0, width: clearButton.frame.minX - self.searchIcon.frame.maxX - margin * 2, height: self.bounds.height)
//        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class DDTextField: UITextField {
//        override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//            return CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
//        }
        override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
            let superRect = super.clearButtonRect(forBounds: bounds)
            return superRect
        }
//        open override func borderRect(forBounds bounds: CGRect) -> CGRect{
//            let superRect = super.borderRect(forBounds: bounds)
//            return CGRect(origin: CGPoint(x: superRect.origin.x + 10, y: superRect.origin.y), size: CGSize(width: superRect.size.width - 10, height: superRect.size.height))
//        }
        open override  func editingRect(forBounds bounds: CGRect) -> CGRect{
            let superRect = super.editingRect(forBounds: bounds)
            return CGRect(origin: CGPoint(x: superRect.origin.x + 10, y: superRect.origin.y), size: CGSize(width: superRect.size.width - 10, height: superRect.size.height))
        }
        open  override func textRect(forBounds bounds: CGRect) -> CGRect{
            let superRect = super.textRect(forBounds: bounds)
            return CGRect(origin: CGPoint(x: superRect.origin.x + 10, y: superRect.origin.y), size: CGSize(width: superRect.size.width - 10, height: superRect.size.height))
        }
        
        open override  func placeholderRect(forBounds bounds: CGRect) -> CGRect{
            let superRect = super.placeholderRect(forBounds: bounds)
            return CGRect(origin: CGPoint(x: superRect.origin.x + 10, y: superRect.origin.y), size: CGSize(width: superRect.size.width - 10, height: superRect.size.height))
        }
        
        
    }
    deinit {
        mylog("DDSearchBar destroyed")
    }
}
extension DDSearchBar : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason){
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.doneAction?(textField.text)
        textField.endEditing(true)
        return true
    }
}
