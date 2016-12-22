//
//  LXShowView.swift
//  LXCarouselImages
//
//  Created by 李星星 on 2016/12/17.
//  Copyright © 2016年 李星星. All rights reserved.
//

import UIKit

//轮播对象的Model
class Model {
    
    let imageName: String
    let title: String
    
    init(imageName:String,title: String) {
        self.imageName = imageName
        self.title = title
    }
}

protocol clickImageViewDelegate:NSObjectProtocol {
    func clickImageView(index:NSInteger)
}

enum ScrollViewSlideType {
    case Timer//定时器调用轮播
    case Nomal//正常(起到一个条件限制的作用)
    case Touch//手动滑动轮播
}

class LXShowView: UIView,UIScrollViewDelegate {
    
    var delegate:clickImageViewDelegate?
    //默认开启定时器,可以选择关闭
    public var isOpenTimer:Bool = true
    
    private var myTimer = Timer()
    var scrollViewSlideType = ScrollViewSlideType.Nomal
    
    public var dataArray = Array<Model>()
    
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    
    private var middleImageIndex:NSInteger = 0
    private var leftBtnImage:LXShowBtnImage!
    private var rightBtnImage:LXShowBtnImage!
    private var middleBtnImage:LXShowBtnImage!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = .red
        scrollView.frame = CGRect(x:0,y:0,width:frame.width,height:frame.height)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        self.addSubview(scrollView)
        
        pageControl.frame = CGRect(x:0,y:frame.size.height - 30,width:frame.size.width,height:12)
        pageControl.currentPageIndicatorTintColor = UIColor.red
        self.addSubview(pageControl)
        
    }
    
    override func didMoveToWindow() {
        
        scrollView.contentSize = CGSize(width:scrollView.frame.size.width * CGFloat(3),height:scrollView.frame.size.height)
        pageControl.numberOfPages = dataArray.count
        //初始化三个imageView
        leftBtnImage = LXShowBtnImage.init(frame: CGRect(x:0,y:0,width:self.frame.size.width,height:self.frame.size.height))
        middleBtnImage = LXShowBtnImage.init(frame: CGRect(x:leftBtnImage.frame.maxX,y:0,width:self.frame.size.width,height:self.frame.size.height))
        rightBtnImage = LXShowBtnImage.init(frame: CGRect(x:middleBtnImage.frame.maxX,y:0,width:self.frame.size.width,height:self.frame.size.height))
        
        leftBtnImage.setBackgroundImage(UIImage.init(named: dataArray[dataArray.count - 1].imageName), for: .normal)
        leftBtnImage.label_title.text = dataArray[dataArray.count - 1].title
        
        middleBtnImage.setBackgroundImage(UIImage.init(named: dataArray[0].imageName), for: .normal)
        middleBtnImage.label_title.text = dataArray[0].title
        
        rightBtnImage.setBackgroundImage(UIImage.init(named: dataArray[1].imageName), for: .normal)
        rightBtnImage.label_title.text = dataArray[1].title
        
        
        scrollView.addSubview(leftBtnImage)
        scrollView.addSubview(middleBtnImage)
        scrollView.addSubview(rightBtnImage)
        
        
        middleBtnImage.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        leftBtnImage.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        rightBtnImage.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        scrollView.contentOffset = CGPoint(x:scrollView.frame.size.width,y:0)
        
        creationTimer()
        
    }
    
    func creationTimer(){
        myTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(beginShowImage), userInfo: nil, repeats: true)
    }
    
    func beginShowImage(){
        
        if isOpenTimer {
            //更新page
            pageControl.currentPage = (middleImageIndex+1) % dataArray.count
            scrollView.setContentOffset(CGPoint(x:self.scrollView.frame.size.width*2,y:0), animated: true)
            reloadImageView()
            
            if scrollView.contentOffset.x > scrollView.frame.size.width*1.3 {

                scrollView.setContentOffset(CGPoint(x:scrollView.frame.size.width,y:0), animated: false)
                reloadImageView()

            }
            
            scrollViewSlideType = ScrollViewSlideType.Timer
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //每次偏移结束,用这个方法来刷新数据用
    func reloadImageView(){
        
        var offset = scrollView.contentOffset
        
        if  scrollViewSlideType == ScrollViewSlideType.Touch{
            offset.x = offset.x + scrollView.frame.size.width
        }

        if offset.x > scrollView.frame.size.width*1.5 {
            
            middleImageIndex = (middleImageIndex + 1) % dataArray.count
            
        }else if offset.x < scrollView.frame.size.width*0.5 {
            middleImageIndex = (middleImageIndex - 1) % dataArray.count
            
            if middleImageIndex < 0 {
                middleImageIndex = dataArray.count + middleImageIndex
            }
            
        }
        
        let leftImageIndex = middleImageIndex == 0 ? (dataArray.count - 1) : (middleImageIndex - 1) % dataArray.count
        let rightImageIndex = middleImageIndex == dataArray.count ? 0 : (middleImageIndex + 1) % dataArray.count
        //更新UI
        //手动滑动更新新page
        if scrollViewSlideType == ScrollViewSlideType.Nomal {
            pageControl.currentPage = middleImageIndex
        }
        leftBtnImage.setBackgroundImage(UIImage.init(named: dataArray[leftImageIndex].imageName), for: .normal)
        leftBtnImage.label_title.text = dataArray[leftImageIndex].title
        
        middleBtnImage.setBackgroundImage(UIImage.init(named: dataArray[middleImageIndex].imageName), for: .normal)
        middleBtnImage.label_title.text = dataArray[middleImageIndex].title
        
        rightBtnImage.setBackgroundImage(UIImage.init(named: dataArray[rightImageIndex].imageName), for: .normal)
        rightBtnImage.label_title.text = dataArray[rightImageIndex].title
    }
    
    func btnClick(){
        //通过代理找到当前的索引
        if delegate != nil {
            delegate?.clickImageView(index: middleImageIndex)
        }
    }
    
    //  MARK: scrollView delegate
    
    //开始滑动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if myTimer.isValid && scrollViewSlideType == ScrollViewSlideType.Timer{
            
            scrollViewSlideType = ScrollViewSlideType.Touch
        }
        
        myTimer.invalidate()// 停用
        
        scrollView.setContentOffset(CGPoint(x:scrollView.frame.size.width,y:0), animated: false)
        reloadImageView()
        
    }
    //滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //无效,重新创建
        if !myTimer.isValid {
            creationTimer()
            scrollViewSlideType = ScrollViewSlideType.Nomal
        }
    }
    
    
    //开始减速
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    //减速结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        reloadImageView()
        scrollView.setContentOffset(CGPoint(x:scrollView.frame.size.width,y:0), animated: false)
    }
}





