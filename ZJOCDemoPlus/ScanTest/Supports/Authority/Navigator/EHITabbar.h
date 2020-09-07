//
//  EHITabbar.h
//  1haiiPhone
//
//  Created by dengwx on 2017/11/6.
//  Copyright © 2017年 EHi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHITabbarItem.h"

static NSString *const kEHITabBarItemAttributeTitle = @"EHITabBarItemAttributeTitle";
static NSString *const kEHITabBarItemAttributeNormalImageName = @"EHITabBarItemAttributeNormalImageName";
static NSString *const kEHITabBarItemAttributeSelectedImageName = @"EHITabBarItemAttributeSelectedImageName";
static NSString *const kEHITabBarItemAttributeType = @"EHITabBarItemAttributeType";

@class EHITabbar;

@protocol EHITabBarDelegate <NSObject>

- (BOOL)tabBar:(EHITabbar *)tabBar shouldSelectTabbarItem:(EHITabbarItem *)tabbarItem;

@end

@interface EHITabbar : UIView

/** 配置tabbar的数据源 */
@property (nonatomic, copy) NSArray<NSDictionary *> *tabBarItemAttributes;

/** 代理 */
@property (nonatomic, weak) id <EHITabBarDelegate> delegate;

/** 选中的item */
@property (nonatomic , assign) NSInteger selectedIndex ;

/** 选中的字体颜色 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/** 给item单独设置图片 */
- (void)setImageForTabbarItemIndex:(NSInteger)tabbarIndex
                          withName:(NSString *)imageName
                        withStatus:(UIControlState)tabbarStatus;

@end
