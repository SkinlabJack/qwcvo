//
//  IOHelper.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "IOHelper.h"

@implementation IOHelper

+ (NSData *)cleanNullOfString:(NSString *)string {
    NSString *responseString = [string stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    return [responseString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)getStringWithVersion:(NSString *)string {
    
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDict[@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@%@", string, version];
}

+ (NSString *)getCurrentTime {
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:nowUTC];
}

+ (NSString*)getDocumentFilePath:(NSString*)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc_dir = paths[0];
	return[doc_dir stringByAppendingPathComponent:fileName];
}

+ (BOOL)isFileExist:(NSString *)fileName {
	NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[IOHelper getDocumentFilePath:fileName]];
}

+ (NSMutableDictionary *)readDictionaryFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    return dictionary;
}

+ (NSMutableArray *)readArrayFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSMutableArray *dictionary = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    return dictionary;
}

+ (BOOL)removeFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:filePath error:nil])
        return true;
    else
        return false;
}

+ (BOOL)isNull:(id)file{
    if ([file isEqual:[NSNull null]]) {
        DLog(@"Null");
        return YES;
    }else{
        if ([file isKindOfClass:[NSArray class]]) {
            return NO;
        }else if ([file isKindOfClass:[NSDictionary class]]) {
            return NO;
        }else{
            if ([file isEqualToString:@""] || [file isEqualToString:@"NULL"] || [file isEqualToString:@"null"]) {
                DLog(@"nullString")
                return YES;
            }else{
                return NO;
            }
        }
    }
}

+ (void)writeToFileAsyn:(id)file withFileName:(NSString *)fileName {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = paths[0];
        NSString *filepath = [path stringByAppendingPathComponent:fileName];
        [file writeToFile:filepath atomically:YES];
        DLog(@"writing %@ = %@", fileName, [file writeToFile:filepath atomically:YES]?@"写入成功":@"写入失败");
    });
}

+ (void)writeToFileSync:(id)file withFileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filepath = [path stringByAppendingPathComponent:fileName];
    [file writeToFile:filepath atomically:YES];
    DLog(@"writing %@ = %@", fileName, [file writeToFile:filepath atomically:YES]?@"写入成功":@"写入失败");
}


@end
