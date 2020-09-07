//
//  Utils.m
//  1hai-iPhone
//
//  Created by user on 18/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"
#import "LabelTool.h"

#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG
#import "NSString+Custom.h"
#pragma mark - App尺寸

#define DeviceFrame         [[UIScreen mainScreen] bounds]  // 整个屏幕尺寸
#define DeviceSize          DeviceFrame.size
#define Main_Screen_Height  DeviceSize.height
#define Main_Screen_Width   DeviceSize.width

/** 字体和加粗字体 */
#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define BoldFONT(SIZE) [UIFont boldSystemFontOfSize:SIZE]

/** 雅黑字体 */
#define FONT_MS_YAHEI(SIZE) [UIFont fontWithName:@"HelveticaNeue-Medium" size:SIZE / 1.9]


#endif

#define kEHICallChauffeurPhoneTag 1000
#define kEHINoConnectionAlertTag 15

static const CGFloat LABEL_HEIGHT=20.0f;
static const CGFloat ANIMATOR_DURATION=3.0f;
static const CGFloat DEFAULT_MESSAGE_LABEL_BOTTOM=20.0;
@interface Utils ()<UIAlertViewDelegate>
+(instancetype)shareUtil;
@property(strong,nonatomic)NSTimer *unFreezeTimer;
@property(nonatomic,strong)UIView *lockView;
@property(nonatomic,strong)UIImageView *activityImageView;
@property(nonatomic,strong)NSTimer *activityTimer;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UILabel *borderMessageLabel;
@property(strong,nonatomic)AppDelegate *delegate;
@end
@implementation Utils

+(void)Log:(NSString*)str{
#ifdef DEBUG
    NSLog(@"%@",str);
#endif
}
+(instancetype)shareUtil{
	static Utils *util;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		util=[super allocWithZone:NULL];
	});
	return util;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
	return [self shareUtil];
}
#pragma mark - show message
+(void)showMessage:(NSString *)message {
    if ([NSString isNilOrEmpty:message]) {
        return;
    }
	[self showMessage:message bottomHeight:(DEFAULT_MESSAGE_LABEL_BOTTOM + kEHIBottomDistance)];
}

/** 正在显示 */
+ (BOOL)isShow {
    Utils *util = [self shareUtil];
    if (util.messageLabel.superview) {
        return YES;
    }
    return NO;
}
+(void)showMessage:(NSString *)message bottomHeight:(CGFloat)bottomHeight{
    [self showMessage:message bottomHeight:bottomHeight superView:nil];
}

+(void)showMessage:(NSString *)message bottomHeight:(CGFloat)bottomHeight superView:(UIView *)superView {
	Utils *util=[self shareUtil];
	bottomHeight=MAX(bottomHeight, DEFAULT_MESSAGE_LABEL_BOTTOM);
//	[util.messageLabel.layer removeAllAnimations];
	
//	if (util.messageLabel.layer.superlayer) {
//		[util.messageLabel.layer removeFromSuperlayer];
//	}
//	[util.delegate.window.layer addSublayer:util.messageLabel.layer];
    if(util.messageLabel.superview){
        [util.messageLabel removeFromSuperview];
    }
    if (!superView) {
        superView = util.delegate.window;
    }
    [superView addSubview:util.messageLabel];
	if (message.length) {
		CGSize size=[message sizeWithFont:util.messageLabel.font constrainedToSize:CGSizeMake(DeviceSize.width-40, 100) lineBreakMode:NSLineBreakByCharWrapping];
		CGFloat width=size.width+10*2;
		CGFloat height=MAX(size.height, LABEL_HEIGHT)+5;
		CGFloat originY=DeviceSize.height-height-bottomHeight;
		util.messageLabel.frame=CGRectMake((DeviceSize.width-width)/2, originY, width, height);
		CABasicAnimation *fadeAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
		fadeAnimation.fromValue=[NSNumber numberWithFloat:0.8];
		fadeAnimation.toValue=[NSNumber numberWithFloat:0.8];
		fadeAnimation.duration=3.0;
		[util.messageLabel.layer addAnimation:fadeAnimation forKey:@"opacity"];
		util.messageLabel.layer.opacity=0.0;
	}else{
		util.messageLabel.frame=CGRectZero;
	}
	util.messageLabel.text=message;
	[util.messageLabel setNeedsDisplay];
}

+ (void)hide {
    Utils *util=[self shareUtil];
    [util.messageLabel.layer removeAllAnimations];
    if(util.messageLabel.superview){
        [util.messageLabel removeFromSuperview];
    }
}

+(void)showMessage:(NSString *)message originY:(float)y durartion:(CGFloat)duration{
    Utils *util=[self shareUtil];
    [util.messageLabel.layer removeAllAnimations];
//    if (util.messageLabel.layer.superlayer) {
//        [util.messageLabel.layer removeFromSuperlayer];
//    }
//    [util.delegate.window.layer addSublayer:util.messageLabel.layer];
    if(util.messageLabel.superview){
        [util.messageLabel removeFromSuperview];
    }
    [util.delegate.window addSubview:util.messageLabel];
    util.messageLabel.backgroundColor=[UIColor lightGrayColor];
    if (message.length) {
        //        CGSize size=[message sizeWithFont:UIFONT_22PX constrainedToSize:CGSizeMake(280, 100) lineBreakMode:NSLineBreakByCharWrapping];
        //        CGFloat width=size.width+DEFAULT_HORIZONTAL_PADDING*2;
        //        CGFloat height=MAX(size.height, LABEL_HEIGHT);
        util.messageLabel.frame=CGRectMake((DeviceSize.width-40)/2, y, 40, 40);
        util.messageLabel.font=FONT_16;
        CABasicAnimation *fadeAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue=[NSNumber numberWithFloat:0.8];
        fadeAnimation.toValue=[NSNumber numberWithFloat:0.0];
        fadeAnimation.duration=1.0;
        [util.messageLabel.layer addAnimation:fadeAnimation forKey:@"opacity"];
        util.messageLabel.layer.opacity=0.0;
        util.messageLabel.layer.cornerRadius=4.0;
        util.messageLabel.layer.masksToBounds=YES;
    }else{
        util.messageLabel.frame=CGRectZero;
    }
    util.messageLabel.text=message;
    [util.messageLabel setNeedsDisplay];
}

+(void)showLayerBorderMessage:(NSString *)message bottomHeight:(CGFloat)bottomHeight durartion:(CGFloat)duration
{
    Utils *util=[self shareUtil];
    bottomHeight=MAX(bottomHeight, DEFAULT_MESSAGE_LABEL_BOTTOM);
    [util.borderMessageLabel.layer removeAllAnimations];
    
//    if (util.borderMessageLabel.layer.superlayer) {
//        [util.borderMessageLabel.layer removeFromSuperlayer];
//    }
//    [util.delegate.window.layer addSublayer:util.borderMessageLabel.layer];
    if(util.borderMessageLabel.superview){
        [util.borderMessageLabel removeFromSuperview];
    }
    [util.delegate.window addSubview:util.borderMessageLabel];
    if (message.length) {
        CGSize size=[LabelTool sizeWithString:message font:util.borderMessageLabel.font andMaxSize:CGSizeMake(DeviceSize.width-20, 100)];
        CGFloat width=size.width+15*2;
        CGFloat height=size.height+15*2;
        CGFloat originY=DeviceSize.height-height-bottomHeight;
        util.borderMessageLabel.frame=CGRectMake((DeviceSize.width-width)/2, originY, width, height);
        CABasicAnimation *fadeAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue=[NSNumber numberWithFloat:0.8];
        fadeAnimation.toValue=[NSNumber numberWithFloat:0.8];
        fadeAnimation.duration=duration;
        [util.borderMessageLabel.layer addAnimation:fadeAnimation forKey:@"opacity"];
        util.borderMessageLabel.layer.opacity=0.0;
    }else{
        util.borderMessageLabel.frame=CGRectZero;
    }
    util.borderMessageLabel.text=message;
    [util.borderMessageLabel setNeedsDisplay];
}


-(UILabel *)messageLabel{
	if (!_messageLabel) {
		UILabel *label=[[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.8];
		label.textAlignment=NSTextAlignmentCenter;
		label.contentMode=UIViewContentModeCenter;
		label.textColor=[UIColor whiteColor];
		label.userInteractionEnabled=YES;
		label.numberOfLines=0;
        label.layer.cornerRadius=8.0;
        label.layer.masksToBounds=YES;
		label.font=FONT_MS_YAHEI(24.0);
		_messageLabel=label;
	}
	return _messageLabel;
}
-(UILabel *)borderMessageLabel{
    if (!_borderMessageLabel) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.8];
        label.backgroundColor=kEHIHexColor_000000;
//        label.alpha=0.8;
        label.layer.cornerRadius=8.0;
        label.layer.masksToBounds=YES;
        label.textAlignment=NSTextAlignmentCenter;
        label.contentMode=UIViewContentModeCenter;
        label.textColor=[UIColor whiteColor];
        label.userInteractionEnabled=YES;
        label.numberOfLines=0;
        label.font=FONT(14);
        
        _borderMessageLabel=label;
    }
    return _borderMessageLabel;
}
-(AppDelegate *)delegate{
	if (!_delegate) {
		_delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	return _delegate;
}

#pragma mark -
#pragma mark freezeScreen
+(void)freezeScreen{
	[Utils unFreezeScreen];
	Utils *util=[self shareUtil];
	[util startAnimate];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
	CGRect viewFrame=CGRectMake(0, 64.0, DeviceSize.width, DeviceSize.height-64.0);
	
	util.lockView.frame=viewFrame;
    [util.delegate.window addSubview:util.lockView];
	
}
+(void)unFreezeScreen{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	Utils *util=[self shareUtil];
	[util timerInvalidate];
	[util.lockView removeFromSuperview];
}
-(NSTimer *)unFreezeTimer{
	if (!_unFreezeTimer) {
		_unFreezeTimer=[NSTimer timerWithTimeInterval:30 target:[Utils class] selector:@selector(unFreezeScreen) userInfo:nil repeats:NO];//[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(unFreezeScreen) userInfo:nil repeats:NO];
	}
	return _unFreezeTimer;
}
-(UIView *)lockView{
	if (!_lockView) {
		CGRect viewFrame=CGRectMake(0, 64.0, DeviceSize.width, DeviceSize.height-64.0);
		//		viewFrame.size.height=viewFrame.size.height-HeadHeight;
		_lockView=[[UIView alloc] initWithFrame:viewFrame];
		_lockView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.2];
//        _lockView.backgroundColor=[UIColor clearColor];
		CGFloat activityWidth=39.0;
		CGFloat activityHeight=39.0;
		CGFloat logoWidth=24;
		CGFloat logoHeight=24;
		
		CGRect activityRect=CGRectMake((viewFrame.size.width-activityWidth)/2, (viewFrame.size.height-activityHeight-70)/2, activityWidth, activityHeight);
		CGRect logoRect=CGRectMake((viewFrame.size.width-logoWidth)/2, (viewFrame.size.height-logoHeight-70)/2, logoWidth, logoHeight);
		UIImageView *activityImageView=[[UIImageView alloc] initWithFrame:activityRect];
		activityImageView.image=[UIImage imageNamed:@"loading_circle"];
		activityImageView.tag=2;
		
		UIImageView *logoImageView=[[UIImageView alloc] initWithFrame:logoRect];
		logoImageView.image=[UIImage imageNamed:@"loading_logo"];
		[_lockView addSubview:activityImageView];
		[_lockView addSubview:logoImageView];
    }
	return _lockView;
}

-(void)timerInvalidate{
	if (self.unFreezeTimer) {
		[self.unFreezeTimer invalidate];
	}
    if (self.activityTimer) {
		[self.activityTimer invalidate];
	}
}
-(UIImageView *)activityImageView{
	
	return _activityImageView;
}
-(void)startAnimate{
	self.activityTimer=[NSTimer scheduledTimerWithTimeInterval:ANIMATOR_DURATION/16 target:self selector:@selector(acitivityImageViewAnimate:) userInfo:nil repeats:YES];
	self.unFreezeTimer=[NSTimer scheduledTimerWithTimeInterval:30 target:[Utils class] selector:@selector(unFreezeScreen) userInfo:nil repeats:NO];
}

-(NSTimer *)activityTimer{
	if (!_activityTimer) {
		_activityTimer=[NSTimer timerWithTimeInterval:ANIMATOR_DURATION/16 target:self selector:@selector(acitivityImageViewAnimate:) userInfo:nil repeats:YES
						];
	}
	return _activityTimer;
}
-(void)acitivityImageViewAnimate:(NSTimer *)timer{
	UIImageView *activityImageView=(UIImageView *)[self.lockView viewWithTag:2];
	[UIImageView beginAnimations:nil context:NULL];
	[UIImageView setAnimationDuration:ANIMATOR_DURATION/16];
	activityImageView.transform=CGAffineTransformRotate(activityImageView.transform, M_PI_4*ANIMATOR_DURATION/4);
	[UIImageView commitAnimations];
}

#pragma mark - Getter

- (UIAlertView *)noConnectAlertView {
    if (!_noConnectAlertView) {
        _noConnectAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"未连接到网络,请检查网络配置,您也可以拨打一嗨租车客服电话咨询" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"拨打电话", nil];
        _noConnectAlertView.tag = kEHINoConnectionAlertTag;
    }
    return _noConnectAlertView;
}

#pragma mark - 打电话

+ (void)callPhone:(NSString *)phone {
    [MobClick event:UMENGEVENT_CALL];
    if (!phone.length) {
        phone = @"4008886608";
    }
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10){
        [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"phone success");
        }];
    } else {
        UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [[UIApplication sharedApplication].delegate.window addSubview:phoneCallWebView];
    }
}

+ (void)callChauffeurPhone:(NSString *)phone {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"4008886608*2" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alertView.tag = kEHICallChauffeurPhoneTag;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case kEHICallChauffeurPhoneTag:
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4008886608"]];
            }
            break;
        case kEHINoConnectionAlertTag:
            if (buttonIndex == 1) {
                [Utils callPhone:@""];
            }
            break;
        default:
            break;
    }
}

@end
