//
//  EHIAuthorityManager.h
//  test
//
//  Created by 杨明鑫 on 2017/12/20.
//  Copyright © 2017年 yangmingxin. All rights reserved.
//
//  权限统一管理
//  相机、相册、日历权限检测
//  只有用户设置了权限不允许才会执行失败block，默认实现失败block
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EHIAuthorityType) {
    /** 相机 */
    EHIAuthorityTypeCamera,
    /** 相册 */
    EHIAuthorityTypeAssetsLibrary,
    /** 日历 */
    EHIAuthorityTypeCalendar,
};

typedef void (^Callback)();
@interface EHIAuthorityManager : NSObject

/** 检测权限：enable */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable;

/** 检测权限：enable、superVC */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable superVC:(UIViewController *)superVC;

/** 检测权限：enable、unenable */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable unenable:(Callback)unenable;

@end
