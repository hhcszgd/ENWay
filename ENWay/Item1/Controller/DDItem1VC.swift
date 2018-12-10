//
//  DDItem1VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import CryptoSwift
import CoreLocation
class DDItem1VC: DDNormalVC , UITextFieldDelegate{
    var collection : UICollectionView!
    let sectionHeaderH : CGFloat = 280 * SCALE
    var apiModel = ApiModel<HomeDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.title = "audio"    }
   
    func performRequestApi(complated:((Bool)->())? = nil )  {
        DDRequestManager.share.homePage( true)?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<HomeDataModel>.self, from: response){
                self.apiModel = apiModel
                self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
                self.collection.reloadData()
                complated?(true)
                
            }else{
                complated?(false)
                self.collection.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
            }
        })
    }
    
    func configCollectionView()  {
        let toBorderMargin :CGFloat  = 10
        let itemMargin  : CGFloat = 15
        let itemCountOneRow = 4
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: toBorderMargin, bottom: 0, right: toBorderMargin)
        let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
        let itemH = itemW * 1.33
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  DDNavigationBarHeight , width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.snp.makeConstraints { (make ) in
            let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
            make.top.equalTo(self.view).offset(h)
            make.left.right.bottom.equalTo(self.view)
        }
        collection.backgroundColor = UIColor.brown
        
        
        collection.register(HomeItem.self , forCellWithReuseIdentifier: "HomeItem")
        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false 
        mylog(self.view.bounds.height)
        
    }

    
    /// invoke before retate
    ///
    /// - Parameters:
    ///   - size:  the size whick will transition to
    ///   - coordinator: ~~~~
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: collection, animation: { (context ) in
            mylog("animating")
            mylog("1 -> \(size)")
        }) { (context ) in
            mylog("complated animate")
            self.collection.snp.remakeConstraints { (make ) in
                let h = (self.navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.height
                make.top.equalTo(self.view).offset(h)
                make.left.right.bottom.equalTo(self.view)
                mylog("2 -> \(size)")
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}



extension DDItem1VC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
        var targetVC : UIViewController!
        let model = apiModel.data?.function[indexPath.item]
        let target = model?.target ?? ""
        switch target {
        case "guanggao":
            self.pushVC(vcIdentifier: "DDSalemanmoOrderListVC")
            return
        default:
            return
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionView.elementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader", for: indexPath) as? HomeSectionHeader{
                header.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: sectionHeaderH)
                return header
                
            }
        }else if kind == UICollectionView.elementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter", for: indexPath)
            footer.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 0)
            return footer
        }
        return UICollectionReusableView.init()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data?.function.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItem", for: indexPath)
        if let itemUnwrap = item as? HomeItem , let model = self.apiModel.data?.function[indexPath.item]{
            itemUnwrap.model = model
        }
//        item.backgroundColor = UIColor.randomColor()
        return item
    }

}
import SDWebImage
class HomeItem : UICollectionViewCell {
    var model : DDHomeFoundation = DDHomeFoundation(){
        didSet{
            if let url  = URL(string:model.image_url) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
            label.text = model.name
        }
    }
    
    
    let imageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView )
        self.contentView.addSubview(label )
        label.text = "exemple"
        label.textAlignment = .center
        label.textColor = UIColor.DDSubTitleColor
        label.font = GDFont.systemFont(ofSize: 13.4)
        label.adjustsFontSizeToFitWidth = true 
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0 , y : 0 , width : self.bounds.width , height : self.bounds.width)
        label.frame = CGRect(x:0  , y : imageView.frame.maxY , width : self.bounds.width , height : self.bounds.height - self.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HomeSectionHeader: HomeReusableHeader  {
 
}

class HomeSectionFooter: HomeReusableHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
