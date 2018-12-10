//
//  GDIBContentView.swift
//  zjlao
//
//  Created by WY on 04/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDIBContentView: UIView {
    let collection  : GDIBCollectionView = GDIBCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    //control
    let cancleButton = UIButton()
    let pageIndicater = UILabel()
    //aboutPages
    var previousOffset : CGPoint = CGPoint.zero
    var showingPage : Int  = 0 {
        didSet{
            let currentPage = "\(showingPage + 1)"
            let totalPage = "/\(self.photos.count)"
            let showStr = currentPage + totalPage
            let attStr = NSMutableAttributedString.init(string: showStr)
            
            attStr.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Bold", size: 29) ?? GDFont(), range: NSRange.init(location: 0, length: currentPage.characters.count) )
            self.pageIndicater.attributedText = attStr
        }
    }
    
    //ui
    fileprivate var applicationWindow: UIWindow!
    //data
    var photos : [GDIBPhoto] = [GDIBPhoto](){
        didSet{
            
            self.collection.reloadData()
            if showingPage < photos.count && showingPage >= 0  && self.superview != nil {
                self.collection.scrollToItem(at: IndexPath(item: self.showingPage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    //override
    override init(frame: CGRect) {
        super.init(frame: frame)
        configWindow()
        configCollectionView()
        setControlViews()
    }
    convenience init(photos : [GDIBPhoto] , showingPage : Int = 0){//构造方法中给属性赋值,不会触发属性检测器(willSet和didSet)
        mylog(showingPage)
        self.init(frame: CGRect.zero)
        var newPhotos = [GDIBPhoto]()
        
        photos.forEach { (photo ) in
            if let _ = photo.image{
                newPhotos.append(photo)
            }else if let urlStr = photo.imageURL , let _ = URL(string: urlStr){
                newPhotos.append(photo)
            }else if let _ = photo.imagePath{
                newPhotos.append(photo)
            }else if let _ = photo.asset{
                newPhotos.append(photo)
            }else{
                mylog("有异常图片")
            }
        }
        
        
        
        
        self.photos = self.createData(photos: newPhotos)
        self.showingPage = showingPage
//        mylog(photos)
//        mylog(self.showingPage)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mylog("调用频率")
        self.collection.reloadData()
        if showingPage < photos.count && showingPage >= 0 {
            self.collection.scrollToItem(at: IndexPath(item: showingPage, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            
            let a = showingPage
            showingPage = a
            
            
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1 
        }
    }
    deinit {
        mylog("图片浏览器销毁了")
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancle()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
// MARK: 注释 : control
extension GDIBContentView {
    func setControlViews()  {
        self.addSubview(cancleButton)
        cancleButton.frame = CGRect(x: 20, y: DDNavigationBarHeight - 44, width: 44, height: 44)
//        cancleButton.setImage(UIImage(), for: UIControl.State.normal)
        cancleButton.setTitle("关闭", for: UIControl.State.normal)
        cancleButton.addTarget(self , action: #selector(cancle), for: UIControl.Event.touchUpInside)
        cancleButton.setTitleColor(UIColor.DDLightGray1, for: UIControl.State.normal)
        self.addSubview(pageIndicater)
        pageIndicater.frame = CGRect(x: UIScreen.main.bounds.size.width - 88 - 20, y: UIScreen.main.bounds.size.height - 44 * 2, width: 88, height: 44)
        pageIndicater.textColor = UIColor.white
        pageIndicater.textAlignment  =  NSTextAlignment.right
        pageIndicater.isHidden = true 
    }
    @objc func cancle()  {
        self.removeFromSuperview()
    }
    
    @objc func open() {
        
    }
}

// MARK: 注释 : setAboutCollection

extension GDIBContentView {
    func configWindow()  {
        self.backgroundColor = UIColor.black
        if let window = UIApplication.shared.delegate?.window {
            applicationWindow = window
            applicationWindow.addSubview(self)
            self.frame = applicationWindow.bounds
        } else if let window = UIApplication.shared.keyWindow {
            applicationWindow = window
            applicationWindow.addSubview(self)
            self.frame = applicationWindow.bounds
        } else {
            return
        }
    }
    func configCollectionView() {
        self.addSubview(collection)
//        collection.frame = self.bounds
        
        collection.frame = CGRect(x: 0, y:  DDNavigationBarHeight, width: applicationWindow.bounds.width, height: applicationWindow.bounds.height - DDNavigationBarHeight)
        if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.itemSize = CGSize(width: self.bounds.size.width  , height: self.bounds.size.height)
        }
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true 
        collection.register(GDIBCollectionCell.self , forCellWithReuseIdentifier: "GDIBCollectionCell")
        if #available(iOS 10.0, *) {
            collection.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
}
// MARK: 注释 : aboutCollectionDelegate

extension GDIBContentView : UICollectionViewDelegate , UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return photos.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let item  = collectionView.dequeueReusableCell(withReuseIdentifier: "GDIBCollectionCell", for: indexPath)
        if let cell  = item as? GDIBCollectionCell {
            cell.photo = photos[indexPath.item]
            return cell
        }
        return item
            
       
        
    }
    
    
    // MARK: 注释 : scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if let collection = scrollView as? UICollectionView {
            if let flowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout  {
                let direction :  UICollectionView.ScrollDirection =  flowLayout.scrollDirection
                if direction == UICollectionView.ScrollDirection.vertical {
                    
                }else{
                    
                    
                    
                }
            }
            let offset = collection.contentOffset
            let index  : Int = Int( offset.x / collection.bounds.size.width )
            if offset.x > self.previousOffset.x { // xiang you
                if offset.x > collection.contentSize.width - collection.bounds.size.width{return}
                let pass = offset.x -  CGFloat(index) * collection.bounds.size.width
                if abs(pass) > collection.bounds.size.width / 2 {
                    self.showingPage = index + 1
                    //                    mylog("nvnvnvnvvnvnvn")
                }
            }else{//xiang zuo
                if offset.x < 0  {return}
                let less = CGFloat(index + 1) * collection.bounds.size.width - offset.x
                //                mylog(abs(less))
                if abs(less) > collection.bounds.size.width / 2 {
                    self.showingPage = index
                }
            }
            self.previousOffset = offset
        }
    
    }

}

// MARK: 注释 : createTempData
extension GDIBContentView{
    func createData(photos : [GDIBPhoto] ) -> [GDIBPhoto]  {
        if photos.count > 0  {
            return photos
        }
        var photosTemp = [GDIBPhoto]()
        /*
         for index in 0...4  {
         var imagename = ""
         
         if index == 0  {
         imagename = "emptyMultilens"
         }else if index == 1 {
         imagename = "gwxq_product_header"
         }else if index == 2 {
         imagename = "Default"
         }else if index == 3 {
         imagename = "newfeature3"
         }else if index == 4 {
         imagename = "newfeature2"
         }
         photosTemp.append(GDIBPhoto.init(dict: ["image" : UIImage(named: imagename)  ?? UIImage()]  ))
         
         }*/
        for index in 0...4  {
            var imageURL = "https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png"
            
            if index == 0  {
                imageURL = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493962239170&di=73872f5e71670bdc24a25672d0a49368&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F85%2F85%2F73T58PIC9aj_1024.jpg"
            }else if index == 1 {
                imageURL = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493962239170&di=0ed7ffa0f6dffc6d046374ce675270a0&imgtype=0&src=http%3A%2F%2Fpic6.huitu.com%2Fres%2F20130116%2F84481_20130116142820494200_1.jpg"
            }else if index == 2 {
                imageURL = "http"//s://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493962239169&di=d89d6aa22cf7f4ac2b03766ed56202d2&imgtype=0&src=http%3A%2F%2Fpic2.ooopic.com%2F12%2F62%2F16%2F24bOOOPIC57_1024.jpg"
            }else if index == 3 {
                imageURL = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493962239167&di=c5619e5047afc37c28beaf04eb2937bd&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F120423%2F107913-12042323220753.jpg"
            }else if index == 4 {
                imageURL = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493962043037&di=d0c554c0273e65190b011092c161e91f&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201501%2F23%2F20150123183831_wYu3F.thumb.700_0.jpeg"
            }
            photosTemp.append(GDIBPhoto.init(dict: ["imageURL" : imageURL as AnyObject  ]))
            
        }
        
        
        return photosTemp

    }
}

