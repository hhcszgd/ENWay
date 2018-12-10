//
//  DDImagePicker.swift
//  MediaManager
//
//  Created by WY on 2018/8/24.
//  Copyright © 2018年 WY. All rights reserved.
//

import UIKit







@objc protocol GDImagePickerviewDelegate : NSObjectProtocol{
    @objc optional func scrollDirection() -> UICollectionView.ScrollDirection
    @objc optional func columnCount() -> Int//纵向时指定
    @objc optional func rowCount() -> Int//横向时指定
    @objc optional func itemMargin() -> CGFloat
    @objc optional func collectionInset() -> UIEdgeInsets
    @objc optional func getSelectedPHAssets(assets:[PHAsset]?)
    @objc optional func selectAction()
    @objc optional func clickAction()
    @objc optional func maxCount() -> Int
    @objc optional func itemSize() -> CGSize
}
class DDImagePicker: UIView {
    
    var allIndexPathsOfSelectedItems : [PhotoItemModel] = [PhotoItemModel]()
    
    private var columnCount : Int{
        get {
            if let count  = self.delegate?.columnCount?() {
                return count
            }
            return 3
        }
    }
    private var rowCount : Int {
        get {
            if let count  = self.delegate?.rowCount?() {
                return count
            }
            return 3
        }
    }
    private var itemMargin : CGFloat{
        get {
            if let margin  = self.delegate?.itemMargin?() {
                return margin
            }
            return 2
        }
    }
    private var collectionInset : UIEdgeInsets{
        get{
            if let inset  = self.delegate?.collectionInset?() {
                return inset
            }
            return UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        }
    }
    private var scrollDirection : UICollectionView.ScrollDirection {
        get{
            if let direction  = self.delegate?.scrollDirection?() {
                return direction
            }
            return UICollectionView.ScrollDirection.vertical
        }
    }
    
    private var itemSize : CGSize {
        if let size = self.delegate?.itemSize?(){
            return size  
        }
        if self.scrollDirection == UICollectionView.ScrollDirection.horizontal{
            let insetWidth = self.collectionInset.top + self.collectionInset.bottom
            let itemMarginWidth = CGFloat(self.rowCount - 1 ) * itemMargin
            let itemWH = (self.collection.bounds.size.height - insetWidth - itemMarginWidth) / CGFloat(self.rowCount)
            return  CGSize(width: itemWH, height: itemWH)
        }else{
            let insetWidth = self.collectionInset.left + self.collectionInset.right
            let itemMarginWidth = CGFloat(self.columnCount - 1 ) * itemMargin
            let itemWH = (self.collection.bounds.size.width - insetWidth - itemMarginWidth) / CGFloat(self.columnCount)
            return CGSize(width: itemWH, height: itemWH)
        }
    }
    
    private var maxCount : Int{
        if let count = self.delegate?.maxCount?(){
            return count
        }else {
            return 9
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var collection  : UICollectionView!
    private var table : UITableView?
    private var collectionAssets : PHFetchResult<PHAsset> = PHFetchResult.init()
    lazy private var phtotModels : [PhotoItemModel] = {
        var temp = [PhotoItemModel]()
        //        let tempCollectionAssets : PHFetchResult<PHAsset> = PHFetchResult.init()
        for index  in  0..<self.collectionAssets.count{
            let asset = self.collectionAssets.object(at: index)
            let phtotItemModel = PhotoItemModel.init()
            phtotItemModel.asset = asset
            temp.append(phtotItemModel)
        }
        return temp
    }()
    private var tableModels : [NSObject]?
    private var albumName : String?
    //    private var  type : GDImagePickerviewType = .all
    weak var delegate : GDImagePickerviewDelegate?
    /// initialize the phtot pickerView
    ///
    /// - Parameters:
    ///   - albumName: the target photots of the album named albumName , first judge , if nil judge type paramete  , if not nil , ignore type paramete
    ///   - type: second judge , type of showing content
    ///   - deriction: scroll deriction
    override init(frame : CGRect ) {
        super.init(frame: frame)
        let flowLayout = UICollectionViewFlowLayout.init()
        collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        self.addSubview(collection)
        collection.backgroundColor = UIColor.white
        collection.allowsMultipleSelection = true
        collection.register(GDPhotoItem.self , forCellWithReuseIdentifier: "GDPhotoItem")
        self.getAllImages()
        
        self.collection.reloadData()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configCollection()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDImagePicker{
    func configTable()  {
        
    }
}
extension DDImagePicker : UICollectionViewDelegate , UICollectionViewDataSource{
    func configCollection()  {
        collection.frame = self.bounds
        collection.delegate = self
        collection.dataSource = self
        if let flowLayout  = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = self.itemMargin
            flowLayout.minimumLineSpacing = self.itemMargin
            flowLayout.sectionInset = self.collectionInset
            flowLayout.scrollDirection = self.scrollDirection
            flowLayout.itemSize = self.itemSize
        }
//        self.collection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.collectionAssets.count
        return self.phtotModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collection.dequeueReusableCell(withReuseIdentifier: "GDPhotoItem", for: indexPath)
        if let realItem  = item as? GDPhotoItem {
            realItem.delegate = self
            //            let asset = self.phtotModels[indexPath.item] //self.collectionAssets.object(at: indexPath.item)
            //            realItem.asset = asset
            let model = self.phtotModels[indexPath.item]
            if self.allIndexPathsOfSelectedItems.count >= maxCount {
                model.becomeGray = !model.isSelected
            }else{
                model.becomeGray = false
                
            }
            if !model.isSelected{model.showTitle = "✔︎"}//✓
            model.indexPath = indexPath
            realItem.model = model
        }
        
        return item
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //        mylog((collectionView.indexPathsForSelectedItems?.count ?? 0))
        return (collectionView.indexPathsForSelectedItems?.count ?? 0) >= maxCount ? false : true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var photos = [GDIBPhoto]()
        for item  in self.phtotModels {
            let tempModel = GDIBPhoto(dict: nil )
            tempModel.asset = item.asset
            photos.append(tempModel)
        }
        GDIBContentView(photos: photos, showingPage: indexPath.item)
        self.delegate?.clickAction?()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        mylog("取消选中:\(indexPath); 所有选中的indexpath : \(collectionView.indexPathsForSelectedItems)")
    }
}

import Photos
extension DDImagePicker{
    func getAllImages() {
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false )]
        let fetchResult = PHAsset.fetchAssets(with: options )
        self.collectionAssets = fetchResult
    }
    func done(){
        //       let result = self.collection.indexPathsForSelectedItems?.flatMap({ (indexPath) -> PHAsset  in
        //            return  self.collectionAssets.object(at: indexPath.item)
        //        })
        let result = self.allIndexPathsOfSelectedItems.flatMap({ (model) -> PHAsset  in
            return  model.asset!
        })
        self.delegate?.getSelectedPHAssets?(assets:result)
    }
}



extension DDImagePicker  : PhotoItemDelegate{
    func itemSelectBtnClick(item: GDPhotoItem) {
        item.model?.isSelected = !(item.model?.isSelected ?? false )
        
        item.setNeedsLayout()
        item.layoutIfNeeded()
        
        if  let model  = item.model{
            if model.isSelected{
                self.allIndexPathsOfSelectedItems.append(model)
            }else{
                if let index = self.allIndexPathsOfSelectedItems.index(of: model){
                    self.allIndexPathsOfSelectedItems.remove(at: index)
                }
            }
            print(model.indexPath)
            
            print("所以选中的indexPath:\(self.allIndexPathsOfSelectedItems)")
            for (index , selectedModel) in self.allIndexPathsOfSelectedItems.enumerated() {
                if let photoItem = self.collection.cellForItem(at: selectedModel.indexPath!) as? GDPhotoItem{
                    //                photoItem.selectBtn.setTitle("\(index+1)", for: UIControl.State.selected)
                    selectedModel.showTitle = "\(index+1)"
                    photoItem.setNeedsLayout()
                    photoItem.layoutIfNeeded()
                }
            }
            if allIndexPathsOfSelectedItems.count >= maxCount - 1 {
                self.collection.reloadData()
            }
        }
        self.delegate?.selectAction?()
    }
}

@objc  protocol PhotoItemDelegate {
    func itemSelectBtnClick(item:GDPhotoItem)
}
class PhotoItemModel: NSObject {
    var asset : PHAsset?
    var isSelected : Bool = false
    var showTitle = "✔︎"
    var indexPath : IndexPath?
    var becomeGray  : Bool = false
    
}
class GDPhotoItem: UICollectionViewCell {
    private let imageView = UIImageView()
    let selectBtn  = UIButton()
    weak var delegate : PhotoItemDelegate?
    var itemIsSelected:Bool {
        return self.selectBtn.isSelected
    }
    let SelectButtonH : CGFloat = 30
    var model : PhotoItemModel? {
        didSet{
            self.selectBtn.isSelected = model?.isSelected ?? false
            self.alpha = (model?.becomeGray ?? false ) ? 0.5 : 1
            if let indexPath  = model?.indexPath,  self.selectBtn.isSelected{
                self.selectBtn.setTitle(model?.showTitle , for: UIControl.State.selected)
            }
            self.configSelectBtnUI(isSelect: self.selectBtn.isSelected)
            if let asset  = model?.asset {
                PHImageManager.default().requestImage(for: asset, targetSize:CGSize(width: 300, height: 300   ), contentMode: PHImageContentMode.default, options: nil) { (imgOption , dictInfo) in
                    if let image = imgOption {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    //    var asset : PHAsset?{
    //        didSet{
    //            if let asset  = asset{
    //                PHImageManager.default().requestImage(for: asset, targetSize:CGSize(width: 100, height: 100   ), contentMode: PHImageContentMode.default, options: nil) { (imgOption , dictInfo) in
    //                    if let image = imgOption {
    //                        self.imageView.image = image
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(imageView)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(selectBtn)
        self.configSelectBtn()
    }
    
    func configSelectBtn() {
        self.selectBtn.setTitle("✔︎", for: UIControl.State.normal)
        self.selectBtn.bounds = CGRect(x: 0, y: 0, width: SelectButtonH, height: SelectButtonH)
        //        self.selectBtn.isUserInteractionEnabled = false
        self.selectBtn.addTarget(self , action: #selector(selectBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        self.configSelectBtnUI(isSelect: self.selectBtn.isSelected)
    }
    @objc func selectBtnClick(sender:UIButton) {
        if model?.becomeGray ?? false  {return}
        self.delegate?.itemSelectBtnClick(item: self)
        //        self.configSelectBtnUI(isSelect: sender.isSelected)
    }
    func configSelectBtnUI(isSelect:Bool)  {
        
        if isSelect {
//            selectBtn.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
            selectBtn.sizeToFit()
            let rempW = max(SelectButtonH, selectBtn.bounds.width)
            selectBtn.bounds = CGRect(x: 0, y: 0, width: rempW, height: SelectButtonH)
            selectBtn.frame = CGRect(x: self.bounds.width - self.selectBtn.bounds.width - 5 , y: 5, width: self.selectBtn.bounds.width, height: self.selectBtn.bounds.height)
            self.selectBtn.layer.cornerRadius = self.selectBtn.bounds.height/2
            self.selectBtn.layer.masksToBounds = true
            self.selectBtn.backgroundColor = UIColor.orange
            self.selectBtn.setTitle(model?.showTitle, for: UIControl.State.selected)
            self.selectBtn.layer.borderWidth = 0
            self.selectBtn.layer.borderColor = UIColor.orange.cgColor
        }else{
            self.selectBtn.bounds = CGRect(x: 0, y: 0, width: SelectButtonH, height: SelectButtonH)
            self.selectBtn.frame = CGRect(x: self.bounds.width - self.selectBtn.bounds.width - 5 , y: 5, width: self.selectBtn.bounds.width, height: self.selectBtn.bounds.height)
            self.selectBtn.layer.cornerRadius = self.selectBtn.bounds.width/2
            self.selectBtn.layer.masksToBounds = true
            self.selectBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
            self.selectBtn.layer.borderWidth = 1
            self.selectBtn.layer.borderColor = UIColor.clear.cgColor
            self.selectBtn.setTitle(model?.showTitle, for: UIControl.State.selected)
        }
    }
    //    override var isSelected: Bool{
    //        didSet{
    //            self.imageView.alpha = isSelected ? 0.5 : 1
    //            self.selectBtn.isSelected = isSelected
    //        }
    //
    //    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.selectBtn.isSelected = self.model?.isSelected ?? false
        self.configSelectBtnUI(isSelect: self.selectBtn.isSelected)
        
        self.selectBtn.frame = CGRect(x: self.bounds.width - self.selectBtn.bounds.width - 5 , y: 5, width: self.selectBtn.bounds.width, height: self.selectBtn.bounds.height)
    }
}
