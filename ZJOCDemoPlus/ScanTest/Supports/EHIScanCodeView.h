//
//  EHIScanCodeView.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/11/15.
//  Copyright © 2015年 lbxia. All rights reserved.
//
//  扫码区域
//

#import <UIKit/UIKit.h>
#import "EHIScanCodeNetAnimation.h"

#define LBXScan_Define_UI

@interface EHIScanCodeView : UIView

/** 四个角区域 */
@property (nonatomic, assign) CGRect cornerRect;

/** 初始化 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  设备启动中文字提示
 */
- (void)startDeviceReadyingWithText:(NSString *)text;

/**
 *  设备启动完成
 */
- (void)stopDeviceReadying;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

/** 识别区域计算 */
- (CGRect)qrCodeRecognizeScanRect;

@end
