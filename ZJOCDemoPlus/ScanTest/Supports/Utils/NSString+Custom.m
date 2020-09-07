//
//  NSString+Custom.m
//  chauffeur
//
//  Created by ehi on 14-4-21.
//  Copyright (c) 2014年 1hai. All rights reserved.
//

#import "NSString+Custom.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "NSString+YYAdd.h"
#import "NSData+YYAdd.h"
#import "NSData+EHIExtension.h"

//const Byte iv[] = {1,2,3,4,5,6,7,8};
@implementation NSString (Custom)
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key
{
//    plainText = [plainText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//    plainText = [plainText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    plainText = [plainText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    plainText = [plainText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData* encryptData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [encryptData length];
    vplainText = (const void *)[encryptData bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
//    NSString *initVec = @"12345678";
//    const void *vkey = (const void *) [key UTF8String];
//    const void *vinitVec = (const void *) [initVec UTF8String];
    NSData *keyData = [key dataUsingEncoding: NSUTF8StringEncoding];
    Byte *iv = (Byte *)[keyData bytes];
    
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmDES,
                                       kCCOptionPKCS7Padding,
                                       [key UTF8String],
                                       kCCKeySizeDES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    NSString *result = nil;

    if (ccStatus == kCCSuccess){
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:data];
    }
    free(bufferPtr);
    return result;
    
    
//    plainText=[plainText stringByReplacingOccurrencesOfString:@" " withString:@""];
//    plainText=[plainText stringByReplacingOccurrencesOfString: @"\r" withString:@""];
//    plainText=[plainText stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    
//    NSString *ciphertext = nil;
//	NSData *keyData = [key dataUsingEncoding: NSUTF8StringEncoding];
//	Byte *iv = (Byte *)[keyData bytes];
//    const char *textBytes = [plainText UTF8String];
//    NSUInteger dataLength = [plainText length];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          iv,
//                                          textBytes, dataLength,
//                                          buffer, 1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        
//        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
//    }
//    return ciphertext;
    
//    NSString *ciphertext = nil;
//    
//    NSData *keyData = [key dataUsingEncoding: NSUTF8StringEncoding];
//    Byte *iv = (Byte *)[keyData bytes];
//    
//    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger dataLength = [textData length];
//    
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          iv,
//                                          [textData bytes], dataLength,
//                                          buffer, 1024,
//                                          &numBytesEncrypted);
//         if (cryptStatus == kCCSuccess) {
//                NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//                ciphertext = [GTMBase64 stringByEncodingData:data];
////                ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
//        }
//        return ciphertext;
}

//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
	NSData *keyData = [key dataUsingEncoding: NSUTF8StringEncoding];
	Byte *iv = (Byte *)[keyData bytes];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    
    bufferPtrSize = ([cipherData length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          (void *)bufferPtr,
                                          bufferPtrSize,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:bufferPtr length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    free(bufferPtr);
    return plainText;
}
//+(NSString *) encryptDES:(Byte *)srcBytes key:(NSString *)key useEBCmode:(BOOL)useEBCmode
//{
//    NSString *ciphertext = nil;
//    NSUInteger dataLength = strlen((const char*)srcBytes);
//    Byte *encryptBytes = malloc(1024);
//    memset(encryptBytes, 0, 1024);
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          useEBCmode ? (kCCOptionPKCS7Padding | kCCOptionECBMode):kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          iv,
//                                          srcBytes	, dataLength,
//                                          encryptBytes, 1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess)
//    {
//        NSData *data=[NSData dataWithBytes:encryptBytes length:numBytesEncrypted];
//        ciphertext=[self base64Encoding:data];
//		
//    }
//    else
//    {
//		
//    }
//    return ciphertext;
//}
//static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//
///**
// 64编码
// */
//+(NSString *)base64Encoding:(NSData*) text
//{
//    if (text.length == 0)
//        return @"";
//    
//    char *characters = malloc(text.length*3/2);
//    
//    if (characters == NULL)
//        return @"";
//    
//    int end = text.length - 3;
//    int index = 0;
//    int charCount = 0;
//    int n = 0;
//    
//    while (index <= end) {
//        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
//        | (((int)(((char *)[text bytes])[index + 1]) & 0x0ff) << 8)
//        | ((int)(((char *)[text bytes])[index + 2]) & 0x0ff);
//        
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = encodingTable[(d >> 6) & 63];
//        characters[charCount++] = encodingTable[d & 63];
//        
//        index += 3;
//        
//        if(n++ >= 14)
//        {
//            n = 0;
//            characters[charCount++] = ' ';
//        }
//    }
//    
//    if(index == text.length - 2)
//    {
//        int d = (((int)(((char *)[text bytes])[index]) & 0x0ff) << 16)
//        | (((int)(((char *)[text bytes])[index + 1]) & 255) << 8);
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = encodingTable[(d >> 6) & 63];
//        characters[charCount++] = '=';
//    }
//    else if(index == text.length - 1)
//    {
//        int d = ((int)(((char *)[text bytes])[index]) & 0x0ff) << 16;
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = '=';
//        characters[charCount++] = '=';
//    }
//    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
//    return rtnStr;
//}
///******************************************************************************
// 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
// 函数描述 : base64格式字符串转换为文本数据
// 输入参数 : (NSString *)string
// 输出参数 : N/A
// 返回参数 : (NSData *)
// 备注信息 :
// ******************************************************************************/
//+ (NSData *)dataWithBase64EncodedString:(NSString *)string
//{
//    if (string == nil)
//        [NSException raise:NSInvalidArgumentException format:nil];
//    if ([string length] == 0)
//        return [NSData data];
//    
//    static char *decodingTable = NULL;
//    if (decodingTable == NULL)
//    {
//        decodingTable = malloc(256);
//        if (decodingTable == NULL)
//            return nil;
//        memset(decodingTable, CHAR_MAX, 256);
//        NSUInteger i;
//        for (i = 0; i < 64; i++)
//            decodingTable[(short)encodingTable[i]] = i;
//    }
//    
//    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
//    if (characters == NULL)     //  Not an ASCII string!
//        return nil;
//    char *bytes = malloc((([string length] + 3) / 4) * 3);
//    if (bytes == NULL)
//        return nil;
//    NSUInteger length = 0;
//    
//    NSUInteger i = 0;
//    while (YES)
//    {
//        char buffer[4];
//        short bufferLength;
//        for (bufferLength = 0; bufferLength < 4; i++)
//        {
//            if (characters[i] == '\0')
//                break;
//            if (isspace(characters[i]) || characters[i] == '=')
//                continue;
//            buffer[bufferLength] = decodingTable[(short)characters[i]];
//            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
//            {
//                free(bytes);
//                return nil;
//            }
//        }
//        
//        if (bufferLength == 0)
//            break;
//        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
//        {
//            free(bytes);
//            return nil;
//        }
//        
//        //  Decode the characters in the buffer to bytes.
//        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
//        if (bufferLength > 2)
//            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
//        if (bufferLength > 3)
//            bytes[length++] = (buffer[2] << 6) | buffer[3];
//    }
//    
//    bytes = realloc(bytes, length);
//    return [NSData dataWithBytesNoCopy:bytes length:length];
//}
//+(NSString *) parseByte2HexString:(Byte *) bytes
//{
//    NSMutableString *hexStr = [[NSMutableString alloc]init];
//    int i = 0;
//    if(bytes)
//    {
//        while (bytes[i] != '\0')
//        {
//            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
//            if([hexByte length]==1)
//                [hexStr appendFormat:@"0%@", hexByte];
//            else
//                [hexStr appendFormat:@"%@", hexByte];
//            
//            i++;
//        }
//    }
//    return hexStr;
//}
//
///*DES decrypt*/
//+(NSString *) decryptDES:(Byte *)srcBytes key:(NSString *)key useEBCmode:(BOOL)useEBCmode
//{
//	NSString *plainText;
//    NSUInteger dataLength = strlen((const char*)srcBytes);
//    Byte *decryptBytes = malloc(1024);
//    memset(decryptBytes, 0, 1024);
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
//                                          useEBCmode ? (kCCOptionPKCS7Padding | kCCOptionECBMode):kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          iv,
//                                          srcBytes	, dataLength,
//                                          decryptBytes, 1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess)
//    {
//		NSData *data=[NSData dataWithBytes:decryptBytes length:numBytesEncrypted];
//		plainText=[self parseByte2HexString:decryptBytes];
//        return plainText;
//    }
//    else
//    {
//        return nil;
//    }
//}
//+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
//{
//    return [self encryptDES:(unsigned char *)plainText.UTF8String key:key useEBCmode:NO];
//    
//}
//+(NSString *)decryptDES:(NSString *)cryptString key:(NSString *)key{
//	
//	return [self decryptDES:(unsigned char *)cryptString.UTF8String key:key
//							 useEBCmode:NO];
//	
//}
-(BOOL)ISURL{
//	NSRegularExpression *regularexpressionURL = [[NSRegularExpression alloc]
//												 
//                                                 initWithPattern:@"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
//												 
//                                                 options:NSRegularExpressionCaseInsensitive
//												 
//                                                 error:nil];
//	
//    NSUInteger numberofMatchURL = [regularexpressionURL numberOfMatchesInString:self
//								   
//                                                                        options:NSMatchingReportProgress
//								   
//                                                                          range:NSMakeRange(0, self.length)];
//	return numberofMatchURL>0;
    NSRegularExpression *regularexpressionURL = [[NSRegularExpression alloc]
                                                 
                                                 initWithPattern:@"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
                                                 
                                                 options:NSRegularExpressionCaseInsensitive
                                                 
                                                 error:nil];
    
    NSUInteger numberofMatchURL = [regularexpressionURL numberOfMatchesInString:self
                                   
                                                                        options:NSMatchingReportProgress
                                   
                                                                          range:NSMakeRange(0, self.length)];
    
    NSRegularExpression *regularexpressionURL1 = [[NSRegularExpression alloc]
                                                  
                                                  initWithPattern:@"https://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
                                                  
                                                  options:NSRegularExpressionCaseInsensitive
                                                  
                                                  error:nil];
    
    NSUInteger numberofMatchURL1 = [regularexpressionURL1 numberOfMatchesInString:self
                                    
                                                                          options:NSMatchingReportProgress
                                    
                                                                            range:NSMakeRange(0, self.length)];
    if(numberofMatchURL>0||numberofMatchURL1>0){
        return YES;
    }else{
        return NO;
    }
}
-(instancetype)MD5String{
	const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

//md5大写
-(instancetype)MD5StringUP{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    
    NSLog(@"大写ret: %@", ret);
    return ret;
}

- (BOOL)isPureInt{
	NSScanner* scan = [NSScanner scannerWithString:self];
	int val;
	return [scan scanInt:&val] && [scan isAtEnd];
}

/** 判断字符串是否是nil或空或不合格 */
+ (BOOL)isNilOrEmpty:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return true;
    }
    if ((nil == str) || [str isEqual:[NSNull null]]) {
        return true;
    }
    if (!str.length) {
        return true;
    }
    if (![str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        return true;
    }
    NSArray *array = @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null",
                       @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
    if ([array containsObject:str]) {
        return true;
    }
    return false;
}

/** 排除空的情况 */
+ (NSString *)trimNilOrNuLL:(NSString *)str {
    if ([NSString isNilOrEmpty:str]) {
        return @"";
    }
    return [str stringByTrim];
}

/** NSNumber转NSString */
+ (NSString *)stringWithNumber:(NSNumber *)number {
    if (![number isKindOfClass:[NSNumber class]]) {
        return @"";
    }
    if ((nil == number) || [number isEqual:[NSNull null]]) {
        return @"0";
    }
    NSString *str = [NSString stringWithFormat:@"%@", number];
    return str;
}

/** 获取字符串的宽:高度为字体大小 */
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font {
    CGFloat width = [NSString widthWithString:string font:font height:0];
    return width;
}

/** 获取字符串的宽:高固定,如果高度小于字体大小,高度为字体大小 */
+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height {
    if (height < font.pointSize) {
        height = font.pointSize;
    }
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    CGFloat width = textRect.size.width;
    return width + 5; // 新系统问题
}

// 处理<br/>等特殊符号转换
+ (NSString *)handlingSpecialSymbols:(NSString *)string {
    string = [NSString trimNilOrNuLL:string];
    if (0 < string.length) {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    }
    return string;
}

- (NSString *)replaceStringByPrivate:(NSRange)range {
    if (range.location +1 < self.length && (range.length + range.location) + 1 < self.length && self.length >7){

        NSMutableString *str = [@"*" mutableCopy];
        for (int i=0; i < range.length - 1; i++) {
            [str appendString:@"*"];
        }
        NSString *header = [self substringToIndex:3];
        NSString *footer = [self substringFromIndex:self.length -4];
        
        return [NSString stringWithFormat:@"%@%@%@",header,str,footer];
    }
    return  self;
}

- (BOOL)isNilOrEmpty {
    if (self == nil || [self isEqualToString:@""]) {
        return  YES;
    } else {
        return  NO;
    }
}

/** 数字、横线正则判断 */
- (BOOL)isInputRuleNumberAndLine {
    if ([NSString isNilOrEmpty:self]) {
        return NO;
    }
    NSString *pattern = @"^[0-9-]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

/** 字母、数字正则判断 */
- (BOOL)isInputRuleNumberAndCharacter {
    if ([NSString isNilOrEmpty:self]) {
        return NO;
    }
    NSString *pattern = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

/** 字母(大写)、数字正则判断 */
- (BOOL)isInputRuleNumberAndCapitalCharacter {
    if ([NSString isNilOrEmpty:self]) {
        return NO;
    }
    NSString *pattern = @"^[A-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=self.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[self characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:self].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
        
    }
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}
- (NSString *)filterChinese {
    NSString *searchText = self;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
- (NSString *)filter_outOfChinese {
    NSString *searchText = self;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
- (BOOL)isOutofChinese {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^\u4e00-\u9fa5]"];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}


- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}
//邮箱
- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

/** AES加密：key */
static NSString * const kAESKey = @"th!s!s@p@ssw0rd;setoae$12138!@$@";
/** AES加密：iv */
static NSString * const kAESIv = @"-o@g*m,%0!si^fo1";

/** AES解密 */
- (NSDictionary *)aes256Decrypt {
    // 1.URL Decode
    NSString *urlDecodeStr = [self stringByURLDecode];
    // 2.Base64 Decode
    NSData *base64DecodeData = [NSData dataWithBase64EncodedString:urlDecodeStr];
    // 3.Aes256 解密
    NSData *decodeData = [base64DecodeData aes256ByCFBModeWithOperation:kCCDecrypt key:kAESKey iv:kAESIv];
    NSString *decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    if ([NSString isNilOrEmpty:decodeStr]) {
        // 解密失败
        return nil;
    }
    // 去掉多余的字符串 因为解密有补全机制,所以后面会有多余字符
    NSRange endRange = [decodeStr rangeOfString:@"}"];
    if (endRange.location != NSNotFound) {
        decodeStr = [decodeStr substringToIndex:endRange.location + 1];
    }
    // 4.json转字典
    NSError *error;
    NSData *jsonData = [decodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    }
    return dic;
}

/** AES加密 */
- (NSString *)aes256Encrypt {
    NSData *originData = [self dataUsingEncoding:NSUTF8StringEncoding];
    // 1.Aes256 加密
    NSData *encodeData = [originData aes256ByCFBModeWithOperation:kCCEncrypt key:kAESKey iv:kAESIv];
    // 2.Base64 Encode
    NSString *base64EncodeStr = [encodeData base64EncodedString];
    // 3.URL Encode
    NSString *urlEncodeStr = [base64EncodeStr stringByURLEncode];
    return urlEncodeStr;
}

/** 生成唯一的图片名称字符串 */
+ (NSString *)generateImageNameUUIDString {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", uuidString];
    
    return fileName;
}

@end
