//
//  ZJDemoRootViewModel.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//

#import "ZJDemoRootViewModel.h"
#import "ZJDemoRootListItemModel.h"


@implementation ZJDemoRootViewModel

//MARK: 改进的点，数据存在本地,encode，decode一下


- (void)refreshUIWithData:(refreshUIDataBlock)refreshBlock{
    //定义假数据
    NSMutableArray<ZJDemoRootListItemModel *> *dataArray  = [NSMutableArray array];
    
    ZJDemoRootListItemModel *GCDItem = [[ZJDemoRootListItemModel alloc]init];
    GCDItem.title = @"GCD测试，飞哥问题测试";
    GCDItem.vc = @"GCDViewController";
    [dataArray addObject:GCDItem];
    
    ZJDemoRootListItemModel *GCDBeanItem = [[ZJDemoRootListItemModel alloc]init];
    GCDBeanItem.title = @"GCD顺序问题，兵哥测试";
    GCDBeanItem.vc = @"GCDBeanTestViewController";
    [dataArray addObject:GCDBeanItem];
    
    ZJDemoRootListItemModel *LottieSwiftItem = [[ZJDemoRootListItemModel alloc]init];
    LottieSwiftItem.title = @"Lottie3.1.8测试，OC调用Swift库";
    LottieSwiftItem.vc = @"LottieViewController";
    [dataArray addObject:LottieSwiftItem];
    
    ZJDemoRootListItemModel *LockItem = [[ZJDemoRootListItemModel alloc]init];
    LockItem.title = @"线程锁问题";
    LockItem.vc = @"ThreadLockViewController";
    [dataArray addObject:LockItem];
    
    ZJDemoRootListItemModel *scanItem = [[ZJDemoRootListItemModel alloc]init];
    scanItem.title = @"EHi扫码测试";
    scanItem.vc = @"EHIScanCodeViewController";
    [dataArray addObject:scanItem];
    
    
    for (int i = 0; i < 6; i ++) {
        ZJDemoRootListItemModel *emptyItem = [[ZJDemoRootListItemModel alloc]init];
        emptyItem.title = @"暂时空缺";
        [dataArray addObject:emptyItem];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (refreshBlock) {
            refreshBlock(dataArray);
        }
    });
    NSLog(@"数据加载完毕");
    
}

@end
