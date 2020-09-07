//
//  Utils.h
//  1hai-iPhone
//
//  Created by user on 18/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG
#import <UIKit/UIKit.h>
#endif

@interface Utils : NSObject {

}

/** App 是否联网 */
@property (nonatomic, strong) UIAlertView *noConnectAlertView;

+(instancetype)shareUtil;

//@property(nonatomic,strong)UIView *lockView;
+(void)Log:(NSString*)str;
+(void)showMessage:(NSString *)message;
+(void)showMessage:(NSString *)message bottomHeight:(CGFloat)bottomHeight;
+(void)showMessage:(NSString *)message bottomHeight:(CGFloat)bottomHeight superView:(UIView *)superView;
+(void)freezeScreen;
+(void)unFreezeScreen;
+(void)showMessage:(NSString *)message originY:(float)y durartion:(CGFloat)duration;

+(void)showLayerBorderMessage:(NSString *)message bottomHeight:(CGFloat)bottomHeight durartion:(CGFloat)duration;

+ (void)hide;

/** 正在显示 */
+ (BOOL)isShow;

/** 打电话 */
+ (void)callPhone:(NSString *)phone;
+ (void)callChauffeurPhone:(NSString *)phone;

@end
