//
//  LXShowBtnImage.swift
//  LXCarouselImages
//
//  Created by 李星星 on 2016/12/19.
//  Copyright © 2016年 李星星. All rights reserved.
//

import UIKit

class LXShowBtnImage: UIButton {

    public var label_title = UILabel()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        label_title.frame = CGRect(x:0,y:self.frame.size.height - 18,width:self.frame.size.width,height:18)
        label_title.backgroundColor = UIColor.lightGray
        label_title.textAlignment = .left
        self.addSubview(label_title)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
