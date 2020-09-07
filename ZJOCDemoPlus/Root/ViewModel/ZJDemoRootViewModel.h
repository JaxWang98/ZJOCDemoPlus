//
//  ZJDemoRootViewModel.h
//  ZJOCDemoPlus
//
//  Created by jaxwang on 2020/8/7.
//  Copyright © 2020 widerness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJDemoRootListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^refreshUIDataBlock)(NSArray<ZJDemoRootListItemModel *> *dataSource);

@interface ZJDemoRootViewModel : NSObject

- (void)refreshUIWithData:(refreshUIDataBlock)refreshBlock;

@end

NS_ASSUME_NONNULL_END
