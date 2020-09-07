//
//  SwitchAnimationView.swift
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/12.
//  Copyright © 2020 widerness. All rights reserved.
//

import Foundation
import UIKit
import Lottie

public class SwicthAnimationView: UIView{
    
    //MARK: 属性
    
    /// 动画文件名
//    public var animationName:String? = nil
    
    
    private lazy var lottieView: AnimationView = {
        let view = AnimationView(name: "data")
        view.contentMode = .scaleAspectFit;
        view.loopMode = .autoReverse;
        view.backgroundBehavior = .pauseAndRestore
//        view.backgroundBehavior = .pause//pause是默认值
        /*
         backGroundBehavior这个属性，关系到生命周期，还是挺重要的
         */
        return view
    }()

    
    //MARK: 方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpSubViews();
    }

    required init?(coder aDecoder: NSCoder ) {
        super .init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUpSubViews(){
        self.addSubview(self.lottieView)
        self.lottieView.play()
    }
    

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.lottieView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
    }
    
    @objc public func play() {
        lottieView.play()
    }
    

    
}
