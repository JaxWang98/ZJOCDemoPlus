//
//  ThreadLoackProtocol.h
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/14.
//  Copyright © 2020 widerness. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ThreadLockProtocol <NSObject>

/// 每个锁都要实现卖票方法
- (void)sellingTickets;


@end

NS_ASSUME_NONNULL_END
