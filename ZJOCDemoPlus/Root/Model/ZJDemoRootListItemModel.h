//
//  ZJDemoRootListModel.h
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//
/*
    主页tableView的模型列表
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJDemoRootListItemModel : NSObject


/// 标题
@property (nonatomic, strong) NSString *title;

/// 对应的viewController
@property (nonatomic, strong) NSString *vc;

//- (instancetype)initWithTitle:(NSString *)title;

@end
NS_ASSUME_NONNULL_END
