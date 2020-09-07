//
//  EHIScanCodeNetAnimation.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/11/3.
//  Copyright © 2015年 lbxia. All rights reserved.
//
//  网格动画
//

#import <UIKit/UIKit.h>

@interface EHIScanCodeNetAnimation : UIView

/**
 *  开始扫码网格效果
 *
 *  @param animationRect 显示在parentView中的区域
 *  @param parentView    动画显示在UIView
 *  @param image         扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage *)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end