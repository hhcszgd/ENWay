//
//  DDSearchLayout.swift
//  Project
//
//  Created by WY on 2017/11/2.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//
/*横向流水布局*/
import UIKit


@objc protocol DDSearchLayoutProtocol : NSObjectProtocol{
    func provideItemHeight(layout:DDSearchLayout?) -> CGFloat//定值
    func provideItemWidth(layout: DDSearchLayout? , indexPath:IndexPath) -> CGFloat//变值
    @objc optional func provideColumnMargin(layout:DDSearchLayout?) -> CGFloat
    @objc optional func provideRowMargin(layout:DDSearchLayout?) -> CGFloat
    @objc optional func provideEdgeInsets(layout:DDSearchLayout?) -> UIEdgeInsets
    @objc optional func provideSessionHeaderHeight(layout:DDSearchLayout?) -> CGFloat//定值
    @objc optional func provideSessionFooterHeight(layout:DDSearchLayout?) -> CGFloat//定值
}
class DDSearchLayout: UICollectionViewLayout {
    weak var  delegate :DDSearchLayoutProtocol?
    var sessionHeaderH   : CGFloat {
        return self.delegate?.provideSessionHeaderHeight?(layout: self) ?? 0
    }
    var sessionFooterH  : CGFloat {
        return self.delegate?.provideSessionFooterHeight?(layout: self) ?? 0
    }
    var columnMargin : CGFloat {
        if let columnMargin = self.delegate?.provideColumnMargin?(layout: self) {return  columnMargin}else{return 0}
    }
    var rowMargin: CGFloat{
        if let rowMargin = self.delegate?.provideRowMargin?(layout: self) {return  rowMargin}else{return 0}
    }
    var edgeInsets : UIEdgeInsets {
        if let edgeInsets = self.delegate?.provideEdgeInsets?(layout: self) {return  edgeInsets}else{return UIEdgeInsets.zero}
    }
    var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var maxY : CGFloat = 0
    var maxX : CGFloat = 0
//    var columns : [CGFloat] = [CGFloat]()
    override func prepare() {
        super.prepare()
        attributes.removeAll()
        maxY = 0
        maxX =  self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0
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
        if elementKind == UICollectionView.elementKindSectionHeader {
            let headerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            headerAttribute.frame = CGRect(x: 0, y: maxY , width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: sessionHeaderH)
            maxY += (rowMargin+sessionHeaderH)
            maxX = self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0 //换行
            return headerAttribute
        }else if elementKind == UICollectionView.elementKindSectionFooter{
            let footerAttribute  = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            footerAttribute.frame = CGRect(x: 0, y: maxY , width: self.collectionView?.bounds.width ?? UIScreen.main.bounds.width, height: sessionFooterH)
            maxY += sessionFooterH
            if indexPath.section+1 != self.collectionView?.numberOfSections ?? 1000{//最后一个尾不加行间距了
                maxY += rowMargin
            }
            maxX =  self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0 //huanhang
            return footerAttribute
        }
        return nil
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let collectionShowWidth = (self.collectionView?.bounds.size.width ?? UIScreen.main.bounds.width) - (self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0) - (self.delegate?.provideEdgeInsets?(layout: self ).right ?? 0)  //collection出去左右偏移量 , 可显示的最大宽度
        var leftShowWidth : CGFloat = 0
        var  width = self.delegate?.provideItemWidth(layout: self , indexPath:indexPath)  ?? 0
        let height = self.delegate?.provideItemHeight(layout: self) ?? 0
        if width >= collectionShowWidth {width = collectionShowWidth}
        var  x : CGFloat  = 0
        var y : CGFloat = 0
        if maxX == self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0{
            leftShowWidth = collectionShowWidth
            x = maxX
            y = maxY
            maxX += (width )//+ columnMargin)
        }else{
            maxX += columnMargin
            leftShowWidth = collectionShowWidth - maxX  + (self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0)//减的是坐标值,多减了个dorderleft 所以得加上
            if  width <= leftShowWidth {//继续往后排
                x = maxX
                y = maxY
                maxX += (width)// + columnMargin)
                
            }else{//换行 , Y值+行间距+itemH , x值为当前itemW
                maxX =  self.delegate?.provideEdgeInsets?(layout: self ).left ?? 0 //huanhang
                x = maxX
                maxY += (rowMargin + height)
                maxX += (width )// + columnMargin)
                y = maxY
            }
        }
        if let itemsCount = self.collectionView?.numberOfItems(inSection: indexPath.section), (itemsCount - 1 ) == indexPath.item{
                maxY += (height /*+ rowMargin*/)//最后一个结束后加上itemH
        }
        attribute.frame = CGRect(x: x , y: y , width: width, height: height)
        return attribute
    }
}
