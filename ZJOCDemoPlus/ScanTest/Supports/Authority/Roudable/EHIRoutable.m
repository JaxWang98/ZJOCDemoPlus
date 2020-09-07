//
//  EHIRoutable.m
//  1haiiPhone
//
//  Created by LuckyCat on 2018/4/19.
//  Copyright © 2018年 EHi. All rights reserved.
//

#import "RotationNavController.h"

typedef enum : NSUInteger {
    EHIRoutableOpenType_Push,
    EHIRoutableOpenType_Present,
} EHIRoutableOpenType;

@implementation EHIRoutable

#pragma mark - Push/Present

+ (void)push:(UIViewController *)viewController {
    [self push:viewController animated:YES];
}

+ (void)push:(UIViewController *)viewController animated:(BOOL)animated {
    [self open:viewController withType:EHIRoutableOpenType_Push animated:animated];
}

+ (void)present:(UIViewController *)viewController {
    [self present:viewController animated:YES];
}

+ (void)present:(UIViewController *)viewController animated:(BOOL)animated {
    [self open:viewController withType:EHIRoutableOpenType_Present animated:animated];
}

+ (void)open:(UIViewController *)viewController
    withType:(EHIRoutableOpenType)type
    animated:(BOOL)animated {
    if (viewController) {
        UINavigationController * nav = [self currentNavigationController];
        switch (type) {
            case EHIRoutableOpenType_Push: {
                viewController.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:viewController animated:animated];
            }
                break;
            case EHIRoutableOpenType_Present: {
                if ([viewController.class isSubclassOfClass:UINavigationController.class]) {
                    [nav presentViewController:viewController
                                      animated:animated
                                    completion:nil];
                } else {
                    RotationNavController *navigationController = [[RotationNavController alloc] initWithRootViewController:viewController];
                    navigationController.modalPresentationStyle = viewController.modalPresentationStyle;
                    navigationController.modalTransitionStyle = viewController.modalTransitionStyle;
                    [nav presentViewController:navigationController
                                      animated:animated
                                    completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Pop

+ (void)pop {
    [self pop:YES];
}

+ (void)pop:(BOOL)animated {
    UINavigationController * nav = [self currentNavigationController];
    if (nav.viewControllers.count == 1 && nav.presentingViewController) {
        [nav dismissViewControllerAnimated:animated completion:nil];
    } else {
        [nav popViewControllerAnimated:animated];
    }
}

+ (void)popToRoot {
    [self popToRootAnimated:NO];
}

+ (void)popToRootAnimated:(BOOL)animated {
    [[self currentNavigationController] popToRootViewControllerAnimated:animated];
}

+ (void)popTo:(UIViewController *)viewController {
    [self popTo:viewController animated:YES];
}

+ (void)popTo:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController * nav = [self currentNavigationController];
    for (UIViewController *temp in nav.viewControllers) {
        if ([NSStringFromClass([temp class]) isEqualToString:NSStringFromClass([viewController class])]) {
            [nav popToViewController:temp animated:animated];
        }
    }
}

#pragma mark - 获取当前UINavigationController

+ (UINavigationController *)currentNavigationController {
    id<UIApplicationDelegate>  dele = [UIApplication sharedApplication].delegate;
    UIViewController * vc = findBestNav(dele.window.rootViewController);
    NSAssert(vc && [vc isKindOfClass:[UINavigationController class]], @"未找到Nav: %@", vc);
    return (UINavigationController *)vc;
}

UIViewController * findBestNav(UIViewController * vc) {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        if (vc.presentedViewController && [vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
            return findBestNav(vc.presentedViewController);
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *sp = (UISplitViewController *)vc;
        return sp.viewControllers.count > 0 ? findBestNav(sp.viewControllers.lastObject) : nil;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *ta = (UITabBarController *)vc;
        return ta.viewControllers.count > 0 ? findBestNav(ta.selectedViewController) : nil;
    }
    return vc.navigationController;
}

#pragma mark - 获取当前UIViewController

+ (UIViewController *)currentViewController {
    id<UIApplicationDelegate>  dele = [UIApplication sharedApplication].delegate;
    UIViewController * vc = [self findBestVC:dele.window.rootViewController];
    NSAssert(vc && [vc isKindOfClass:[UIViewController class]], @"未找到VC: %@", vc);
    return vc;
}

+ (UIViewController *)findBestVC:(UIViewController *)vc {
    static UINavigationController * _navigationController;
    if (vc.presentedViewController) {
        return  [self findBestVC:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *sp = (UISplitViewController *)vc;
        return sp.viewControllers.count > 0 ? [self findBestVC:sp.viewControllers.lastObject] : vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        _navigationController = (UINavigationController *)vc;
        return _navigationController.viewControllers.count > 0 ? [self findBestVC:_navigationController.topViewController] : vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *ta = (UITabBarController *)vc;
        return ta.viewControllers.count > 0 ? [self findBestVC:ta.selectedViewController] : vc;
    }
    return vc;
}

@end
