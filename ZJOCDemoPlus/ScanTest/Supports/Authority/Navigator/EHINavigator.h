//
//  EHINavigator.h
//  1haiiPhone
//
//  Created by LuckyCat on 2018/4/19.
//  Copyright © 2018年 EHi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EHINavigator : NSObject

#pragma mark - 传参说明（id可传类型：UIViewController对象/NSString/[UIViewController class]）

#pragma mark - Push/Present

+ (void)push:(id)viewController;
+ (void)push:(id)viewController animated:(BOOL)animated;
+ (void)push:(id)viewController extraParams:(NSDictionary *)extraParams;
+ (void)push:(id)viewController extraParams:(NSDictionary *)extraParams animated:(BOOL)animated;

+ (void)present:(id)viewController;
+ (void)present:(id)viewController animated:(BOOL)animated;
+ (void)present:(id)viewController extraParams:(NSDictionary *)extraParams;
+ (void)present:(id)viewController extraParams:(NSDictionary *)extraParams animated:(BOOL)animated;

+ (void)tabbarSelect:(id)viewController;
+ (void)tabbarSelect:(id)viewController extraParams:(NSDictionary *)extraParams animated:(BOOL)animated;
#pragma mark - Pop

+ (void)pop;
+ (void)pop:(BOOL)animated;
+ (void)popToRoot;
+ (void)popToRootAnimated:(BOOL)animated;
+ (void)popTo:(id)viewController;
+ (void)popTo:(id)viewController animated:(BOOL)animated;

#pragma mark - 获取

/** 获取当前nav */
+ (UINavigationController *)currentNavigationController;
/** 获取当前vc */
+ (UIViewController *)currentViewController;


/** 获取某个vc */
+ (UIViewController *)controllerWith:(id)viewController;
+ (UIViewController *)controllerWith:(id)viewController extraParams:(NSDictionary *)extraParams;

#pragma mark - Method

/** 判断是否是当前vc(只判断是同一个类,不区分是否是同一个对象) */
+ (BOOL)isMemberOfCurrentVC:(id)viewController;

/** 获取视图栈中的ViewController (默认正序)*/
+ (UIViewController *)obtainNavigationStackWithViewControllerName:(NSString *)vcName;
/** 获取视图栈中的ViewController reverse：是否倒序 */
+ (UIViewController *)obtainNavigationStackWithViewControllerName:(NSString *)vcName reverse:(BOOL)reverse;

/** 获得前面一个控制器 */
+ (UIViewController *)getPreController;
/** get previewcontroller clsName */
+ (NSString *)getPreControllerName;

@end
