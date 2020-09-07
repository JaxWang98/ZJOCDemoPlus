//
//  EHIScanCodeNetAnimation.m
//
//
//  Created by lbxia on 15/11/3.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "EHIScanCodeNetAnimation.h"

@interface EHIScanCodeNetAnimation() {
    BOOL isAnimationing;
}
/** 动画区域 */
@property (nonatomic, assign) CGRect animationRect;

/** 扫描图片 */
@property (nonatomic, strong) UIImageView *scanImageView;

@end

@implementation EHIScanCodeNetAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.scanImageView];
    }
    return self;
}

- (void)dealloc {
    [self stopAnimating];
}

/** 循环动画 */
- (void)stepAnimation {
    if (!isAnimationing) {
        return;
    }
    self.frame = self.animationRect;
    
    CGFloat scanNetImageViewW = self.frame.size.width;
    CGFloat scanNetImageH = self.frame.size.height;
    
    self.alpha = 0.5;
    self.scanImageView.frame = CGRectMake(0, -scanNetImageH, scanNetImageViewW, scanNetImageH);
    CGFloat duration = 1.5;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1.0;
        self.scanImageView.frame = CGRectMake(0, 0, scanNetImageViewW, scanNetImageH);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.38 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
        }];
    }];
}

/** 开始动画 */
- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage *)image {
    [self.scanImageView setImage:image];
    
    self.animationRect = animationRect;
    
    [parentView addSubview:self];
    
    self.hidden = NO;
    
    isAnimationing = YES;
    
    [self stepAnimation];
}

/** 停止动画 */
- (void)stopAnimating {
    self.hidden = YES;
    isAnimationing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Getter

- (UIImageView *)scanImageView {
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] init];
    }
    return _scanImageView;
}

@end
