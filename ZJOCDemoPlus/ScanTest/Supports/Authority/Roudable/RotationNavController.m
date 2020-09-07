//
//  RotationNavController.m
//  1hai-iPhone
//
//  Created by 1hai 1hai on 13-7-18.
//
//

#import "RotationNavController.h"
//#import "ChauffeurOrderReserveViewController.h"
//#import "GrabOrderViewController.h"
#warning 一嗨租车debug测试代码 王之杰
#ifdef DEBUG
#import <YYKit/YYKit.h>
/** 色值 */   
static inline UIColor * kEHIHexColor(uint32_t rgbValue) {
    return [UIColor colorWithRGB:rgbValue];
}
/** 字体和加粗字体 */
#define FONT(SIZE) [UIFont systemFontOfSize:SIZE]
#define BoldFONT(SIZE) [UIFont boldSystemFontOfSize:SIZE]


/** 文字、底色、线 */
#define kEHIHexColor_333333 kEHIHexColor(0x333333) // 黑色：重要文字用色、按钮（可按、按下、不可按依次按不透明度100%、60%、30%递减）（step2左侧tab底色2%透明度）

#endif


@interface RotationNavController ()

@end

@implementation RotationNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kEHIHexColor_333333,NSFontAttributeName:FONT(18)}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate=self;
        self.delegate=self;
    }
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    //    WSJLog(@"%@",self.viewControllers);
    if (self.viewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if([self.topViewController isEqual:viewController]){
        
        return;
    }
    [super pushViewController:viewController animated:animated];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (navigationController.viewControllers.count>=2) {
            self.interactivePopGestureRecognizer.enabled = YES;
            
            //     cjq     2016/08/10    修改：预约成功、马上用车抢单，不可滑动返回
            self.interactivePopGestureRecognizer.enabled = [self judgeIfAllowLeftSlideReturnWithVC_Name:NSStringFromClass([viewController class])];
            //     end
            
        }else
            self.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
	return self.topViewController.supportedInterfaceOrientations;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//    cjq    2016/08/31    新增：判断是否要允许左滑返回
- (BOOL) judgeIfAllowLeftSlideReturnWithVC_Name:(NSString *)className {
    
    BOOL isAllowReturn = YES;
    
    //    不允许滑动返回的类型数组
    NSArray *VC_NameArray = @[@"ChauffeurOrderReserveViewController",
                              @"GrabOrderViewController",
                              @"Forecast_PriceDetailViewController",
                              //                              @"EHIOrderCenterViewController",
                              @"SelfDrivingOrderSuccessViewController",
                              @"TaxiViewController",
                              //                              @"Taxi_InServiceViewController",
                              @"EnterpriseSuccessViewController",
                              @"ChauffeurPaymentFinishViewController",
                              @"New_Add_Invoice",
                              @"EHISelfDrivingInvoiceHistoryViewController",
                              @"BalanceOutSuccessController",
                              @"SelfDrivingPaymentFinishedViewController",
                              @"OnlineChargeViewController",
                              @"CusServiceController",
                              @"EHICarTypeGroupUpdateViewController"];
    
    for (NSString *temp in VC_NameArray) {
        if ([className isEqualToString:temp]) {
            isAllowReturn = NO;
            break;
        }
    }
    
    return isAllowReturn;
}
//    end

@end
