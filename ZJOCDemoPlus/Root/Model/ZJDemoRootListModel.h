//
//  ZJDemoRootListModel.h
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJDemoRootListItemModel : NSObject


/// 标题
@property (nonatomic, strong) NSString *title;

/// 对应的viewController
@property (nonatomic, strong) UIViewController *vc;


@end
NS_ASSUME_NONNULL_END
