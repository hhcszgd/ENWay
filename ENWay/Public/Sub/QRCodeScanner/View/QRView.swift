
//
//  QRView.swift
//  zjlao
//
//  Created by WY on 16/11/9.
//  Copyright © 2016年 com.16lao.zjlao. All rights reserved.

import UIKit
import AVFoundation

@objc protocol QRViewDelegate : NSObjectProtocol{
    func qrView(view : QRView , didCompletedWithQRValue : String)
}

class QRView: UIView ,AVCaptureMetadataOutputObjectsDelegate{
    weak var delegate : QRViewDelegate?
    let bgView  = UIImageView()//背景框
    let lineView = UIImageView()//上下扫描的线
    let session = AVCaptureSession()
    var sublayer    : AVCaptureVideoPreviewLayer?
    let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
    //        AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    let flashLightBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupQRScannerCompose()
        self.setupControlCompose()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupControlCompose ()  {
        self.addSubview( bgView)
        self.addSubview(lineView)
        self.addSubview(flashLightBtn)
        flashLightBtn.setImage(UIImage(named: "flashlightshut"), for: UIControl.State.normal)
        flashLightBtn.setImage(UIImage(named: "flashlightopen"), for: UIControl.State.selected)
        flashLightBtn.addTarget(self, action: #selector(flashBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        self.bgView.image = UIImage.init(named: "pick_bg")
        self.lineView.image = UIImage.init(named: "line")
        if videoCaptureDevice?.isTorchAvailable ?? false{
            flashLightBtn.isHidden = false
        }else{
            flashLightBtn.isHidden = true
        }
        
    }
    @objc func flashBtnClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if videoCaptureDevice?.isTorchAvailable ?? false{
            self.videoCaptureDevice?.torchMode = sender.isSelected ?  .on : .off
        }
    }
    func setupQRScannerCompose()  {
        //        let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //        videoCaptureDevice.unlockForConfiguration()
        do {
            try  videoCaptureDevice?.lockForConfiguration()
            
        }catch{
            mylog(error)
        }
        if videoCaptureDevice?.isTorchAvailable ?? false{
            videoCaptureDevice?.torchMode = .off
        }
        //MARK:先注销 , 等会儿再测
        //        let setting = AVCapturePhotoSettings.init(format: nil).flashMode = AVCaptureFlashMode.on
        
        //        videoCaptureDevice.torchMode =  AVCaptureTorchMode.on
        //        videoCaptureDevice.flashMode  = AVCaptureFlashMode.on
        if let videoCaptureDevice  = self.videoCaptureDevice {
            do {
                
                let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                
                if self.session.canAddInput(videoInput) {
                    self.session.addInput(videoInput)
                } else {
                    print("Could not add video input")
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if self.session.canAddOutput(metadataOutput) {
                    self.session.addOutput(metadataOutput)
                    
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.pdf417]
                } else {
                    print("Could not add metadata output")
                }
                
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.sublayer = previewLayer
                self.layer.addSublayer(self.sublayer!)
                //            previewLayer?.frame = self.view.layer.bounds
                //            self.view.layer .addSublayer(previewLayer!)
                self.session.startRunning()
            } catch let error as NSError {
                print("Error while creating vide input device: \(error.localizedDescription)")
            }
        }
        
        
    }
    //    override func layoutSublayers(of layer: CALayer) {
    //        super.layoutSublayers(of: layer)
    //        sublayer?.frame = self.layer.bounds
    //
    //    }
    //扫描成功的代理
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        mylog(metadataObjects)
        for item in metadataObjects {
            if let obj  = item as? AVMetadataMachineReadableCodeObject {
                if obj.stringValue?.count ?? 0 > 0 {
                    let isRespondOption = (self.delegate?.responds(to: #selector(QRViewDelegate.qrView(view:didCompletedWithQRValue:))))
                    if let isRespond = isRespondOption  {
                        if isRespond {
                            self.delegate?.qrView(view: self, didCompletedWithQRValue: obj.stringValue!)
                            self.session.stopRunning();
                            return
                        }
                    }
                }
                
            }
        }
        
    }
    //    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {//过期
    //        mylog(metadataObjects)
    //        //MARK: 强制解包失败已修复
    //
    //        for item in metadataObjects {
    //            if let obj  = item as? AVMetadataMachineReadableCodeObject {
    //                if obj.stringValue?.characters.count ?? 0 > 0 {
    //                    let isRespondOption = (self.delegate?.responds(to: #selector(QRViewDelegate.qrView(view:didCompletedWithQRValue:))))
    //                    if let isRespond = isRespondOption  {
    //                        if isRespond {
    //                            self.delegate?.qrView(view: self, didCompletedWithQRValue: obj.stringValue!)
    //                            self.session.stopRunning();
    //                            return
    //                        }
    //                    }
    //                }
    //
    //            }
    //        }
    //    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mylog(self.bounds)
        sublayer?.frame = self.bounds
        let  size = self.bounds.size;
        let  bgW : CGFloat = 200
        let bgH  : CGFloat = 200
        let  bgX  : CGFloat = (size.width - bgW) * 0.5;
        let  bgY  : CGFloat = (size.height - bgH) * 0.5;
        //  背景的位置
        self.bgView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: bgH)
        //  线的frame
        self.lineView.frame = CGRect.init(x: bgX, y: bgY, width: bgW, height: 2)
        //  使用核心动画
        self.lineView.layer.removeAnimation(forKey: "positionAnimation")
        let  positionAnimation : CABasicAnimation =  CABasicAnimation.init(keyPath: "position.y")
        positionAnimation.fromValue = (bgY);
        positionAnimation.toValue = (self.bgView.frame.maxY)
        positionAnimation.duration = 2
        positionAnimation.repeatCount = Float(NSIntegerMax)
        self.lineView.layer.add(positionAnimation, forKey: "positionAnimation")
        self.flashLightBtn.frame = CGRect(x: self.bounds.width/2 - 22 , y: self.bounds.height - 88, width:44, height:44)
    }
    
    deinit {
        mylog("二维码视图销毁了")
        //         videoCaptureDevice.torchMode = .off
        
    }
}
/**
 /**
 *  当输出对象解析到相应地内容的时候,就会调用该方法
 */
 - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
 {
 AVMetadataMachineReadableCodeObject *obj = [metadataObjects firstObject];
 
 if (obj.stringValue.length != 0) {
 if ([self.delegate respondsToSelector:@selector(qrView:didCompletedWithQRValue:)]) {
 [self.delegate qrView:self didCompletedWithQRValue:obj.stringValue];
 }
 [self.session stopRunning];
 }
 }
 
 
 
 - (void)layoutSubviews
 {
 [super layoutSubviews];
 
 CGSize size = self.bounds.size;
 
 CGFloat bgW = 200;
 CGFloat bgH = 200;
 CGFloat bgX = (size.width - bgW) * 0.5;
 CGFloat bgY = (size.height - bgH) * 0.5;
 //  背景的位置
 self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
 //  线的frame
 self.lineView.frame = CGRectMake(bgX, bgY, bgW, 2);
 
 //  使用核心动画
 [self.lineView.layer removeAnimationForKey:@"positionAnimation"];
 
 CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
 
 positionAnimation.fromValue = @(bgY);
 
 positionAnimation.toValue = @(CGRectGetMaxY(self.bgView.frame));
 
 positionAnimation.duration = 2;
 
 positionAnimation.repeatCount = NSIntegerMax;
 
 [self.lineView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
 }
 
 
 */
/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */



