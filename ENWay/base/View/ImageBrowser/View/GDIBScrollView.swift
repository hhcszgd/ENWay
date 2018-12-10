//
//  GDIBScrollView.swift
//  zjlao
//
//  Created by WY on 04/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit
import SDWebImage
import Photos

extension GDIBScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
}


class GDIBScrollView: UIScrollView {
    
    let imageView : UIImageView = UIImageView()
    var alertView: UIView?
    
    func fexImageViewFrame(image:UIImage,currentScale:CGFloat = 1)  {
        let targetSize = image.size
//        let targetSize = CGSize(width: image.size.width/10, height: image.size.height/10)
        self.imageView.bounds  = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        self.imageView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
//        self.imageView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        self.contentSize = targetSize
        setZoomScale()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    @discardableResult
    func setZoomScale() -> CGFloat {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = self.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        self.minimumZoomScale = min(widthScale, heightScale)
        
        self.zoomScale = minimumZoomScale
        
        
        
        
        self.maximumZoomScale = minimumZoomScale
        return minimumZoomScale
    }
    
    func config()  {
        self.addSubview(imageView)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.frame = self.bounds
        imageView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        //        singleTap.require(toFail: longPress)
        self.imageView.addGestureRecognizer(longPress)
        
        delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 2
        self.backgroundColor = UIColor.black
    }
    
    func zoomEnable(status : Bool)  {
        
        self.maximumZoomScale = status ? 2 : 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse()  {
        setZoomScale(minimumZoomScale, animated: false)
        self.imageView.image = nil 
    }
   
    // MARK: 注释 : 双击
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        mylog("双击")
//        return
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if self.maximumZoomScale == 1 { return  }
        let touchPoint = recognizer.location(in: self.imageView)
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
            
        } else {
            let zoomRect = zoomRectForScrollViewWith(maximumZoomScale , touchPoint: touchPoint)
            zoom(to: zoomRect, animated: true)
        }
        
    }
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (h / max(UIScreen.main.scale, 2.0))
        let y = touchPoint.y - (w / max(UIScreen.main.scale, 2.0))
        return CGRect(x: x, y: y, width: w, height: h)
    }
    // MARK: 注释 : 单击
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        mylog("单击")
    }
    
    // MARK: 注释 : 长按
    @objc func longPress(_ recognizer: UILongPressGestureRecognizer)  {
        mylog("长按")
        if self.maximumZoomScale == 1 { return  }
        
        self.alert()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsSize = bounds.size
        var frameToCenter = imageView.frame
        
        // horizon
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
        } else {
            frameToCenter.origin.x = 0
        }
        // vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
        } else {
            frameToCenter.origin.y = 0
        }
        
        // Center
        if !imageView.frame.equalTo(frameToCenter) {
            imageView.frame = frameToCenter
        }
    }
    
    
    
    var photo : GDIBPhoto? {
        didSet{
            if let image  = photo?.image {
                imageView.image = image
                self.fexImageViewFrame(image: image)
                self.zoomEnable(status: true)
            }else{
                self.zoomEnable(status: false)
            }
            
            if let imagePath  = photo?.imagePath {
                imageView.image = UIImage(contentsOfFile: imagePath)
                self.fexImageViewFrame(image: imageView.image ?? UIImage())
                self.zoomEnable(status: true)
            }else{
                self.zoomEnable(status: false)
            }
            
            
            if let imageURL = photo?.imageURL {
                let url = URL(string: imageURL)
                mylog(imageURL)
                imageView.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in
                    //加载结果
                    if let imageReal = image {
                        self.fexImageViewFrame(image: imageReal)
                        mylog("加载成功")
                        self.zoomEnable(status: true)
                    }else{
                        mylog("加载失败")
                        self.zoomEnable(status: false)
                    }
                }
            }//监听图片加载
            
            if let asset = photo?.asset {
                
                
                DDPhotoManager.share.getMediaByPHAsset(asset: asset){ (image , dict ) in
                    self.imageView.image = image
                    self.fexImageViewFrame(image: self.imageView.image ?? UIImage())
                    self.zoomEnable(status: true)
                    
                }
            }else{
                self.zoomEnable(status: false)
            }
        }
    }
}

extension GDIBScrollView{
    func alert()  {
        if self.alertView == nil  {
            let alertViewContainer = UIButton.init(frame: window?.bounds ?? CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
            let titleW : CGFloat = 188
            let titleH : CGFloat = 48
            let titleLabel = UILabel(frame: CGRect(x: (SCREENWIDTH - titleW ) / 2, y: (SCREENHEIGHT - titleH ) / 2, width: titleW, height: titleH))
            let cancle = UIButton(frame: CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY, width: titleW * 0.5, height: titleH))
            
            let confirm = UIButton(frame: CGRect(x: cancle.frame.maxX, y: titleLabel.frame.maxY, width: titleW * 0.5, height: titleH))
            alertViewContainer.addSubview(titleLabel)
            alertViewContainer.addSubview(cancle)
            alertViewContainer.addSubview(confirm)
            
            titleLabel.text = "保存图片"
            confirm.setTitle("确定", for: UIControl.State.normal)
            cancle.setTitle("取消", for: UIControl.State.normal)
            confirm.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            cancle.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.backgroundColor = UIColor.white
            cancle.backgroundColor = UIColor.white
            confirm.backgroundColor = UIColor.white
            
            
            cancle.addTarget(self , action: #selector(cancleSaveImage), for: UIControl.Event.touchUpInside)
            alertViewContainer.addTarget(self , action: #selector(cancleSaveImage), for: UIControl.Event.touchUpInside)
            confirm.addTarget(self , action: #selector(saveImage), for: UIControl.Event.touchUpInside)
            self.alertView = alertViewContainer
            window?.addSubview(alertViewContainer)
        }
    }
    @objc  func cancleSaveImage()  {
        self.alertView?.removeFromSuperview()
        self.alertView = nil
    }
    @objc func saveImage()  {
        if let image  = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image , nil , nil, nil )
        }
        self.cancleSaveImage()
    }
    func saveImageComplate()  {
        mylog("保存成功")
    }
}




// MARK: - UIScrollViewDelegate
/*
extension GDIBScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //        photoBrowser?.cancelControlHiding()
    }
    
    //    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    //        setNeedsLayout()
    //        layoutIfNeeded()
    //    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let  imgViewSize = self.imageView.frame.size;
        let imageSize = self.imageView.image?.size ?? CGSize.zero;
        
        var  realImgSize = CGSize.zero
        if(imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height) {
            realImgSize = CGSize(width : imgViewSize.width,height: imgViewSize.width / imageSize.width * imageSize.height);
        }
        else {
            realImgSize = CGSize(width:imgViewSize.height / imageSize.height * imageSize.width, height:imgViewSize.height);
        }
        
        var  fr = CGRect.zero
        fr.size = realImgSize;
        self.imageView.frame = fr;
        
        let scrSize = scrollView.frame.size;
        let  offx : CGFloat = (scrSize.width > realImgSize.width ? (scrSize.width - realImgSize.width) / 2 : 0);
        let offy : CGFloat = (scrSize.height > realImgSize.height ? (scrSize.height - realImgSize.height) / 2 : 0);
        
        // don't animate the change.
        scrollView.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
    }
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        
        
        mylog("\n contentSize:\(scrollView.contentSize) \n contentOffset:\(scrollView.contentOffset) \n imageViewFrame\(imageView.frame) \n imageSize\(imageView.image?.size) \n scale : \(scale )")
        //        view?.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        if self.imageView.bounds.size.width > SCREENWIDTH && self.imageView.bounds.size.height > SCREENHEIGHT {
            
        }else if self.imageView.bounds.size.width > SCREENWIDTH {
            
        }else if  self.imageView.bounds.size.height > SCREENHEIGHT {
            
        }
        //        scrollView.contentSize = self.imageView.bounds.size
        //        self.setContentOffset(<#T##contentOffset: CGPoint##CGPoint#>, animated: <#T##Bool#>)
        
    } // scale between minimum and maximum. called after any 'bounce' animations
}


class GDIBScrollView: UIScrollView {
    
    let imageView : UIImageView = UIImageView()
    var alertView: UIView?
    
    var photo : GDIBPhoto? {
        willSet{
            
            
            if let image  = newValue?.image {
                imageView.image = image
                self.fexImageViewFrame(image: image)
                self.zoomEnable(status: true)
            }else{
                self.zoomEnable(status: false)
            }
            
            
            if let imagePath  = newValue?.imagePath {
                imageView.image = UIImage(contentsOfFile: imagePath)
                self.fexImageViewFrame(image: imageView.image ?? UIImage())
                self.zoomEnable(status: true)
            }else{
                self.zoomEnable(status: false)
            }
            
            
            if let imageURL = newValue?.imageURL {
                let url = URL(string: imageURL)
                mylog(imageURL)
                imageView.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in
                    //加载结果
                    if let imageReal = image {
                        self.fexImageViewFrame(image: imageReal)
                        mylog("加载成功")
                        self.zoomEnable(status: true)
                    }else{
                        mylog("加载失败")
                        self.zoomEnable(status: false)
                    }
                }
            }//监听图片加载
            
            if let asset = newValue?.asset {
                
                
                DDPhotoManager.share.getMediaByPHAsset(asset: asset){ (image , dict ) in
                    self.imageView.image = image
                    self.fexImageViewFrame(image: self.imageView.image ?? UIImage())
                    self.zoomEnable(status: true)
                    
                    self.layoutIfNeeded()
                    self.setNeedsLayout()
                }
            }else{
                self.zoomEnable(status: false)
            }
            layoutIfNeeded()
            setNeedsLayout()
        }
        didSet{}
    }
    
    func fexImageViewFrame(image:UIImage,currentScale:CGFloat = 1)  {
        
//        self.scrollViewDidZoom(self )
        return
        let imageScalse = image.size.width / image.size.height
        var w :CGFloat = 0
        var h :CGFloat = 0
        var x :CGFloat = 0
        var y :CGFloat = 0
        if image.size.width > self.bounds.width && image.size.height > self.bounds.height{
            w = self.bounds.width//if width is full
            h = self.bounds.height / self.bounds.width * w
            if h > self.bounds.height{//but height is full
                h = self.bounds.height
                w = self.bounds.width / self.bounds.height * h
                y = 0
                x = (self.bounds.width - w ) / 2
            }else{
                x = 0
                y = (self.bounds.height - h ) / 2
            }
        }else if image.size.width > self.bounds.width {
            w = self.bounds.width
            h = self.bounds.height / self.bounds.width * w
            x = 0
            y = (self.bounds.height - h ) / 2
        }else if image.size.height > self.bounds.height{
            h = self.bounds.height
            w = self.bounds.width / self.bounds.height * h
            y = 0
            x = (self.bounds.width - w ) / 2
        }else{
            w = image.size.width
            h = image.size.height
            x = (self.bounds.width - w ) / 2
            y = (self.bounds.height - h) / 2
        }
        self.imageView.frame = CGRect(x: x, y: y, width: w, height: h)
        return
        let bili = UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
        
        let imagebili = image.size.width / image.size.height
        
//        let miniScaleImageViewSize = CGSize(width: , height: <#T##CGFloat#>)
        
        
        if imagebili >= 1 {
            //宽度大于或者等于高度
            let imageHeight: Float = Float(image.size.width / imagebili)
            let imageY: CGFloat = (SCREENHEIGHT - CGFloat(imageHeight)) / 2.0
            self.imageView.frame = CGRect.init(x: 0, y: imageY, width: SCREENWIDTH, height: CGFloat(imageHeight))
//            self.contentSize = CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT)
            
        }else if imagebili >= bili {
            let imageHeight: Float = Float(image.size.width / imagebili)
            let imageY: CGFloat = (SCREENHEIGHT - CGFloat(imageHeight)) / 2.0
            self.imageView.frame = CGRect.init(x: 0, y: imageY, width: SCREENWIDTH, height: CGFloat(imageHeight))
//            self.contentSize = CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT)
        }else {
            let imageHeight: Float = Float(SCREENWIDTH / imagebili)
            let imageY: CGFloat = 0
            self.imageView.frame = CGRect.init(x: 0, y: imageY, width: SCREENWIDTH, height: CGFloat(imageHeight))
//            self.contentSize = CGSize.init(width: SCREENWIDTH, height: CGFloat(imageHeight))
        }
        
//        let _currentImage = self.imageView.image ?? UIImage()
//        var  imageFrame = CGRect.zero
//        if (_currentImage.size.width > self.bounds.size.width || _currentImage.size.height > self.bounds.size.height) {
//            let imageRatio = _currentImage.size.width/_currentImage.size.height;
//            let photoRatio = self.bounds.size.width/self.bounds.size.height;
//
//            if (imageRatio > photoRatio) {
//                imageFrame.size = CGSize(width:self.bounds.size.width, height : self.bounds.size.width/_currentImage.size.width*_currentImage.size.height);
//                imageFrame.origin.x = 0;
//                imageFrame.origin.y = (self.bounds.size.height-imageFrame.size.height)/2.0;
//            }
//            else {
//                imageFrame.size = CGSize(width:self.bounds.size.height/_currentImage.size.height * _currentImage.size.width,height :  self.bounds.size.height);
//                imageFrame.origin.x = (self.bounds.size.width-imageFrame.size.width)/2.0;
//                imageFrame.origin.y = 0;
//            }
//        }
//        else {
//            imageFrame.size = _currentImage.size;
//            imageFrame.origin.x = (self.bounds.size.width-_currentImage.size.width)/2.0;
//            imageFrame.origin.y = (self.bounds.size.height-_currentImage.size.height)/2.0;
//        }
//        imageView.frame = imageFrame;
        
       
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    func config()  {
        self.addSubview(imageView)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.frame = self.bounds
        imageView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        //        singleTap.require(toFail: longPress)
        self.imageView.addGestureRecognizer(longPress)
        
        delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 2
        self.backgroundColor = UIColor.black
        //        decelerationRate = UIScrollViewDecelerationRateFast
        //        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
        
        
        
    }
    
    func zoomEnable(status : Bool)  {
        self.maximumZoomScale = status ? 2 : 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse()  {
        setZoomScale(minimumZoomScale, animated: false)
        self.contentInset = UIEdgeInsets.zero
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    // MARK: 注释 : 双击
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        mylog("双击")
        if self.maximumZoomScale == 1 { return  }
        let touchPoint = recognizer.location(in: self.imageView)
        if zoomScale > minimumZoomScale {
            // zoom out
            setZoomScale(minimumZoomScale, animated: true)
            
        } else {
            // zoom in
            // I think that the result should be the same after double touch or pinch
            /* var newZoom: CGFloat = zoomScale * 3.13
             if newZoom >= maximumZoomScale {
             newZoom = maximumZoomScale
             }
             */
            let zoomRect = zoomRectForScrollViewWith(maximumZoomScale , touchPoint: touchPoint)
            zoom(to: zoomRect, animated: true)
        }
        
    }
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (h / max(UIScreen.main.scale, 2.0))
        let y = touchPoint.y - (w / max(UIScreen.main.scale, 2.0))
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    // MARK: 注释 : 单击
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        mylog("单击")
    }
    
    // MARK: 注释 : 长按
    @objc func longPress(_ recognizer: UILongPressGestureRecognizer)  {
        mylog("长按")
        if self.maximumZoomScale == 1 { return  }
        
        self.alert()
    }
}

extension GDIBScrollView{
    func alert()  {
        if self.alertView == nil  {
            let alertViewContainer = UIButton.init(frame: window?.bounds ?? CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
            let titleW : CGFloat = 188
            let titleH : CGFloat = 48
            let titleLabel = UILabel(frame: CGRect(x: (SCREENWIDTH - titleW ) / 2, y: (SCREENHEIGHT - titleH ) / 2, width: titleW, height: titleH))
            let cancle = UIButton(frame: CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY, width: titleW * 0.5, height: titleH))
            
            let confirm = UIButton(frame: CGRect(x: cancle.frame.maxX, y: titleLabel.frame.maxY, width: titleW * 0.5, height: titleH))
            alertViewContainer.addSubview(titleLabel)
            alertViewContainer.addSubview(cancle)
            alertViewContainer.addSubview(confirm)
            
            titleLabel.text = "保存图片"
            confirm.setTitle("确定", for: UIControl.State.normal)
            cancle.setTitle("取消", for: UIControl.State.normal)
            confirm.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            cancle.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.backgroundColor = UIColor.white
            cancle.backgroundColor = UIColor.white
            confirm.backgroundColor = UIColor.white
            
            
            cancle.addTarget(self , action: #selector(cancleSaveImage), for: UIControl.Event.touchUpInside)
            alertViewContainer.addTarget(self , action: #selector(cancleSaveImage), for: UIControl.Event.touchUpInside)
            confirm.addTarget(self , action: #selector(saveImage), for: UIControl.Event.touchUpInside)
            self.alertView = alertViewContainer
            window?.addSubview(alertViewContainer)
        }
    }
    @objc  func cancleSaveImage()  {
        self.alertView?.removeFromSuperview()
        self.alertView = nil
    }
    @objc func saveImage()  {
        if let image  = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image , nil , nil, nil )
        }
        self.cancleSaveImage()
    }
    func saveImageComplate()  {
        mylog("保存成功")
    }
}


*/



/*
class GDIBScrollView: UIScrollView {

    let imageView : UIImageView = UIImageView()
    var alertView: UIView?
    
    var photo : GDIBPhoto? {
        willSet{
            
            
            if let image  = newValue?.image {
                imageView.image = image
               self.fexImageViewFrame(image: image)
                self.zoomEnable(status: true)
            }else{
                self.zoomEnable(status: false)
            }
            
            
            if let imagePath  = newValue?.imagePath {
                imageView.image = UIImage(contentsOfFile: imagePath)
                self.fexImageViewFrame(image: imageView.image ?? UIImage())
                self.zoomEnable(status: true)
            }else{
                self.zoomEnable(status: false)
            }
            
            
            if let imageURL = newValue?.imageURL {
                let url = URL(string: imageURL)
                mylog(imageURL)
                imageView.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in
                    //加载结果
                    if let imageReal = image {
                        self.fexImageViewFrame(image: imageReal)
                        mylog("加载成功")
                        self.zoomEnable(status: true)
                    }else{
                        mylog("加载失败")
                        self.zoomEnable(status: false)
                    }
                }
            }//监听图片加载
            
            if let asset = newValue?.asset {
                
                
                DDPhotoManager.share.getMediaByPHAsset(asset: asset){ (image , dict ) in
                    self.imageView.image = image
                    self.fexImageViewFrame(image: self.imageView.image ?? UIImage())
                    self.zoomEnable(status: true)
                }
            }else{
                self.zoomEnable(status: false)
            }
            
        }
        didSet{}
    }
    
    func fexImageViewFrame(image:UIImage)  {
        let bili = UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
        
        let imagebili = image.size.width / image.size.height
        
        if imagebili >= 1 {
            //宽度大于或者等于高度
            let imageHeight: Float = Float(image.size.width / imagebili)
            let imageY: CGFloat = (SCREENHEIGHT - CGFloat(imageHeight)) / 2.0
            self.imageView.frame = CGRect.init(x: 0, y: imageY, width: SCREENWIDTH, height: CGFloat(imageHeight))
            self.contentSize = CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT)
            
        }else if imagebili >= bili {
            let imageHeight: Float = Float(image.size.width / imagebili)
            let imageY: CGFloat = (SCREENHEIGHT - CGFloat(imageHeight)) / 2.0
            self.imageView.frame = CGRect.init(x: 0, y: imageY, width: SCREENWIDTH, height: CGFloat(imageHeight))
            self.contentSize = CGSize.init(width: SCREENWIDTH, height: SCREENHEIGHT)
        }else {
            let imageHeight: Float = Float(SCREENWIDTH / imagebili)
            let imageY: CGFloat = 0
            self.imageView.frame = CGRect.init(x: 0, y: imageY, width: SCREENWIDTH, height: CGFloat(imageHeight))
            self.contentSize = CGSize.init(width: SCREENWIDTH, height: CGFloat(imageHeight))
        }
        
        
//        var imageViewW : CGFloat = 0;
//        var imageViewH : CGFloat = imageViewW
//        let tempHeight = image.size.height * SCREENWIDTH / image.size.width //当前宽度满屏时对应的高度是
//        mylog("图片宽高\(image.size) , 满屏宽对应的高 \(tempHeight)")
//        if SCREENHEIGHT < tempHeight {//高度可满屏 , 宽度有空白
//            imageViewH = SCREENHEIGHT
//            imageViewW = image.size.width / image.size.height * image.size.height
//        }else{//宽度可满屏,高度有空白
//            imageViewW = SCREENWIDTH
//            imageViewH = tempHeight
//        }
//        self.imageView.bounds = CGRect(x: 0, y: 0, width: imageViewW, height: imageViewH)
//        self.imageView.center = CGPoint(x: SCREENWIDTH / 2, y: SCREENHEIGHT / 2)
//        mylog(imageView.frame)
//        self.contentSize = CGSize.init(width: image.size.width, height: image.size.height)
//        self.imageView.frame = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    func config()  {
        self.addSubview(imageView)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.frame = CGRect(x: 0, y: (SCREENHEIGHT - SCREENWIDTH) / 2, width: SCREENWIDTH, height: SCREENWIDTH)
        imageView.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
//        singleTap.require(toFail: longPress)
        self.imageView.addGestureRecognizer(longPress)
        
        delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 2
        self.backgroundColor = UIColor.black
//        decelerationRate = UIScrollViewDecelerationRateFast
//        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
        
        
        
    }
    
    func zoomEnable(status : Bool)  {
            self.maximumZoomScale = status ? 2 : 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let boundsSize = bounds.size
//        var frameToCenter = imageView.frame
//        
//        // horizon
//        if frameToCenter.size.width < boundsSize.width {
//            frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2)
//        } else {
//            frameToCenter.origin.x = 0
//        }
//        // vertical
//        if frameToCenter.size.height < boundsSize.height {
//            frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2)
//        } else {
//            frameToCenter.origin.y = 0
//        }
//        
//        // Center
//        if !imageView.frame.equalTo(frameToCenter) {
//            imageView.frame = frameToCenter
//        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse()  {
        setZoomScale(minimumZoomScale, animated: false)

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: 注释 : 双击
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        mylog("双击")
        if self.maximumZoomScale == 1 { return  }
        let touchPoint = recognizer.location(in: self.imageView)
        if zoomScale > minimumZoomScale {
            // zoom out
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            // zoom in
            // I think that the result should be the same after double touch or pinch
            /* var newZoom: CGFloat = zoomScale * 3.13
             if newZoom >= maximumZoomScale {
             newZoom = maximumZoomScale
             }
             */
            let zoomRect = zoomRectForScrollViewWith(maximumZoomScale , touchPoint: touchPoint)
            zoom(to: zoomRect, animated: true)
        }
    }
    func zoomRectForScrollViewWith(_ scale: CGFloat, touchPoint: CGPoint) -> CGRect {
        let w = frame.size.width / scale
        let h = frame.size.height / scale
        let x = touchPoint.x - (h / max(UIScreen.main.scale, 2.0))
        let y = touchPoint.y - (w / max(UIScreen.main.scale, 2.0))
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    // MARK: 注释 : 单击
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        mylog("单击")
    }

    // MARK: 注释 : 长按
    @objc func longPress(_ recognizer: UILongPressGestureRecognizer)  {
        mylog("长按")
        if self.maximumZoomScale == 1 { return  }

        self.alert()
    }
}
// MARK: - UIScrollViewDelegate

extension GDIBScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        photoBrowser?.cancelControlHiding()
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
    
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        mylog("\n contentSize:\(scrollView.contentSize) \n contentOffset:\(scrollView.contentOffset) \n imageViewFrame\(imageView.frame) \n imageSize\(imageView.image?.size)")
        if self.imageView.bounds.size.width > SCREENWIDTH && self.imageView.bounds.size.height > SCREENHEIGHT {
            
        }else if self.imageView.bounds.size.width > SCREENWIDTH {
            
        }else if  self.imageView.bounds.size.height > SCREENHEIGHT {
            
        }
//        scrollView.contentSize = self.imageView.bounds.size
//        self.setContentOffset(<#T##contentOffset: CGPoint##CGPoint#>, animated: <#T##Bool#>)
        
    } // scale between minimum and maximum. called after any 'bounce' animations
}

extension GDIBScrollView{
    func alert()  {
        if self.alertView == nil  {
            let alertViewContainer = UIButton.init(frame: window?.bounds ?? CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
            let titleW : CGFloat = 188
            let titleH : CGFloat = 48
            let titleLabel = UILabel(frame: CGRect(x: (SCREENWIDTH - titleW ) / 2, y: (SCREENHEIGHT - titleH ) / 2, width: titleW, height: titleH))
            let cancle = UIButton(frame: CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY, width: titleW * 0.5, height: titleH))
            
            let confirm = UIButton(frame: CGRect(x: cancle.frame.maxX, y: titleLabel.frame.maxY, width: titleW * 0.5, height: titleH))
            alertViewContainer.addSubview(titleLabel)
            alertViewContainer.addSubview(cancle)
            alertViewContainer.addSubview(confirm)
            
            titleLabel.text = "保存图片"
            confirm.setTitle("确定", for: UIControl.State.normal)
            cancle.setTitle("取消", for: UIControl.State.normal)
            confirm.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            cancle.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            
            titleLabel.textAlignment = NSTextAlignment.center
            titleLabel.backgroundColor = UIColor.white
            cancle.backgroundColor = UIColor.white
            confirm.backgroundColor = UIColor.white
            
            
            cancle.addTarget(self , action: #selector(cancleSaveImage), for: UIControl.Event.touchUpInside)
            alertViewContainer.addTarget(self , action: #selector(cancleSaveImage), for: UIControl.Event.touchUpInside)
            confirm.addTarget(self , action: #selector(saveImage), for: UIControl.Event.touchUpInside)
            self.alertView = alertViewContainer
            window?.addSubview(alertViewContainer)
        }
    }
    @objc  func cancleSaveImage()  {
        self.alertView?.removeFromSuperview()
        self.alertView = nil
    }
    @objc func saveImage()  {
        if let image  = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image , nil , nil, nil )
        }
        self.cancleSaveImage()
    }
    func saveImageComplate()  {
        mylog("保存成功")
    }
}

*/
