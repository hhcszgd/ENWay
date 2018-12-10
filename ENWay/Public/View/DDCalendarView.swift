//
//  DDCalendarView.swift
//  Project
//
//  Created by WY on 2018/4/21.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
//
//class DDCalendarView: UIView {
//     let bar = DDNavigationItemBar.init(CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 34), DDOrderListNavibarItem.self)
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configBar()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//}
//extension DDCalendarView :  DDNavigationItemBarDelegate {
//    func configBar()  {
//        self.addSubview(bar)
//        bar.delegate = self
//        bar.selectedIndexPath = IndexPath(item: 0, section: 0)
//        bar.scrollDirection = .horizontal
//    }
//    func itemSizeOfNavigationItemBar(bar : DDNavigationItemBar) -> CGSize{
//        return CGSize(width: 44, height: 34)
//    }
//    func numbersOfNavigationItemBar(bar: DDNavigationItemBar) -> Int {
//        return 7
//    }
//    
//    func setParameteToItem(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
//        let arr = ["日","一","二","三","四","五","六"]
//        if let itemInstens = item as? DDOrderListNavibarItem{
//            itemInstens.selectedStatus = false
//            itemInstens.hidLeftJiange = true
//            itemInstens.hidRightJiange = true
//            itemInstens.label.text = "\(arr[indexPath.item])"
//        }
//    }
//    
//    func didSelectedItemOfNavigationItemBar(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
//        mylog(indexPath)
//    }
//}
