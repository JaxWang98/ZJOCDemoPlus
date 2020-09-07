//
//  EHITabbarItem.m
//  1haiiPhone
//
//  Created by dengwx on 2017/11/6.
//  Copyright © 2017年 EHi. All rights reserved.
//

#import "EHITabbarItem.h"

@implementation EHITabbarItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)config {
    self.adjustsImageWhenHighlighted = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    if (imageSize.width != 0 && imageSize.height != 0) {
        CGFloat imageViewCenterY = CGRectGetHeight(self.frame) - 3 - titleSize.height - imageSize.height / 2 - 1;
        self.imageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, imageViewCenterY);
    } else {
        CGPoint imageViewCenter = self.imageView.center;
        imageViewCenter.x = CGRectGetWidth(self.frame) / 2;
        imageViewCenter.y = (CGRectGetHeight(self.frame) - titleSize.height) / 2;
        self.imageView.center = imageViewCenter;
    }
    
    CGPoint labelCenter = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 3 - titleSize.height / 2);
    self.titleLabel.center = labelCenter;
    
}
@end
