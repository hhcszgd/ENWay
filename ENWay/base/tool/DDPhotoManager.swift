//
//  GDPhotoManager.swift
//  zjlao
//
//  Created by WY on 2017/8/23.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
class DDPhotoManager: NSObject , PHPhotoLibraryChangeObserver {

    let givinIDFromServer = Set.init(["xxxxxxxxxxxxxxxxxx" , "aaaaaaaaaaaaaaaaaa" , "bbbbbbbbbbbbbbb" , "ccccccccccccccccccc"])
    
    static let share : DDPhotoManager = DDPhotoManager()
    //:获取授权状态
    func getRequestAuthorizationStatus(callBack:@escaping (PHAuthorizationStatus)->())  {
        PHPhotoLibrary.requestAuthorization { (status) in
//            print(status)
            callBack(status)
        }
    }
    
    
    
    func requestAccessCamarm(_ perform : @escaping () -> ())  {
        
        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch authStatus {
        case .authorized:
            
            DispatchQueue.main.async {
                perform()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (finished) in
                if finished {
                    perform()
                }else {
                    
                }
                
            }
        case .denied:
            DispatchQueue.main.async {
                
                let alertVC = UIAlertController.init(title: "请在iPhone的\"设置-隐私\"选项中,允许访问您的相机", message: nil, preferredStyle: UIAlertController.Style.alert)
                let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (action ) in
                    
                }
                let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.destructive) { (action ) in
                    
                    let url : URL = URL(string: UIApplication.openSettingsURLString)!
                    if UIApplication.shared.canOpenURL(url ) {
                        UIApplication.shared.openURL(url)
                    }
                }
                alertVC.addAction(cancleAction)
                alertVC.addAction(confirmAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true , completion: nil )
            }
            
            
        case .restricted:
            DispatchQueue.main.async {
                let alertVC = UIAlertController.init(title: "前往设置中心开启相机访问权限", message: nil, preferredStyle: UIAlertController.Style.alert)
                let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (action ) in
                    
                }
                let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.destructive) { (action ) in
                    
                    let url : URL = URL(string: UIApplication.openSettingsURLString)!
                    if UIApplication.shared.canOpenURL(url ) {
                        UIApplication.shared.openURL(url)
                    }
                }
                alertVC.addAction(cancleAction)
                alertVC.addAction(confirmAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true , completion: nil )
                
            }
        }
    }
    func requestAccessPhotoLibrary(_ perform : @escaping () -> ())  {
        
        
        self.getRequestAuthorizationStatus { (status ) in
            switch status {
            case .authorized:
                
                DispatchQueue.main.async {
                   perform()
                }
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { authorizationStatus in}
            case .denied:
                DispatchQueue.main.async {
                    
                    let alertVC = UIAlertController.init(title: "请在iPhone的\"设置-隐私\"选项中,允许访问您的相册", message: nil, preferredStyle: UIAlertController.Style.alert)
                    let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (action ) in
                        
                    }
                    let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.destructive) { (action ) in
                        
                        let url : URL = URL(string: UIApplication.openSettingsURLString)!
                        if UIApplication.shared.canOpenURL(url ) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    alertVC.addAction(cancleAction)
                    alertVC.addAction(confirmAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true , completion: nil )
                }
                
                
            case .restricted:
                DispatchQueue.main.async {
                    let alertVC = UIAlertController.init(title: "前往设置中心开启相册访问权限", message: nil, preferredStyle: UIAlertController.Style.alert)
                    let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (action ) in
                        
                    }
                    let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.destructive) { (action ) in
                        
                        let url : URL = URL(string: UIApplication.openSettingsURLString)!
                        if UIApplication.shared.canOpenURL(url ) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    alertVC.addAction(cancleAction)
                    alertVC.addAction(confirmAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true , completion: nil )
                    
                }
            }
        }
    }
    
    //:获取一个PHAsset对应的一张资源(图片或视频)
    func getMediaByPHAsset (asset: PHAsset ,targetSize: CGSize = PHImageManagerMaximumSize, contentMode: PHImageContentMode = PHImageContentMode.default , callBack : @escaping (UIImage? , [AnyHashable : Any]?)->())  {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true 
        PHImageManager.default().requestImage(for: asset, targetSize:targetSize, contentMode: contentMode, options: option) { (imgOption , dictInfo) in
            mylog(dictInfo)
            callBack(imgOption , dictInfo)
        }
    }
    
    //: 通过一个id获取一张图片(视频)
    func getImage(withId id : String ,targetSize: CGSize = CGSize.init(width: 100, height: 100), contentMode: PHImageContentMode = PHImageContentMode.default  , callBack : @escaping (UIImage? , [AnyHashable : Any]?)->())  {
        let id = "F0AC8DB2-CD1A-4C67-AF3D-BAB13BFB6BB9/L0/001"
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil )
        let asset = fetchResult.firstObject ?? PHAsset()
        self.getMediaByPHAsset(asset: asset, targetSize: targetSize, contentMode: contentMode) { (imageOption, info ) in
            callBack(imageOption,info)
        }
    }
    

    
    //: 监听相册的变化
    func observePhotosChange(){
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    //: 变化回调
    func photoLibraryDidChange(_ changeInstance: PHChange){
        print(changeInstance)
    }

        
    
    //: 获取所有照片(视频)资源
    func getImagesFromSystemPhotoLibrary(targetSize: CGSize = CGSize.init(width: 100, height: 100), contentMode: PHImageContentMode = PHImageContentMode.default  ,callback:@escaping (_ images : [UIImage])->()) {
        var imageArr : [UIImage]  = [UIImage]()
        let result = PHAsset.fetchAssets(with: nil)
        result.enumerateObjects({ (asset, index , pointer) in
            self.getMediaByPHAsset(asset: asset, targetSize: targetSize, contentMode: contentMode, callBack: { (imageOption, info ) in
                if let image = imageOption {
                    imageArr.append(image)
                }
                if index == result.count - 1 {
                    callback(imageArr)
                }
            })
            
//            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: 100, height: 100), contentMode: PHImageContentMode.default, options: nil) { (img , dictInfo) in
//                if let image = img {
//                    imageArr.append(image)
//                }
//                if index == result.count - 1 {
//                    callback(imageArr)
//                }
//            }
        })
    }
    //: 测试保存图片
    func testSaveImage() {
        self.saveImage(image: UIImage(named: "test")!) { (imageID) in
            print("回调的图片id\(imageID)")
        }
    }
    //: 保存图片,并将保存的图片id通过回调返回
    /// 回调参数是图片对应的id , 存储本地数据库 , 并绑定圈子id
    func saveImage(image:UIImage? , complate : @escaping ( String?)->()) {
        if image == nil  {
            complate(nil)
            return
        }
        var id  : String?
        PHPhotoLibrary.shared().performChanges({//异步 (带wait的方法是同步执行)
            //创建相册变更请求
            var targetAssetCollectionChangeRequest : PHAssetCollectionChangeRequest?
            //取出指定名称的相册
            let collectionOption = self.getAssetCollection(withName: "QieZi")
            if collectionOption != nil {//有就根据相册创建相应的相册更改请求
                targetAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.init(for: collectionOption!)
            }else{//没有就建
                targetAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "QieZi")
            }
            //创建图片变动请求
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
            let placeholder = assetRequest.placeholderForCreatedAsset
            targetAssetCollectionChangeRequest?.addAssets(NSArray.init(array: [placeholder!]))
            id = placeholder?.localIdentifier
        }) { (success, error ) in
            if error == nil {
                print("保存成功")
                complate(id)//回调id
            }else{
                print("保存失败\(error)")
                complate(nil)
            }
        }
    }
    
    //: 获取系统所有相册
    func getSystemAlbums() -> PHFetchResult<PHAssetCollection>? {
        let result = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil  )
        return result
    }
    //: 获取所有自定义相册
    func getCustomAlbums() -> PHFetchResult<PHAssetCollection>? {
        let result = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil  )
        return result
    }
    //: 通过一个相册名称 , 去获取一个对应的相册 (可能获取不到)
    func getAssetCollection(withName name : String ) -> PHAssetCollection? {
        if let collections = self.getCustomAlbums() {
            
            for index  in 0..<collections.count {
                if collections.object(at: index).localizedTitle?.contains(name)  ?? false{
                    return collections.object(at: index)
                }
            }
            return nil
            
        }
        return nil
    }
    //: 获取一个assetCollection里面的所有的Asset
    func getAssets(fromAssetCollection collection: PHAssetCollection , options: PHFetchOptions?) -> PHFetchResult<PHAsset>  {
        let fetchResult = PHAsset.fetchAssets(in: collection , options: options)
        return fetchResult
    }
    //: 通过id删除一张图片
    func deleteMedia(specificID id : String)  {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil )
        let asset = fetchResult.firstObject ?? PHAsset()
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(NSArray.init(array: [asset]))
        }) { (changeResult, error) in
            if error == nil {
                print("删除成功")
            }else{
                print("删除失败")
            }
        }
    }
    
    func getLocalIds() -> Set<String>  {
        let qieziCollection = self.getAssetCollection(withName: "QieZi")
        var idArr = [String]()
        if let collection  = qieziCollection {
            let assetsFetchResult = self.getAssets(fromAssetCollection: collection, options: nil )
            for index   in 0..<assetsFetchResult.count {
                let asset = assetsFetchResult.object(at: index)
                idArr.append(asset.localIdentifier)
            }
            return Set.init(idArr)
        }else{
            return Set()
        }
    }
    
    func hasUploadIDs() -> Set<String> {
        let hasuploadIds = self.getLocalIds().intersection(self.givinIDFromServer)
        return hasuploadIds
    }
    func noUploadIDs() -> Set<String> {
        let nouploadIds = self.getLocalIds().subtracting(self.givinIDFromServer)
        return nouploadIds
    }

}
