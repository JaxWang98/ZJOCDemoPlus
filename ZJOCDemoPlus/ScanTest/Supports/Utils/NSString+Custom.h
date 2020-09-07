//
//  NSString+Custom.h
//  chauffeur
//
//  Created by ehi on 14-4-21.
//  Copyright (c) 2014年 1hai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Custom)

+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
-(BOOL)ISURL;
-(instancetype)MD5String;
-(instancetype)MD5StringUP;
- (BOOL)isPureInt;

/**
 *  判断字符串是否是nil或空或不合格
 *
 *  @param str 一个字符串
 *
 *  @return 返回判断结果
 */
+ (BOOL)isNilOrEmpty:(NSString *)str;

/**
 *  排除空的情况
 *
 *  @param str 一个字符串
 *
 *  @return 返回""
 */
+ (NSString *)trimNilOrNuLL:(NSString *)str;

/**
 *  NSNumber转NSString
 *
 *  @param number 一个NSNumber
 *
 *  @return 一个字符串
 */
+ (NSString *)stringWithNumber:(NSNumber *)number;

/**
 *  获取字符串的宽:高度为字体大小
 *
 *  @param string 一个字符串
 *  @param font   字体
 *  @param height 高固定,如果高度小于字体大小,高度为字体大小
 *
 *  @return 文字宽度
 */
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font;

/**
 *  获取字符串的宽
 *
 *  @param string 一个字符串
 *  @param font   字体
 *  @param height 高固定,如果高度小于字体大小,高度为字体大小
 *
 *  @return 文字宽度
 */
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;

/**
 *  处理<br/>等特殊符号转换
 *
 *  @param string 待处理字符串
 *
 *  @return 处理后的字符串
 */
+ (NSString *)handlingSpecialSymbols:(NSString *)string;
/**
 *  处理中间指定字符成*
 *
 *  @param rang 需要知道的文字范围，如果范围有错误，不会奔溃，会返回原来字符串
 *
 *  @return 处理后的字符串
 */

- (NSString *)replaceStringByPrivate:(NSRange)range;


- (BOOL)isNilOrEmpty;

/** 数字、横线正则判断 */
- (BOOL)isInputRuleNumberAndLine;

/** 字母(大写)、数字正则判断 */
- (BOOL)isInputRuleNumberAndCapitalCharacter;

/** 字母、数字正则判断 */
- (BOOL)isInputRuleNumberAndCharacter;

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank;
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank;

/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji;
/**
 *  过滤中文
 */
- (NSString *)filterChinese;
/**
 *  过滤中文之外的字符
 */
- (NSString *)filter_outOfChinese;

- (BOOL)isOutofChinese;

- (BOOL)isEmailAddress;

/** AES解密 */
- (NSDictionary *)aes256Decrypt;

/** AES加密 */
- (NSString *)aes256Encrypt;

/** 生成唯一的图片名称字符串 */
+ (NSString *)generateImageNameUUIDString;

@end
