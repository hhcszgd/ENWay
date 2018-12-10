//
//  DDMidBigLayout.swift
//  Project
//
//  Created by WY on 2017/11/17.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDMidBigLayout: UICollectionViewFlowLayout {
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return super.layoutAttributesForItem(at: indexPath)
//    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let centerX = (self.collectionView?.bounds.width ?? 0) * 0.5
        
        let systemLayoutAttributes = super.layoutAttributesForElements(in: rect)
        let layoutAttributes = Array.init(systemLayoutAttributes ?? [])//用拷贝的副本
        var arrToReturn = [UICollectionViewLayoutAttributes]()
        for (_ , attribute) in layoutAttributes .enumerated() {
            let tempAttribute = attribute.copy() as! UICollectionViewLayoutAttributes//copy first
            let offsetX = (collectionView?.contentOffset.x ?? 0)
            let scale = 1 - abs(tempAttribute.center.x - offsetX - centerX) / (self.collectionView?.bounds.width ?? 110)
            tempAttribute.transform = CGAffineTransform.init(scaleX: scale, y: scale )
//              var  transform   = CATransform3D()
//            transform.m34 = scale
//            attribute.transform3D = transform
            arrToReturn.append(tempAttribute)
            
        }
        return arrToReturn // layoutAttributes
    }
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let result = proposedContentOffset.x / self.itemSize.width //忽略itemMargin
        let offsetx = (result - CGFloat(Int(result))) * self.itemSize.width
        let cha = offsetx > self.itemSize.width/2 ? (self.itemSize.width -  offsetx) : -offsetx
        return CGPoint(x: proposedContentOffset.x + cha  + 0 , y:  0)
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {//当bounds改变是是否更新layout
        return true
    }
}
