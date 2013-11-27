//
//  IOHelper.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOHelper : NSObject

+ (NSData *)cleanNullOfString:(NSString *)string;
+ (NSString *)getStringWithVersion:(NSString *)string;
+ (NSString *)getCurrentTime;
+ (NSString *)getDocumentFilePath:(NSString*)fileName;
+ (BOOL)isFileExist:(NSString *)filePath;
+ (NSMutableDictionary *)readDictionaryFromFile:(NSString *)fileName;
+ (NSMutableArray *)readArrayFromFile:(NSString *)fileName;

+ (BOOL)removeFile:(NSString *)fileName;
+ (BOOL)isNull:(id)file;
+ (void)writeToFileAsyn:(id)file withFileName:(NSString *)fileName;
+ (void)writeToFileSync:(id)file withFileName:(NSString *)fileName;

@end
