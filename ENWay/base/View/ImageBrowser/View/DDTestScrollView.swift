//
//  DDTestScrollView.swift
//  Project
//
//  Created by WY on 2018/10/15.
//  Copyright © 2018 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDTestScrollView: UIScrollView , UIScrollViewDelegate{
    
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
        var imageView: UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    func prepareForReuse()  {
        setZoomScale(minimumZoomScale, animated: false)
        self.contentInset = UIEdgeInsets.zero
    }
    func zoomEnable(status : Bool)  {
        self.maximumZoomScale = status ? 2 : 1
    }
    func  fexImageViewFrame(image:UIImage) {
        // 1定义ImageView
        imageView.frame = CGRect(origin: CGPoint(x:0.0,y: 0.0), size:(image.size))
        
        // 2把ImageView添加到ScrollView上
        self.contentSize = image.size//ScrollView的内容大小就是sImageView的大小
        
        // 3给scroolerView添加手势
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped(recognizer:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTapRecognizer)
        
        // 4 添加Scroller的缩放
        let scrollViewFrame = self.frame
        let scaleWidth = scrollViewFrame.size.width / self.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / self.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        self.minimumZoomScale = minScale;
        
        // 5  scrollView的最大值和最小值
        self.maximumZoomScale = 1.0
        self.zoomScale = minScale;
        
        // 6  调用centerScrollViewContents函数将图片放置到了scroll view的中央
        centerScrollViewContents()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func centerScrollViewContents() {
        let boundsSize = self.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    //点击scrollView的放大
    @objc func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.location(in: imageView)
        
        // 2
        var newZoomScale = self.zoomScale * 1.5
        newZoomScale = min(newZoomScale, self.maximumZoomScale)
        
        // 3
        let scrollViewSize = self.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x:x, y:y, width:w,height: h);
        
        // 4
        self.zoom(to: rectToZoomTo, animated: true)
    }
    //现在, 还记得我们怎么设置ViewController实现UIScrollViewDelegate的吗? 接下来, 你将会实现这个协议中需要用到的若干方法。 在类中添加下面的方法:
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    //这是scroll view实现缩放机制的核心。你指出了当进行捏合操作的时候哪一个view将会被放大或者缩小。也就是我们的imageView。
    //最后在类中添加代理方法:
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
        
        
    
        
}
