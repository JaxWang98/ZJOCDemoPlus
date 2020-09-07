//
//  EHIScanCodeView.m
//
//
//  Created by lbxia on 15/11/15.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "EHIScanCodeView.h"


#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG

#pragma mark - App尺寸

#define DeviceFrame         [[UIScreen mainScreen] bounds]  // 整个屏幕尺寸
#define DeviceSize          DeviceFrame.size
#define Main_Screen_Height  DeviceSize.height
#define Main_Screen_Width   DeviceSize.width

/** 在6的基础上自动缩放 */
#define autoHeightOf6(HEIGHT)   (kHaveTheSafetyArea ? (HEIGHT) : (HEIGHT) * (DeviceSize.height / 667))
#define autoWidthOf6(WIDTH)     WIDTH * (DeviceSize.width / 375)

/** 机型判断 */
#define iPhoneX ((Main_Screen_Width == 375) && (Main_Screen_Height == 812))
#define iPhoneXR ((Main_Screen_Width == 414) && (Main_Screen_Height == 896))
#define iPhoneXS_MAX ((Main_Screen_Width == 414) && (Main_Screen_Height == 896))
#define Is5 DeviceSize.width <= 320
#define Is6P DeviceSize.height == 736

/** 字体和加粗字体：适配 */
#define autoFONT(SIZE) Is6P ? FONT(SIZE * 1.1) : FONT(SIZE)
#define autoMediumFONT(SIZE) Is6P ? MediumFONT(SIZE * 1.1) : MediumFONT(SIZE)
#define autoBoldFONT(SIZE) Is6P ? BoldFONT(SIZE * 1.1) : BoldFONT(SIZE)

/** 字体和加粗字体 */
#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define MediumFONT(SIZE) [UIFont systemFontOfSize:SIZE weight:UIFontWeightMedium]
#define SemiBoldFONT(SIZE) [UIFont systemFontOfSize:SIZE weight:UIFontWeightSemibold]
#define BoldFONT(SIZE) [UIFont boldSystemFontOfSize:SIZE]

#endif


NS_ASSUME_NONNULL_BEGIN

/** 矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，< 0 表示扫码区域下移, >0 表示扫码区域上移 */
static NSInteger const centerUpOffset() {
    return autoWidthOf6(63);
}
/** 矩形框(视频显示透明区)域离界面左边及右边距离 */
static NSInteger const xScanRetangleOffset() {
    return autoWidthOf6(58);
}
/** 扫码区域4个角的宽度和高度 */
static NSInteger const photoframeAngleW() {
    return autoWidthOf6(40);
}
static NSInteger const photoframeAngleH() {
    return autoWidthOf6(40);
}
/** 画扫码矩形以及周边半透明黑色坐标参数 */
static NSInteger const diffSpace() {
    return autoWidthOf6(17);
}
/** 扫码区域4个角的线条宽度 */
static CGFloat const photoframeLineW() {
    return 2 / [UIScreen mainScreen].scale;
}
/** 4个角的颜色 */
static UIColor * const colorAngle() {
    return [UIColor whiteColor];
}
/** 4个角的圆角 */
static NSInteger const radiusAngle() {
    return autoWidthOf6(15);
}
/** 网格图片 */
static UIImage * const animationImage() {
    return [UIImage imageNamed:@"hicar_scan_net"];
}
/** 非识别区域颜色 */
static UIColor * const notRecoginitonArea() {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.49];
}

@interface EHIScanCodeView()

/** 网格扫码动画封装 */
@property (nonatomic, strong, nullable) EHIScanCodeNetAnimation *scanNetAnimation;

/** 启动相机时,转圈等待 */
@property (nonatomic, strong, nullable) UIActivityIndicatorView *activityView;

/** 启动相机中的提示文字 */
@property (nonatomic, strong, nullable) UILabel *labelReadying;

/** 扫码区域 */
@property (nonatomic, assign) CGRect scanRect;

@end

NS_ASSUME_NONNULL_END

@implementation EHIScanCodeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];       
        [self calculateRect];
    }
    return self;
}

#pragma mark - 计算尺寸

- (void)calculateRect {
    NSInteger XRetangleLeft = xScanRetangleOffset();
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft * 2, self.frame.size.width - XRetangleLeft * 2);
    
    // 扫码区域Y轴最小坐标
    NSInteger YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - centerUpOffset();
    NSInteger YMaxRetangle = YMinRetangle + sizeRetangle.height;
    NSInteger XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    NSLog(@"frame:%@", NSStringFromCGRect(self.frame));
   
    self.scanRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    // 画扫码矩形以及周边半透明黑色坐标参数
    NSInteger diffAngle = diffSpace();
    
    NSInteger leftX = XRetangleLeft - diffAngle;
    NSInteger topY = YMinRetangle - diffAngle;
    NSInteger rightX = XRetangleRight + diffAngle;
    NSInteger bottomY = YMaxRetangle + diffAngle;
    
    self.cornerRect = CGRectMake(leftX, topY, rightX, bottomY);
}

#pragma makr - 设备准备与停止

/** 开始设备准备 */
- (void)startDeviceReadyingWithText:(NSString *)text {
    NSInteger XRetangleLeft = CGRectGetMinX(self.scanRect);
    NSInteger YMinRetangle = CGRectGetMinY(self.scanRect);
    CGSize sizeRetangle = self.scanRect.size;
    // 设备启动状态提示
    if (!_activityView) {
        [self.activityView setCenter:CGPointMake(XRetangleLeft + sizeRetangle.width / 2 - 50, YMinRetangle + sizeRetangle.height / 2)];
        
        CGRect labelReadyRect = CGRectMake(self.activityView.frame.origin.x + self.activityView.frame.size.width + 10, self.activityView.frame.origin.y, 100, 30);
        self.labelReadying.frame = labelReadyRect;
        self.labelReadying.text = text;
        
        [self.activityView startAnimating];
    }
}

/** 停止设备准备 */
- (void)stopDeviceReadying {
    if (_activityView) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        [self.labelReadying removeFromSuperview];
        
        self.activityView = nil;
        self.labelReadying = nil;
    }
}

#pragma mark - 开始扫描动画

/** 开始扫描动画 */
- (void)startScanAnimation {
    // 网格动画
    if (!_scanNetAnimation) {
        self.scanNetAnimation = [[EHIScanCodeNetAnimation alloc] init];
    }
    CGRect rect = self.scanRect;
    rect.size.height += Is5 ? 4 : 5;
    rect.size.width = rect.size.height * animationImage().size.width / animationImage().size.height;
    rect.origin.x = (self.frame.size.width - rect.size.width) / 2 - 0.5;
    [_scanNetAnimation startAnimatingWithRect:rect
                                       inView:self
                                        image:animationImage()];
}

/** 结束扫描动画 */
- (void)stopScanAnimation {
    if (_scanNetAnimation) {
        [_scanNetAnimation stopAnimating];
    }
}

#pragma mark - 绘制

- (void)drawRect:(CGRect)rect {
    // 扫码区域坐标
    NSInteger XRetangleLeft = CGRectGetMinX(self.scanRect);
    NSInteger YMinRetangle = CGRectGetMinY(self.scanRect);
    CGSize sizeRetangle = self.scanRect.size;
    
    NSInteger YMaxRetangle = YMinRetangle + sizeRetangle.height;
    NSInteger XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 非扫码区域半透明
    {
        // 设置非识别区域颜色
        const CGFloat *components = CGColorGetComponents(notRecoginitonArea().CGColor);
        CGContextSetFillColor(context, components);
        
        // 扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);

        // 扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        // 扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        // 扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width, self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        
        // 执行绘画
        CGContextStrokePath(context);
    }
    
    // 画矩形框4个相框角
    // 相框角的宽度和高度
    NSInteger wAngle = photoframeAngleW();
    NSInteger hAngle = photoframeAngleH();
    // 4个角的 线的宽度
    CGFloat linewidthAngle = photoframeLineW();
    
    CGContextSetStrokeColorWithColor(context, colorAngle().CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextSetLineWidth(context, linewidthAngle);

    NSInteger leftX = CGRectGetMinX(self.cornerRect);
    NSInteger topY = CGRectGetMinY(self.cornerRect);
    NSInteger rightX = CGRectGetWidth(self.cornerRect);
    NSInteger bottomY = CGRectGetHeight(self.cornerRect);

    NSInteger radius = radiusAngle(); // 圆角
    
    // 左上角垂直线
    CGContextMoveToPoint(context, leftX, topY + hAngle); // 大
    CGContextAddLineToPoint(context, leftX, topY - linewidthAngle / 2 + radius); // 小
    // 左上角圆角
    CGContextAddArcToPoint(context, leftX, topY - linewidthAngle / 2, leftX - linewidthAngle / 2 + radius, topY, radius);
    // 左上角水平线
    CGContextAddLineToPoint(context, leftX + wAngle, topY); // 大
    
    
    // 左下角水平线
    CGContextMoveToPoint(context, leftX + wAngle, bottomY); // 大
    CGContextAddLineToPoint(context, leftX - linewidthAngle / 2 + radius, bottomY); // 小
    // 左下角圆角
    CGContextAddArcToPoint(context, leftX - linewidthAngle / 2, bottomY, leftX, bottomY + linewidthAngle/2 - radius, radius);
    // 左下角垂直线
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle); // 小

    
    // 右上角垂直线
    CGContextMoveToPoint(context, rightX, topY + hAngle); // 大
    CGContextAddLineToPoint(context, rightX, topY - linewidthAngle / 2 + radius); // 小
    // 右上角圆角
    CGContextAddArcToPoint(context, rightX, topY - linewidthAngle / 2, rightX + linewidthAngle / 2 - radius, topY, radius);
    // 右上角水平线
    CGContextAddLineToPoint(context, rightX - wAngle, topY); // 小
    
    
    // 右下角水平线
    CGContextMoveToPoint(context, rightX - wAngle, bottomY); // 小
    CGContextAddLineToPoint(context, rightX + linewidthAngle / 2 - radius, bottomY); // 大
    // 右下角圆角
    CGContextAddArcToPoint(context, rightX + linewidthAngle / 2, bottomY, rightX, bottomY + linewidthAngle / 2 - radius, radius);
    // 右下角垂直线
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle); // 小
    
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - 计算扫描区域

/** 识别区域计算 */
- (CGRect)qrCodeRecognizeScanRect {
    NSInteger XRetangleLeft = CGRectGetMinX(self.scanRect);
    CGSize sizeRetangle = self.scanRect.size;
    CGFloat YMinRetangle = CGRectGetMinY(self.scanRect);
    
    XRetangleLeft = XRetangleLeft / self.bounds.size.width * 1080;
    YMinRetangle = YMinRetangle / self.bounds.size.height * 1920;
    CGFloat width  = sizeRetangle.width / self.bounds.size.width * 1080;
    CGFloat height = sizeRetangle.height / self.bounds.size.height * 1920;
    
    CGRect cropRect = CGRectMake(XRetangleLeft, YMinRetangle, width, height);
    return cropRect;
}

#pragma mark - Getter

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self addSubview:_activityView];
    }
    return _activityView;
}

- (UILabel *)labelReadying {
    if (!_labelReadying) {
        _labelReadying = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor  = [UIColor whiteColor];
        _labelReadying.font = autoFONT(16);
        
        [self addSubview:_labelReadying];
    }
    return _labelReadying;
}

@end
