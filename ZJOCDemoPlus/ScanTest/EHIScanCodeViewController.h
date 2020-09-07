//
//  EHIScanCodeViewController.h
//  QRCodeDemo
//
//  Created by LuckyCat on 2017/11/16.
//  Copyright © 2017年 zhangyaqiong. All rights reserved.
//
//  “扫码取车”页面
//

//#import "Template.h"
#import "WXAlertController.h"
#import "LBXScanTypes.h"

//@interface EHIScanCodeViewController : Template
@interface EHIScanCodeViewController : UIViewController


/** 重启扫描 */
- (void)reStartDevice;

/** 扫码结果获取 */
- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array;

/** 显示toast提示 */
- (void)showMessage:(NSString *)message;

/** 改变闪光灯按钮状态 */
- (void)changeTorchButtonState:(BOOL)isOpenFlash;

/** 扫码超时操作 */
- (void)scanTimeout;

/** 销毁定时器 */
- (void)releaseTimer;

@end
