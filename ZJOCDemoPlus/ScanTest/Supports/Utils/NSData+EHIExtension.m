//
//  NSData+EHIExtension.m
//  1haiiPhone
//
//  Created by LuckyCat on 2017/11/22.
//  Copyright © 2017年 EHi. All rights reserved.
//

#import "NSData+EHIExtension.h"

/** AES加密位数 */
static NSInteger const kEHIAESMode = 16;

@implementation NSData (EHIExtension)

/** AES解密：CFB模式 */
- (NSData *)aes256ByCFBModeWithOperation:(CCOperation)operation key:(NSString *)keyStr iv:(NSString *)ivStr {
    NSData *originData = self;
    if (operation == kCCEncrypt) {
        // 加密:位数不够的补全
        originData = [self fullData:originData mode:kEHIAESMode];
    }
    
    const char *iv = [[ivStr dataUsingEncoding:NSUTF8StringEncoding] bytes];
    const char *key = [[keyStr dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // 加密/解密
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreateWithMode(operation,
                                                     kCCModeCFB,
                                                     kCCAlgorithmAES,
                                                     ccNoPadding,
                                                     iv,
                                                     key,
                                                     keyStr.length,
                                                     NULL,
                                                     0,
                                                     0,
                                                     0,
                                                     &cryptor);
    if (status != kCCSuccess) {
        NSLog(@"AES加密/解密失败 error: %@", @(status));
        return nil;
    }
    
    // 输出加密/解密数据
    NSUInteger inputLength = originData.length;
    char *outData = malloc(inputLength);
    memset(outData, 0, inputLength);
    
    size_t outLength = 0;
    CCCryptorUpdate(cryptor, originData.bytes, inputLength, outData, inputLength, &outLength);
    NSData *resultData = [NSData dataWithBytes:outData length:outLength];
    
    CCCryptorRelease(cryptor);
    free(outData);
    
    if (operation == kCCDecrypt) {
        // 解密:位数多的删除
        resultData = [self deleteData:resultData mode:kEHIAESMode];
    }
    return resultData;
}

/** 加密:位数不够的补全
    补位规则：1.length=13,补5位05
            2.length=16,补16位ff */
- (NSData *)fullData:(NSData *)originData mode:(NSUInteger)mode {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithData:originData];
    // 确定要补全的个数
    NSUInteger shouldLength = mode * ((tmpData.length / mode) + 1);
    NSUInteger diffLength = shouldLength - tmpData.length;
    uint8_t *bytes = malloc(sizeof(*bytes) * diffLength);
    for (NSUInteger i = 0; i < diffLength; i++) {
        // 补全缺失的部分
        bytes[i] = diffLength;
    }
    [tmpData appendBytes:bytes length:diffLength];
    return tmpData;
}

/** 解密:位数多的删除
    删位规则：最后一位数字在1-16之间,且连续n位相同n数字 */
- (NSData *)deleteData:(NSData *)originData mode:(NSUInteger)mode {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithData:originData];
    Byte *bytes = (Byte *)tmpData.bytes;
    Byte lastNo = bytes[tmpData.length - 1];
    if (lastNo >= 1 && lastNo <= mode) {
        NSUInteger count = 0;
        // 确定多余的部分正确性
        for (NSUInteger i = tmpData.length - lastNo; i < tmpData.length; i++) {
            if (lastNo == bytes[i]) {
                count ++;
            }
        }
        if (count == lastNo) {
            // 截取正常的部分
            NSRange replaceRange = NSMakeRange(0, tmpData.length - lastNo);
            return [tmpData subdataWithRange:replaceRange];
        }
    }
    return originData;
}

/** 转为base64 */
- (NSString *)ehi_base64EncodedString {
    NSUInteger length = self.length;
    if (length == 0)
        return @"";
    
    NSUInteger out_length = ((length + 2) / 3) * 4;
    uint8_t *output = malloc(((out_length + 2) / 3) * 4);
    if (output == NULL)
        return nil;
    
    const char *input = self.bytes;
    NSInteger i, value;
    for (i = 0; i < length; i += 3) {
        value = 0;
        for (NSInteger j = i; j < i + 3; j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = ehi_base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = ehi_base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = ((i + 1) < length)
        ? ehi_base64EncodingTable[(value >> 6) & 0x3F]
        : '=';
        output[index + 3] = ((i + 2) < length)
        ? ehi_base64EncodingTable[(value >> 0) & 0x3F]
        : '=';
    }
    
    NSString *base64 = [[NSString alloc] initWithBytes:output
                                                length:out_length
                                              encoding:NSASCIIStringEncoding];
    free(output);
    return base64;
}

static const char ehi_base64EncodingTable[64]
= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short ehi_base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2,  -1,  -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62,  -2,  -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2,  -2,  -2, -2, -2,
    -2, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2,  -2,  -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2
};

@end
