//
//  ViewController.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//

#import "ZJDemoRootViewController.h"
#import "ZJDemoRootViewModel.h"
#import "ZJDemoRootListItemModel.h"
#import <Masonry/Masonry.h>

@interface ZJDemoRootViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) ZJDemoRootViewModel *viewModel;
@property (nonatomic, strong) NSArray<ZJDemoRootListItemModel *> *dataSource;

@end

@implementation ZJDemoRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self getUIData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- UI
- (void)setUpUI {
//    self.edgesForExtendedLayout = UIRectEdgeNone;//view从navigationBar下面开始显示
    self.title = @"ZJDEMO";
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self layOutUI];
}

- (void)layOutUI {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark -- request

- (void)getUIData {
    __weak typeof(self) weakSelf = self;
    [self.viewModel refreshUIWithData:^(NSArray<ZJDemoRootListItemModel *> *_Nonnull dataSource) {
        __strong typeof(weakSelf) self = weakSelf;
        self.dataSource = dataSource;
        [self.tableView reloadData];
    }];
}

#pragma mark -- UItableViewDelegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    
    if (!self.dataSource) {
        cell.textLabel.text = [NSString stringWithFormat:@"cell - %ld", indexPath.row];
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row].title;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource) {
        return self.dataSource.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSource[indexPath.row].vc) {
        Class vcClass = NSClassFromString(self.dataSource[indexPath.row].vc);
        id vc = [[vcClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSLog(@"暂无vc");
    }
    
}

#pragma mark -- lazyLoad
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tabView = [[UITableView alloc]init];
        tabView.delegate = self;
        tabView.dataSource = self;
        [tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
        _tableView = tabView;
    }
    return _tableView;
}

- (ZJDemoRootViewModel *)viewModel {
    if (!_viewModel) {
        ZJDemoRootViewModel *viewModel = [[ZJDemoRootViewModel alloc]init];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = UIColor.clearColor;

        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"三万六千日\n夜夜当秉烛";
        lab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 0;


        UIImage *image = [UIImage imageNamed:@"rootImage"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.cornerRadius = 20;
        imgView.layer.masksToBounds = YES;

        [view addSubview:imgView];
//        [view addSubview:lab];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(150);
        }];
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.mas_equalTo(0);
//            make.top.equalTo(imgView);
//            make.left.equalTo(imgView.mas_right);
//        }];
        _headerView = view;
    }
    return _headerView;
}

@end
