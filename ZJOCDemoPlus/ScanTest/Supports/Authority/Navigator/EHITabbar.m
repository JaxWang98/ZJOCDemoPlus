//
//  EHITabbar.m
//  1haiiPhone
//
//  Created by dengwx on 2017/11/6.
//  Copyright © 2017年 EHi. All rights reserved.
//

#import "EHITabbar.h"

@interface EHITabbar()

@property (strong, nonatomic) NSMutableArray *tabBarItems;

@end

@implementation EHITabbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)config {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, SINGLE_LINE_WIDTH)];
    lineView.backgroundColor=kEHIHexColor_EEEEEE;
    [self addSubview:lineView];
}

/** 给item单独设置图片 */
- (void)setImageForTabbarItemIndex:(NSInteger)tabbarIndex
                          withName:(NSString *)imageName
                        withStatus:(UIControlState)tabbarStatus {
    
    if (tabbarIndex >= self.tabBarItems.count) {
        
        return;
    }
    EHITabbarItem *tabBarItem = self.tabBarItems[tabbarIndex];
    [tabBarItem setImage:[UIImage imageNamed:imageName] forState:tabbarStatus];
    
}

- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes {
    _tabBarItemAttributes = tabBarItemAttributes.copy;
    
    CGFloat itemWidth = Main_Screen_Width / _tabBarItemAttributes.count;
    CGFloat tabBarHeight = CGRectGetHeight(self.frame);
    NSInteger itemTag = 0;
    
    _tabBarItems = [NSMutableArray arrayWithCapacity:_tabBarItemAttributes.count];
    for (id item in _tabBarItemAttributes) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = (NSDictionary *)item;
            
            CGRect frame = CGRectMake(itemTag * itemWidth , 0, itemWidth, tabBarHeight);
            
            EHITabbarItem *tabBarItem = [self tabBarItemWithFrame:frame
                                                           title:itemDict[kEHITabBarItemAttributeTitle]
                                                 normalImageName:itemDict[kEHITabBarItemAttributeNormalImageName]
                                               selectedImageName:itemDict[kEHITabBarItemAttributeSelectedImageName]] ;
            if (itemTag == 0) {
                tabBarItem.selected = YES;
            }
            
            [tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            tabBarItem.tag = itemTag;
            itemTag++;
            
            [_tabBarItems addObject:tabBarItem];
            [self addSubview:tabBarItem];
        }
    }
}

- (void)itemSelected:(EHITabbarItem *)sender {
    
    if (self.delegate) {
        
        BOOL isChange = [self.delegate tabBar:self shouldSelectTabbarItem:sender];
        if (!isChange) {
            
            return;
        }
    }
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabBarController = (UITabBarController *)keyWindow.rootViewController;
    if (tabBarController) {
        tabBarController.selectedIndex = sender.tag;
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    for (EHITabbarItem *item in self.tabBarItems) {
        if (item.tag == index) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    
    for (EHITabbarItem *item in self.tabBarItems) {
     
         [item setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

- (EHITabbarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName {
    EHITabbarItem *item = [[EHITabbarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = FONT(11);
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    
    [item setTitleColor:kEHIHexColor_7B7B7B forState:UIControlStateNormal];
    [item setTitleColor:kEHIHexColor_FF7E00 forState:UIControlStateSelected];

    return item;
}
@end
