//
//  DDUpDownAutoScroll.swift
//  Project
//
//  Created by WY on 2017/12/1.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit



protocol DDUpDownAutoScrollDelegate: NSObjectProtocol {
  func performMsgAction(indexPath : IndexPath)
}

class DDUpDownAutoScroll: UIView , UICollectionViewDelegate , UICollectionViewDataSource{
    enum GDAlignment {
        case center
        case left
        case right
    }
    
    var models  : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            self.collectionView.reloadData()
            stopAutoScroll()
            if models.count >  1 {
                addTimer()
            }
        }
    }
    weak var delegate : DDUpDownAutoScrollDelegate?
    var timer : Timer?
    
    var collectionView : UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareSubviews()
    }
    func addTimer()  {
        self.invalidTimer()
        timer = Timer.init(timeInterval: 5, target: self, selector: #selector(startAutoScroll), userInfo: nil , repeats: true )
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    func invalidTimer() {
        self.stopAutoScroll()
        if let tempTimer  = timer {
            tempTimer.invalidate()
            timer = nil
        }
    }
    func stopAutoScroll() {
    }
    deinit {
        self.invalidTimer()
    }
//    @objc func startAutoScroll() {
//        guard let flowLayout =  collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
//        let currentContentOffset = collectionView.contentOffset
//        let itemSize = flowLayout.itemSize
//        if currentContentOffset.x >= itemSize.width * CGFloat(models.count) * 2 {
//            collectionView.setContentOffset(CGPoint(x: currentContentOffset.x -  itemSize.width * CGFloat(models.count) , y: 0), animated: false  )
//        }
//        let newCurrentContentOffset = collectionView.contentOffset
//        let nextContentOffset = CGPoint(x:  newCurrentContentOffset.x + itemSize.width, y: 0)
//        //        mylog("当前下标\(currentContentOffset.x / itemSize.width )")
//        collectionView.setContentOffset(nextContentOffset, animated: true )
//    }
    @objc func startAutoScroll() {
        guard let flowLayout =  collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        let currentContentOffset = collectionView.contentOffset
        let itemSize = flowLayout.itemSize
        if currentContentOffset.y >= itemSize.height * CGFloat(models.count) * 2 {
            collectionView.setContentOffset(CGPoint(x: 0 , y: currentContentOffset.y -  itemSize.height * CGFloat(models.count)), animated: false  )
        }
        let newCurrentContentOffset = collectionView.contentOffset
        let nextContentOffset = CGPoint(x:  0, y: newCurrentContentOffset.y + itemSize.height)
        //        mylog("当前下标\(currentContentOffset.x / itemSize.width )")
        collectionView.setContentOffset(nextContentOffset, animated: true )
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.invalidTimer()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.addTimer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func prepareSubviews() {
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout.init())
        self.addSubview(collectionView)
        
        self.collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(Item.self , forCellWithReuseIdentifier: "GDAutoScrollViewItem")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupCollectionFrame()
    }
    func setupCollectionFrame()  {
        collectionView.frame = self.bounds
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize =  self.collectionView.bounds.size
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return models.count * 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actionModel = DDHomeMsgModel()
        let dataModel = models[indexPath.item % models.count]
//        actionModel.keyparamete = (dataModel.title ?? "" ) as AnyObject
        self.delegate?.performMsgAction(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GDAutoScrollViewItem", for: indexPath)
        let itemIndex  = indexPath.item % models.count
        if let realItem  = item as? Item {
            realItem.model = models[itemIndex]
//            realItem.label.text = "数组取值时Index : \(itemIndex) ,真实currentIndex : \(indexPath.item)"
            
        }
        //        mylog("数组取值时Index : \(itemIndex)")
        //        mylog("真是currentIndex : \(indexPath.item)")
        return item
    }
    
    class Item : UICollectionViewCell {
        let label = UILabel.init(frame: CGRect.zero)
        var model : DDHomeMsgModel?{
            didSet{
                let hd_title = model?.title ?? ""
//                let id  = model?.id  ?? ""
//                let arr = [ hd_title , id]
                label.text = hd_title
//                let attributedString = arr.setColor(colors: [UIColor.red , UIColor.green ])
//                label.attributedText = attributedString
//                mylog(model?.imageUrl)
//                if let url  =  URL(string:  model?.imageUrl ?? "") {
//                    imageView.sd_setImage(with: url)
//                    self.layoutIfNeeded()
                
//                }
                
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame )
            self.prepareSubviews()
            label.textColor = UIColor.lightGray
            label.font = GDFont.systemFont(ofSize: 13)
//            self.backgroundColor = UIColor.randomColor()
        }
        func prepareSubviews() {
            self.contentView.addSubview(self.label)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            label.frame = self.bounds
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


