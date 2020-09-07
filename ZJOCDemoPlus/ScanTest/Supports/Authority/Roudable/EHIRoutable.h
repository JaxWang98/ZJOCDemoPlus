//
//  EHIRoutable.h
//  1haiiPhone
//
//  Created by LuckyCat on 2018/4/19.
//  Copyright © 2018年 EHi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHIRoutable : NSObject

#pragma mark - Push/Present

+ (void)push:(UIViewController *)viewController;

+ (void)push:(UIViewController *)viewController animated:(BOOL)animated;

+ (void)present:(UIViewController *)viewController;

+ (void)present:(UIViewController *)viewController animated:(BOOL)animated;

#pragma mark - Pop

+ (void)pop;

+ (void)pop:(BOOL)animated;

+ (void)popToRoot;

+ (void)popToRootAnimated:(BOOL)animated;

+ (void)popTo:(UIViewController *)viewController;

+ (void)popTo:(UIViewController *)viewController animated:(BOOL)animated;

#pragma mark - 获取当前UINavigationController

+ (UINavigationController *)currentNavigationController;

#pragma mark - 获取当前UIViewController

+ (UIViewController *)currentViewController;

@end
