//
//  EHIAuthorityManager.m
//  test
//
//  Created by 杨明鑫 on 2017/12/20.
//  Copyright © 2017年 yangmingxin. All rights reserved.
//

/**
 version <= iOS7 ,  只能跳转到 系统设置页面
 version >= iOS8，支持跳转到自己应用设置
 UIApplicationOpenSettingsURLString字段，是在iOS8上才提供的，支持iOS8,iOS9,iOS10系统，推荐使用。
 version >= iOS10，支持跳转到自己应用设置，不支持跳转到系统设置
 */

#import "EHIAuthorityManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <EventKit/EventKit.h>

#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG
//#import "EHIRoutable.h"
#import "EHINavigator.h"
#endif

static NSString *const CAMERA_FAIL_HINT = @"相机权限暂未开启\n请在系统设置中开启相机服务\n(设置>隐私>相机>开启)";
static NSString *const PHOTO_FAIL_HINT = @"相册权限暂未开启\n请在系统设置中开启相册服务\n(设置>隐私>相册>开启)";
static NSString *const CALENDAR_FAIL_HINT = @"日历权限暂未开启\n请在系统设置中开启日历服务\n(设置>隐私>日历>开启)";
static NSString *const HINT_TITLE = @"提示";
static NSString *const LEFT_BUTTON_TEXT = @"取消";
static NSString *const RIGHT_BUTTON_TEXT = @"去设置";

@implementation EHIAuthorityManager

/** 检测权限：enable */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable {
    return [self authorityType:type enable:enable superVC:nil];
}

/** 检测权限：enable、superVC */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable superVC:(UIViewController *)superVC {
    return [self authorityType:type enable:enable unenable:nil superVC:superVC];
}

/** 检测权限：enable、unenable */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable unenable:(Callback)unenable {
    return [self authorityType:type enable:enable unenable:unenable superVC:nil];
}

#pragma mark - Base

/** 检测权限 */
+ (BOOL)authorityType:(EHIAuthorityType)type enable:(Callback)enable unenable:(Callback)unenable superVC:(UIViewController *)superVC {
    BOOL authorityEnable = NO;
    switch (type) {
        case EHIAuthorityTypeCamera:
            authorityEnable = [self authorityCamera];
            break;
        case EHIAuthorityTypeAssetsLibrary:
            authorityEnable = [self authorityAssetsLibrary];
            break;
        case EHIAuthorityTypeCalendar:
            authorityEnable = [self authorityCalendar];
        default:
            break;
    }
    // 执行通过权限对应的回调
    if (authorityEnable) {
        if (enable) {
            enable();
        }
    } else {
        [self popAlertWithAuthorityType:type superVC:superVC];
        if (unenable) {
            unenable();
        }
    }
    return authorityEnable;
}

#pragma mark - Method

/** 弹框提示 */
+ (void)popAlertWithAuthorityType:(EHIAuthorityType)type superVC:(UIViewController *)superVC {
    if (!superVC) {
#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG
        superVC = [EHINavigator currentViewController];
        return;
#endif
//        superVC = [EHIRoutable currentViewController];

    }
    NSString *message = @"暂未开启权限";
    
    switch (type) {
        case EHIAuthorityTypeCamera:
            message = CAMERA_FAIL_HINT;
            break;
        case EHIAuthorityTypeAssetsLibrary:
            message = PHOTO_FAIL_HINT;
            break;
        case EHIAuthorityTypeCalendar:
            message = CALENDAR_FAIL_HINT;
            break;
        default:
            break;
    }
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:HINT_TITLE message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:LEFT_BUTTON_TEXT style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionSetup = [UIAlertAction actionWithTitle:RIGHT_BUTTON_TEXT style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openTheURL:[self getApplactionSetupURL]];
    }];
    
    [alertView addAction:actionCancel];
    [alertView addAction:actionSetup];
    
    [superVC presentViewController:alertView animated:YES completion:nil];
}

/** 相机权限 */
+(BOOL)authorityCamera {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    // 客户端未被授权访问硬件的媒体类型。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
    // 明确拒绝用户访问硬件支持的媒体类型的客户
    if(authStatus == AVAuthorizationStatusRestricted  || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

/** 相册权限 */
+ (BOOL)authorityAssetsLibrary {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

/** 日历权限 */
+ (BOOL)authorityCalendar {
    static EKEventStore *store = nil;
    if (!store) {
        store = [[EKEventStore alloc] init];
    }
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        // nothing to do
    }];
    EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (EKstatus == EKAuthorizationStatusRestricted || EKstatus == EKAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}

/** 获取到应用设置的URL */
+ (NSURL *)getApplactionSetupURL {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    return url;
}

/** 应用打开URL */
+ (void)openTheURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];
    // iOS 10及以上
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        [application openURL:url];
    }
}

@end


