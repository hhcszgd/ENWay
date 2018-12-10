//
//  DDNewFeature.swift
//  Project
//
//  Created by WY on 2018/1/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDNewFeature: DDNormalVC {
    var collection : UICollectionView!
    let imageView = UIImageView()
    let jumpButton = UIButton()
    var isNewVersion = false
    let images  = ["feature1" , "feature2" ,"feature3"]
    var done  : (() -> ())?
    var timer : CADisplayLink?
    let timeBackView = UIView()
    var timeinterval : TimeInterval = 0
    let totalTime : TimeInterval = 5
    convenience init(isNewVersion:Bool){
        self.init()
        self.isNewVersion = isNewVersion
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewVersion {
            //new feature
            self.configCollectionView()
        }else{
            // welcom
            self.view.addSubview(imageView)
            self.view.addSubview(timeBackView)
            self.view.addSubview(jumpButton)
            self.imageView.frame = self.view.bounds
            self.imageView.image = UIImage(named:"addImage")
            let buttonWH : CGFloat = 50
            jumpButton.frame = CGRect(x: self.view.bounds.width - buttonWH - 20, y: DDStateBarHeight + buttonWH, width: buttonWH, height: buttonWH)
            jumpButton.addTarget(self , action: #selector(enterButtonClick(sender:)), for: UIControl.Event.touchUpInside)
            
            jumpButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            jumpButton.setTitle("跳过", for: UIControl.State.normal)
            jumpButton.layer.cornerRadius = buttonWH/2
            jumpButton.layer.masksToBounds = true
            let borderW : CGFloat = 0
            timeBackView.frame = CGRect(x: jumpButton.frame.minX - borderW, y: jumpButton.frame.minY - borderW, width: jumpButton.frame.width + borderW * 2, height: jumpButton.frame.height + borderW  * 2)
            self.addTimer()
        }
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.invalidTimer()
    }
    @objc func startDraw() {
        timeinterval += 1
        let scale = (timeinterval/60) / totalTime
        mylog(scale)
        if scale >= 1 {
            invalidTimer()
            self.enterButtonClick(sender: self.jumpButton)
        }
        let angle = Double.pi * 2 * scale
//        mylog(angle)
        let layer = CAShapeLayer.init()
        layer.lineWidth = 2;
        //圆环的颜色
        layer.strokeColor = UIColor.orange.cgColor;
        //背景填充色
        layer.fillColor = UIColor.clear.cgColor;
        //初始化一个路径
        let  path = UIBezierPath(arcCenter: CGPoint(x: timeBackView.bounds.width/2, y: timeBackView.bounds.width/2), radius: timeBackView.bounds.width/2 , startAngle: -CGFloat(Double.pi / 2), endAngle:CGFloat(angle) -  CGFloat(Double.pi / 2), clockwise: true)
        
        layer.path = path.cgPath
        self.timeBackView.layer.addSublayer(layer )
    }
    @objc func endDraw() {
        
    }
    func addTimer()  {
        self.invalidTimer()
        timer = CADisplayLink.init(target: self, selector: #selector(startDraw))
        timer?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
//        timer = Timer.init(timeInterval: 5, target: self, selector: #selector(startDraw), userInfo: nil , repeats: true )
//        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    func invalidTimer() {
        self.endDraw()
        if let tempTimer  = timer {
            tempTimer.invalidate()
            timer = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: false )
    }
    func configCollectionView() {
//        let collectionFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        let collectionFrame = self.view.bounds
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: self.view.bounds.width , height: collectionFrame.height)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collection  = UICollectionView.init(frame: collectionFrame, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        self.collection.bounces = false
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.view.addSubview(self.collection)
        self.collection.alwaysBounceHorizontal = false
        self.collection.isPagingEnabled = true
        self.collection.delegate = self
        self.collection.dataSource = self
        
        //        self.collection.isScrollEnabled = false//
        
        //        self.collection.register(DDCreateConventionSimple.self , forCellWithReuseIdentifier: "DDCreateConventionSimple")
        
        self.collection.register(DDNewFeatureItem.self , forCellWithReuseIdentifier: "DDNewFeatureItem")
        self.collection.reloadData()
    }
    class DDNewFeatureItem: UICollectionViewCell {
        let button = UIButton()
        weak var delegate : DDNewFeatureItemDelegate?
        var urlStr : String = ""{
            didSet{
//                if let url  = URL(string:urlStr) {
//                    imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
//                }else{
                imageView.image = UIImage(named:urlStr)
//                }
            }
        }
        
        let imageView = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundView = imageView
            self.contentView.addSubview(button)
//            button.setTitle("进入", for: UIControl.State.normal)
            button.backgroundColor = .orange
            button.addTarget(self , action: #selector(enterButtonClick(sender:)), for: UIControl.Event.touchUpInside)
            button.backgroundColor = .clear
        }
        @objc func enterButtonClick(sender:UIButton){
            self.delegate?.enterButtonClick(sender: sender)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let btnW : CGFloat = 168
            let btnH : CGFloat = 64
            
            self.button.frame = CGRect(x: self.bounds.width/2 - btnW/2, y: self.bounds.height - 100 * SCALE, width: btnW , height: btnH )
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    deinit {
        mylog("new feature destroied")
    }

}
protocol DDNewFeatureItemDelegate : NSObjectProtocol{
    func enterButtonClick(sender:UIButton)
}
extension DDNewFeature : UICollectionViewDelegate , UICollectionViewDataSource , DDNewFeatureItemDelegate{
    
    @objc func enterButtonClick(sender:UIButton) {
        mylog("enter")
        self.done?()
    }
    func didSelectRowAt(indexPath: IndexPath, isLeft: Bool) {
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collection.dequeueReusableCell(withReuseIdentifier: "DDNewFeatureItem", for: indexPath)
        if let itemUnwrap = item as? DDNewFeatureItem{
            itemUnwrap.urlStr = images[indexPath.item]
            if indexPath.item == images.count - 1{
                itemUnwrap.button.isHidden = false
                itemUnwrap.delegate = self
            }else{
                itemUnwrap.button.isHidden = true
            }
        }
        item.backgroundColor = UIColor.random
        return item

    }
}
