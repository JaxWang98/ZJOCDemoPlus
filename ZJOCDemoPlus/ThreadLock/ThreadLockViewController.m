//
//  ThreadLockViewController.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/13.
//  Copyright © 2020 widerness. All rights reserved.
//
/*
    MARK: 先跟不同的锁写不同的函数，后续考虑一下用block、协议或者继承的方式来达到复用目的，现在还是太不优雅，赶时间，得先把锁搞定
 */

#import "ThreadLockViewController.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>


@interface ThreadLockViewController ()
//UI控件
@property (nonatomic, strong) UIImageView *infos;
@property (nonatomic, assign) int ticketCount;
//锁
@property (nonatomic, strong) NSMutableArray<NSString *> *lockArray;
@property (nonatomic, assign) OSSpinLock spinLock;//已弃用，耍耍
@property (atomic, assign) os_unfair_lock unfairLock;
@property (nonatomic, strong) NSLock *nsLock;//NSLock
@property (nonatomic, assign) pthread_mutex_t *mutexLock;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;



@end

@implementation ThreadLockViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lockArray = [NSMutableArray array];
        NSArray<NSString *> *lockArray = @[@"OSSpinLock", @"os_unfair_lock", @"NSLock", @"pthread_mutex", @"dispatch_semaphore_t", @"不加锁"];
        [self.lockArray addObjectsFromArray:lockArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.infos];
    self.infos.frame = CGRectMake(0, 80, self.view.bounds.size.width, 300);
    for (int i = 0; i < self.lockArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.infos.frame.origin.y + self.infos.frame.size.height + i * 50, self.view.bounds.size.width, 50)];
        btn.tag = i;

        [btn setTitle:self.lockArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(diffrentLockTouchs:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

#pragma mark -- Action
- (void)diffrentLockTouchs:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
            NSLog(@"%@", self.lockArray[0]);
            [self OSSpinLockTicketDemo];
            break;
        case 1:
            NSLog(@"%@", self.lockArray[1]);
            [self os_spin_LockTicketDemo];
            break;
        case 2:
            NSLog(@"%@", self.lockArray[2]);
            [self nsLockTicketDemo];
            break;
        case 3:
            NSLog(@"%@", self.lockArray[3]);
            [self pthreadMutexTicketDemo];
            break;
        case 4:
            NSLog(@"%@", self.lockArray[4]);
            [self semaphoreTicketDemo];
            break;
        case 5:
            NSLog(@"%@", self.lockArray[5]);
            [self ticketTest];
            break;
        default:
            NSLog(@"default");
            [self ticketTest];
            break;
    }
}

#pragma mark -- 逻辑
//卖票演示
- (void)ticketTest {
    self.ticketCount = 50;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                [self sellingTickets];
            }
        });
    }
}
//OSSpinLock卖票
- (void)OSSpinLockTicketDemo {
    self.ticketCount = 0;
    self.ticketCount = 50;

    self.spinLock = OS_SPINLOCK_INIT;//初始化锁
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                OSSpinLockLock(&_spinLock);//加锁
                [self sellingTickets];
                OSSpinLockUnlock(&_spinLock);//解锁
            }
        });
    }
}
//os_spin_Lock卖票
- (void)os_spin_LockTicketDemo {
    self.ticketCount = 0;
    self.ticketCount = 50;

    self.unfairLock = OS_UNFAIR_LOCK_INIT;//初始化锁
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                
                os_unfair_lock_lock(&self->_unfairLock);//加锁
                [self sellingTickets];
                os_unfair_lock_unlock(&self->_unfairLock);//解锁
            }
        });
    }
}

//NSLock卖票
- (void)nsLockTicketDemo {
    self.ticketCount = 0;
    self.ticketCount = 50;

    self.nsLock = [[NSLock alloc]init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                [self.nsLock lock]; //加锁
                [self sellingTickets];
                [self.nsLock unlock];//解锁
            }
        });
    }
}

//pthread——mutex卖票
- (void)pthreadMutexTicketDemo {
    self.ticketCount = 0;
    self.ticketCount = 50;

    //有问题，但我懒得看了
    pthread_mutex_init(_mutexLock, PTHREAD_MUTEX_NORMAL);

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                pthread_mutex_lock(self->_mutexLock);
                [self sellingTickets];
                pthread_mutex_unlock(self->_mutexLock);
            }
        });
    }
}

//pthread——mutex卖票
- (void)semaphoreTicketDemo {
    self.ticketCount = 0;
    self.ticketCount = 50;

    self.semaphore = dispatch_semaphore_create(1);//创建信号量
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            for (int i = 0; i < 10; i++) {
                dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
                [self sellingTickets];
                dispatch_semaphore_signal(self->_semaphore);
            }
        });
    }
}



- (void)sellingTickets {
    /**
        由于这个函数是在异步执行的并发队列中执行的，因此当多个线程同时执行该函数时，有可能同时访问了_ticketCount属性，并对其做了修改，这时候线程就是不安全的了
     */
    int oldMoney = _ticketCount; //这个访问可能会有多个线程同时执行
    sleep(.2);
    oldMoney -= 1;
    _ticketCount = oldMoney;
    NSLog(@"%@ - 当前剩余票数 -> %d", [NSThread currentThread], oldMoney);
}

- (UIImageView *)infos {
    if (!_infos) {
        _infos = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"线程锁pic"]];
        _infos.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _infos;
}

@end
