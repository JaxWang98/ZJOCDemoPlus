//
//  GCDBeanTestViewController.m
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/10.
//  Copyright © 2020 widerness. All rights reserved.
/**
    GCD，执行的顺序问题，看看各个test执行的顺序问题，GCD队列的串行、并发队列，以及对应的同步和异步执行方式。
 */

#import "GCDBeanTestViewController.h"

@interface GCDBeanTestViewController ()

@end

@implementation GCDBeanTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    self.view.backgroundColor = UIColor.whiteColor;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(130, 100, 100, 30)];
    lab.text = @"摸我，看输出的log";
    [lab sizeToFit];
    [self.view addSubview:lab];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //    [self test1];
    //    [self test2];
    //    [self test3];
//    [self test4];
    [self test5];
}

- (void)test1 {
    NSLog(@"---------------");
    NSLog(@"1");
    dispatch_queue_t queueS = dispatch_queue_create("test1", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueS, ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    /**
        输出顺序为
        ——————
        1
        3
        2
        解释：主队列为串行队列，而我们新建了一个串行队列test1，并且选择disapcth_async异步执行，异步会立即返回并继续向后执行代码，而block中的内容会等待主队列完成后再执行，因此执行顺序为1，3，2
     */
}

- (void)test2 {
    NSLog(@"---------------");
    NSLog(@"1");
    dispatch_queue_t queueS = dispatch_queue_create("test2", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queueS, ^{
        NSLog(@"2");
    });

    NSLog(@"3");
    /**
        输出顺序为
        ——————
        1
        2
        3
        解释：主队列为串行队列，而我们新建了一个串行队列test2，并且选择disapcth_sync同步执行，同步执行会阻塞当前队列，只有等block中的内容执行完成后再返回，因此执行顺序为1，2， 3
        通常，我们只使用sync来确保代码按顺序执行；大部分情况我们都使用async，这一饿更好的利用CPU，提升程序运行速度。
     */
}

- (void)test3 {
    NSLog(@"---------------");
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

/**
    输出结果为程序崩溃

    解释：我们没有新增队列，而是新增了一个block任务到主队列中去执行。由于主队列是串行队列，因此新增的block任务要等到主队列中任务执行完了再执行（block等待主队列），而block任务是sync执行，因此会阻塞当前队列，只有block里的内容执行完了再返回（主队列等待block执行完成后返回），因此在主队列的两个任务相互等待，导致了死锁。
 */
- (void)test4 {
    NSLog(@"---------------");
    NSLog(@"1");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
    /**
        输出顺序为
        ——————
        1
        3
        2
        解释：主队列为串行队列，我们在主队列新增了一个block任务，并且选择disapcth_async异步执行，异步会立即返回并继续向后执行代码，而新增的block任务会等待主队列前面的任务完成后再执行，因此执行顺序为1，3，2
     */
}

- (void)test5 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"----1,%@", [NSThread currentThread]);
        [self performSelector:@selector(test5_1) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop] run];
        
        [self performSelector:@selector(test5_2) withObject:nil afterDelay:5.0];

        NSLog(@"----4，%@", [NSThread currentThread]);

        NSLog(@"----5，%@", [NSThread currentThread]);
    });
}

- (void)test5_1 {
    NSLog(@"----2，%@", [NSThread currentThread]);
}

- (void)test5_2 {
    NSLog(@"----3，%@", [NSThread currentThread]);
}

@end
