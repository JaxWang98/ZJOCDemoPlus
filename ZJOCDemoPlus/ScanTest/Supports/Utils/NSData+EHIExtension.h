//
//  NSData+EHIExtension.h
//  1haiiPhone
//
//  Created by LuckyCat on 2017/11/22.
//  Copyright © 2017年 EHi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCrypto.h>

@interface NSData (EHIExtension)

/** AES解密：CFB模式 */
- (NSData *)aes256ByCFBModeWithOperation:(CCOperation)operation key:(NSString *)keyStr iv:(NSString *)ivStr;

/** 转为base64 */
- (NSString *)ehi_base64EncodedString;

@end
