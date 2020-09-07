//
//  EHIScanCodeViewController.m
//  QRCodeDemo
//
//  Created by LuckyCat on 2017/11/16.
//  Copyright © 2017年 zhangyaqiong. All rights reserved.
//

#import "EHIScanCodeViewController.h"
#import <Photos/Photos.h>
#import "ZXingWrapper.h"
#import "EHIScanCodeView.h"
#import "EHIAuthorityManager.h"

#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG



/** weak strong*/
#define EHiWeakSelf(type)           __weak typeof(type) weak##type = type;
#define EHiStrongSelf(_instance)    __strong typeof(weak##_instance) _instance = weak##_instance;

#define Is6P DeviceSize.height == 736
/** 系统判断 */
#define SystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]

#define DeviceFrame         [[UIScreen mainScreen] bounds]  // 整个屏幕尺寸
#define DeviceSize          DeviceFrame.size
#define Main_Screen_Height  DeviceSize.height
#define Main_Screen_Width   DeviceSize.width

/** 在6的基础上自动缩放 */
#define autoHeightOf6(HEIGHT)   (kHaveTheSafetyArea ? (HEIGHT) : (HEIGHT) * (DeviceSize.height / 667))
#define autoWidthOf6(WIDTH)     WIDTH * (DeviceSize.width / 375)

/** 字体和加粗字体：适配 */
#define autoFONT(SIZE) Is6P ? FONT(SIZE * 1.1) : FONT(SIZE)
#define autoMediumFONT(SIZE) Is6P ? MediumFONT(SIZE * 1.1) : MediumFONT(SIZE)
#define autoBoldFONT(SIZE) Is6P ? BoldFONT(SIZE * 1.1) : BoldFONT(SIZE)



#endif

/** 扫码超时时间 */
static NSInteger const kEHIHiCarScanTime = 30;

@interface EHIScanCodeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

/** ZXing扫码对象 */
@property (nonatomic, strong) ZXingWrapper *zxingObj;

/** 手电筒开启状态 */
@property(nonatomic, assign) BOOL isOpenFlash;

/** 扫码区域视图,二维码一般都是框 */
@property (nonatomic, strong) EHIScanCodeView *qRScanView;

/** 顶部提示文字 */
@property (nonatomic, strong) UILabel *tipLabel;

/** 底部提醒文字 */
@property (nonatomic, strong) UIButton *remindButton;

/** 手电筒按钮 */
@property (nonatomic, strong) UIButton *torchButton;

/** 倒计时的计时器 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation EHIScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initNavBarView];
    
    [self drawScanView];
    [self checkCameraPemission];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [self releaseTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc {
    [self stopScan];
    
    [self.qRScanView stopScanAnimation];

    [self releaseTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - 扫码结果处理

/** 扫码结果获取 */
- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array {
    
}

#pragma mark - 设置扫描

/** 绘制扫描区域 */
- (void)drawScanView {
    [self.qRScanView startDeviceReadyingWithText:@"相机启动中"];
}

/** 启动扫描 */
- (void)startScan {
    if (!_zxingObj) {
        UIView *videoView = [[UIView alloc] initWithFrame:self.qRScanView.frame];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];
        EHiWeakSelf(self)
        self.zxingObj = [[ZXingWrapper alloc] initWithPreView:videoView block:^(ZXBarcodeFormat barcodeFormat, NSString *str, UIImage *scanImg) {
            EHiStrongSelf(self)
            LBXScanResult *result = [[LBXScanResult alloc] init];
            result.strScanned = str;
            result.imgScanned = scanImg;
            result.strBarCodeType = [self convertZXBarcodeFormat:barcodeFormat];
            [self scanResultWithArray:@[result]];
        }];
        // 设置只识别框内区域
        CGRect scanRect = [self.qRScanView qrCodeRecognizeScanRect];
        [_zxingObj setScanRect:scanRect];
    }
    [_zxingObj start];
    [self startCountdown];
    
    [self.qRScanView stopDeviceReadying];
    [self.qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

/** 停止扫描 */
- (void)stopScan {
    [_zxingObj stop];
}

/** 重启扫描 */
- (void)reStartDevice {
    [_zxingObj start];
    [self startCountdown];
    if (self.isOpenFlash) {
        [_zxingObj openTorch:YES];
        [self changeTorchButtonState:YES];
    }
}

/** 扫码超时操作 */
- (void)scanTimeout {
    
}

#pragma mark - 倒计时

/** 开始使用定时器进行倒计时 */
- (void)startCountdown {
    [self releaseTimer];

    __block NSInteger timeout = kEHIHiCarScanTime; // 倒计时时间
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        timeout --;
//        NSLog(@"🍎📚📚📚🍎----：%ld", (long)timeout);
        if (timeout <= 0) { // 倒计时结束,关闭
            [self releaseTimer];
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scanTimeout];
            });
        }
    });
    dispatch_resume(_timer);
}

/** 销毁定时器 */
- (void)releaseTimer {
    if (_timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - Action

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 开关闪光灯 */
- (void)torchButtonAction {
    self.isOpenFlash = !self.isOpenFlash;
   
    [_zxingObj openTorch:self.isOpenFlash];
    [self changeTorchButtonState:self.isOpenFlash];
}

/** 改变闪光灯按钮状态 */
- (void)changeTorchButtonState:(BOOL)isOpenFlash {
    if (isOpenFlash) {
        [self.torchButton setImage:[UIImage imageNamed:@"haicar_torch_open"] forState:UIControlStateNormal];
    } else {
        [self.torchButton setImage:[UIImage imageNamed:@"haicar_torch_close"] forState:UIControlStateNormal];
    }
}

#pragma mark - Method

/** 显示toast提示 */
- (void)showMessage:(NSString *)message {
    // 重新扫描
    [self reStartDevice];
    
    if ([NSString isNilOrEmpty:message]) {
        return;
    }
    CGFloat toastBottomHeight = self.tipLabel.bottom + CGRectGetHeight(self.qRScanView.cornerRect) / 2;
    [Utils showMessage:message bottomHeight:toastBottomHeight];
}

/** 扫码处理 */
- (NSString *)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat {
    NSString *strAVMetadataObjectType = nil;
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            break;
        case kBarcodeFormatRSSExpanded:
            break;
        case kBarcodeFormatUPCA:
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    return strAVMetadataObjectType;
}

/** 检测相机权限 */
- (void)checkCameraPemission {
    EHiWeakSelf(self)
    [EHIAuthorityManager authorityType:EHIAuthorityTypeCamera enable:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            EHiStrongSelf(self)
            self.torchButton.hidden = NO;
            // 延时，相机准备时长，iOS9.3特别慢。。。
            NSUInteger delayTime = (SystemVersion >= 9.3 && SystemVersion < 9.4) ? 3 : 0.3;
            [self performSelector:@selector(startScan) withObject:nil afterDelay:delayTime];
        });
    } unenable:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            EHiStrongSelf(self)
            self.torchButton.hidden = YES;
            [self.qRScanView stopDeviceReadying];
        });
    }];
}

#pragma mark - Set UI

/** 设置navBarView */
- (void)initNavBarView {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBackArrow"]];
    backImageView.frame = CGRectMake(autoWidthOf6(16), [UIApplication sharedApplication].statusBarFrame.size.height + (44 - 25) / 2, 25, 25);
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, 50, 44);
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, backButton.top, Main_Screen_Width - 80 * 2, backButton.height)];
    titleLabel.font = autoFONT(17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"扫码取车";
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:backImageView];
    [self.view addSubview:backButton];
}

#pragma mark - Getter

- (EHIScanCodeView *)qRScanView {
    if (!_qRScanView) {
        EHIScanCodeView *scanView = [[EHIScanCodeView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:scanView atIndex:0];
        
        self.tipLabel.bottom = CGRectGetMinY(scanView.cornerRect) - 2;
        self.remindButton.top = CGRectGetHeight(scanView.cornerRect) + autoHeightOf6(22);
        self.torchButton.top = self.remindButton.bottom + autoHeightOf6(37);
        
        _qRScanView = scanView;
    }
    return _qRScanView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, autoHeightOf6(15))];
        label.backgroundColor = [UIColor clearColor];
        label.textColor  = [UIColor whiteColor];
        label.font = autoFONT(13);
        label.text = @"对准车上的二维码";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}

- (UIButton *)remindButton {
    if (!_remindButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.view.width, autoHeightOf6(22));
        button.titleLabel.font = autoFONT(14);
        [button setImage:[UIImage imageNamed:@"haicar_pop_remind"] forState:UIControlStateNormal];
        [button setTitle:@"  打开蓝牙可以取车更快" forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
        
        [self.view addSubview:button];
        _remindButton = button;
    }
    return _remindButton;
}

- (UIButton *)torchButton {
    if (!_torchButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, autoWidthOf6(48), autoWidthOf6(48));
        button.centerX = Main_Screen_Width / 2;
        [button setImage:[UIImage imageNamed:@"haicar_torch_close"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(torchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        _torchButton = button;
    }
    return _torchButton;
}

@end
