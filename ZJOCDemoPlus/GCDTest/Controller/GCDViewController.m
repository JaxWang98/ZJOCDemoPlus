//
//  GCDViewController.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//

/**
   飞哥提出的线程安全问题，在cell刷新的时候，数据源发生变化，造成了数组越界，如何解决这一问题？
*/

#import "GCDViewController.h"
#import "ZJGCDListModel.h"
#import <Masonry/Masonry.h>
@interface GCDViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<ZJGCDListModel *> *dataSource;
@property (nonatomic, assign) BOOL isFirstComing;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation GCDViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"GCD";
    self.view.backgroundColor = UIColor.whiteColor;
    self.isFirstComing = YES;
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

    [self updateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateData {
    self.dataSource = [self getDealData];
    [self.tableView reloadData];
}

- (NSMutableArray *)getDealData {
    NSMutableArray<ZJGCDListModel *> *dataArray = [NSMutableArray array];
    NSUInteger count = [self _getRandomNumber];
    for (int i = 0; i < count; i++) {
        ZJGCDListModel *item = [[ZJGCDListModel alloc]init];
        item.title = [NSString stringWithFormat:@"随机cell - %d", i ];
        [dataArray addObject:item];
    }
    return dataArray;
}

- (NSUInteger)_getRandomNumber {
//    NSArray *countArray = [NSArray arrayWithObjects:@1, @50, @2, @100, nil];
    NSUInteger index = (arc4random() % 100); //获取[0,4)随机数，包括0，不包括4
//    NSUInteger rst = [countArray[index] intValue];
//    return rst;
    return  index;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isFirstComing = NO;
}

#pragma mark -- UItableViewDelegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];

    if (!self.dataSource) {
        cell.textLabel.text = [NSString stringWithFormat:@"defaultCell - %ld", (long)indexPath.row];
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row].title;
    }
                                                               
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
        [self updateData];
//        dispatch_semaphore_signal(self->_semaphore);
    });

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

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tabView = [[UITableView alloc]init];
        tabView.delegate = self;
        tabView.dataSource = self;
//        tabView.userInteractionEnabled = NO;

        [tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
        _tableView = tabView;
    }
    return _tableView;
}

@end
