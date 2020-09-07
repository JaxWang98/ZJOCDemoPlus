//
//  LottieViewController.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/12.
//  Copyright © 2020 widerness. All rights reserved.
//

#import "LottieViewController.h"
#import "ZJOCDemoPlus-Swift.h"

@interface LottieViewController ()

@property (nonatomic, strong) SwicthAnimationView *lottieView;
@end

@implementation LottieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Lottie";
    
    self.lottieView = [[SwicthAnimationView alloc]init];
    self.lottieView.frame = CGRectMake(0, 0, 100, 100);
    self.lottieView.center = self.view.center;
    [self.view addSubview:self.lottieView];
    
    
    [self.lottieView play];
    
}


@end
