//
//  GDIBCollectionCell.swift
//  zjlao
//
//  Created by WY on 04/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDIBCollectionCell: UICollectionViewCell {
    var scrollView  : GDIBScrollView!
    
    var photo : GDIBPhoto?{
//        willSet{
//                scrollView.photo = newValue
//        }
        didSet{
            scrollView.photo = photo
            scrollView.frame = self.bounds
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.contentView.backgroundColor = UIColor.black
        self.configScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        scrollView.frame = self.bounds
    }
    
    
    override func prepareForReuse() {
        scrollView.prepareForReuse()
    }
}


extension GDIBCollectionCell {
    func configScrollView ()  {
        self.scrollView = GDIBScrollView(frame: self.bounds)
        self.addSubview(scrollView)
        scrollView.frame = self.bounds
    }
}
