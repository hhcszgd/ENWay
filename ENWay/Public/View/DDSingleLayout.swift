//
//  DDSingleLayout.swift
//  Project
//
//  Created by WY on 2017/11/21.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
/// virtical scroll

import UIKit
@objc protocol DDSingleLayoutProtocol : NSObjectProtocol{
    func provideItemHeight(layout:DDSingleLayout? ,indexPath:IndexPath ) -> CGFloat//变值
    @objc optional func provideItemWidth(layout: DDSingleLayout? , indexPath:IndexPath) -> CGFloat//定值
//    @objc optional func provideColumnMargin(layout:DDSearchLayout?) -> CGFloat
    @objc optional func provideRowMargin(layout:DDSingleLayout? , indexPath:IndexPath) -> CGFloat
    @objc optional func provideEdgeInsets(layout:DDSingleLayout?) -> UIEdgeInsets
    @objc optional func provideSessionHeaderHeight(layout:DDSingleLayout? , section : Int) -> CGFloat//若为零请隐藏header的子控件
    @objc optional func provideSessionFooterHeight(layout:DDSingleLayout? , section : Int) -> CGFloat//同上
    
    @objc optional func provideToSessionHeaderMargin(layout:DDSingleLayout? , section : Int) -> CGFloat//
    @objc optional func provideToSessionFooterMargin(layout:DDSingleLayout? , section : Int) -> CGFloat//
    @objc optional func provideToSessionFooterToHeaderMargin(layout:DDSingleLayout? , section : Int) -> CGFloat//
}
class DDSingleLayout: UICollectionViewLayout {
    
    weak var  delegate :DDSingleLayoutProtocol?
    var edgeInsets : UIEdgeInsets {
        if let edgeInsets = self.delegate?.provideEdgeInsets?(layout: self) {return  edgeInsets}else{return UIEdgeInsets.zero}
    }
    var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var maxY : CGFloat = 0
    var itemX : CGFloat = 0
    //    var columns : [CGFloat] = [CGFloat]()
    override func prepare() {
        super.prepare()
        attributes.removeAll()
        maxY = 0
        itemX =  self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0
        let sectionCount = self.collectionView?.numberOfSections ?? 0
        for sectionIndex  in 0..<sectionCount {
            if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: sectionIndex)){
                attributes.append(header)
            }
            let itemsCount = self.collectionView?.numberOfItems(inSection: sectionIndex) ?? 0
            for itemIndex  in 0..<itemsCount {
                let currentIndex = IndexPath(item: itemIndex, section: sectionIndex)
                if let attribute = self.layoutAttributesForItem(at: currentIndex){
                    attributes.append(attribute)
                }
            }
            if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: sectionIndex)){
                attributes.append(header)
            }
        }
    }
    override var collectionViewContentSize: CGSize{
        return CGSize(width: self.collectionView?.bounds.size.width ?? UIScreen.main.bounds.size.width, height: maxY )//+ rowMargin + (self.delegate?.provideItemHeight(layout: self) ?? 0))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        let rowMargin = self.delegate?.provideRowMargin?(layout: self , indexPath: indexPath) ?? 0
        if elementKind == UICollectionView.elementKindSectionHeader {
            let sectionHeaderH  = self.delegate?.provideSessionHeaderHeight?(layout: self , section: indexPath.section) ?? 0
            let headerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            headerAttribute.frame = CGRect(x: 0, y: maxY , width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: sectionHeaderH)
            let itemToHeaderMargin = self.delegate?.provideToSessionHeaderMargin?(layout: self , section: indexPath.section) ?? 0
            maxY += (itemToHeaderMargin+sectionHeaderH)
            return headerAttribute
        }else if elementKind == UICollectionView.elementKindSectionFooter{
            let sectionFooterH  = self.delegate?.provideSessionFooterHeight?(layout: self , section: indexPath.section) ?? 0
            let footerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            footerAttribute.frame = CGRect(x: 0, y: maxY , width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: sectionFooterH)
            let footerToHeaderMargin = self.delegate?.provideToSessionFooterToHeaderMargin?(layout: self , section: indexPath.section) ?? 0
            maxY += sectionFooterH
            if indexPath.section+1 != self.collectionView?.numberOfSections ?? 1000{//最后一个尾不加行间距了
                maxY += footerToHeaderMargin
            }
            return footerAttribute
        }
        return nil
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let rowMargin = self.delegate?.provideRowMargin?(layout: self , indexPath: indexPath) ?? 0
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let collectionWW = ((collectionView?.bounds.width ?? UIScreen.main.bounds.width) - ( (self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0 ) + ((self.delegate?.provideEdgeInsets?(layout: self ).right ?? 0 ) )))
        let  width = self.delegate?.provideItemWidth?(layout: self , indexPath:indexPath)  ?? collectionWW
        
        
        let height = self.delegate?.provideItemHeight(layout: self , indexPath  : indexPath) ?? 0
        let  x : CGFloat  = itemX
        let  y : CGFloat = maxY
        maxY +=  height
        if let itemsCount = self.collectionView?.numberOfItems(inSection: indexPath.section), (itemsCount - 1 ) == indexPath.item{
            let itemToFooterMargin = self.delegate?.provideToSessionFooterMargin?(layout: self , section: indexPath.section) ?? 0
            maxY += itemToFooterMargin//最后一个结束后加上距footer的距离
        }else{
            maxY += rowMargin
        }
        attribute.frame = CGRect(x: x , y: y , width: width, height: height)
        return attribute
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
