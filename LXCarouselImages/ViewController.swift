//
//  ViewController.swift
//  LXCarouselImages
//
//  Created by 李星星 on 2016/12/17.
//  Copyright © 2016年 李星星. All rights reserved.
//

import UIKit

class ViewController: UIViewController,clickImageViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加轮播图
        let showView = LXShowView.init(frame: CGRect(x:0,y:20,width:self.view.frame.size.width,height:200))
        showView.isUserInteractionEnabled = true
        showView.delegate = self
        //关闭定时器
//        showView.isOpenTimer = false
        self.view.addSubview(showView)
        
        //数据
        let path = Bundle.main.path(forResource: "imageData", ofType: "json")
        let jsonData = NSData.init(contentsOfFile: path!)
        //方法1 使用NSJSONSerialization解析
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData! as Data, options:[]) as! [String:AnyObject]
            
            let array=json["json"] as! NSArray
            
            for imageData in array{
                
               let dict = imageData as! NSDictionary
                
//                print(dict["title"]!)
                let model = Model.init(imageName: dict["imageName"] as! String, title: dict["title"] as! String)
                showView.dataArray.append(model)
            }
        }catch let error as NSError{
            print("解析出错。\(error.localizedDescription)")
            
        }
        
        
    }
    
    //点击轮播图
    func clickImageView(index:NSInteger){
        print("点击第\(index)个")
    }
    
    
    
    
    
    
}

