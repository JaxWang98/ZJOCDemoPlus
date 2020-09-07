//
//  AppDelegate.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//

#import "AppDelegate.h"
#import "ZJDemoRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    ZJDemoRootViewController *vc = [[ZJDemoRootViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = navc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
