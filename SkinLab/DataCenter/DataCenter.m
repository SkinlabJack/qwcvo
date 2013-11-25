//
//  DataCenter.m
//  tryseason
//
//  Created by Dai Qinfu on 12-8-15.
//  Copyright (c) 2012年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "DataCenter.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation DataCenter


- (id)init{
    self = [super init];
    if (self) {
        NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *version = infoDict[@"CFBundleVersion"];
        
        _upDataWhenQuite = NO;
        _appVersion = version;
        _appMarket  = @"AppStore";
        _deviceID   = [OpenUDID value];
        _deviceSystemVersion = [[[UIDevice currentDevice] systemVersion] intValue];
        
        DLog(@"用户识别码 = %@", _deviceID)
        
        if ([[[UIDevice currentDevice] systemVersion] intValue] == 7) {
            _isiOS7 = YES;
        }else{
            _isiOS7 = NO;
        }
        
        if (kScreenHeight > 480) {
            _deviceType = DeviceTypeiPhone5;
        }else{
            _deviceType = DeviceTypeiPhone4;
        }
        
        _isLogin    = NO;
        _hasAddress = NO;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"WeeklyRead"]) {
            NSMutableArray *weeklyReadArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"WeeklyRead"]];
            self.weeklyReadArray = weeklyReadArray;
        }else{
            self.weeklyReadArray = [NSMutableArray array];
        }
        
    }
    return  self;
}

+ (DataCenter *)shareData{
    static DataCenter *dataCenter;
    
    @synchronized(self) {
        if(!dataCenter) {
            dataCenter = [[DataCenter alloc] init];
        }
    }
    
    return dataCenter;
}

+ (BOOL)isiOS7 {
    return [DataCenter shareData].isiOS7;
}

+ (BOOL)isLogin {
    return [DataCenter shareData].isLogin;
}

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
    return [file_manager fileExistsAtPath:[DataCenter getDocumentFilePath:fileName]];
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

+ (void)writeToFile:(id)file withFileName:(NSString *)fileName {
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

#pragma mark - Favorite

- (BOOL)removeFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:filePath error:nil])
        return true;
    else
        return false;
}

- (void)addToMyWant:(NSDictionary *)dic {
    
    if (![self isMyWant:dic[@"productID"]]) {
        [self.wantArray addObject:dic];
        [self writeToFile:self.wantArray withFileName:@"want.plist"];
    }
}

- (void)addToMyUsing:(NSDictionary *)dic {
    
    if (![self isMyUsing:dic[@"productID"]]) {
        [self.usingArray addObject:dic];
        [self writeToFile:self.usingArray withFileName:@"using.plist"];
    }
}

- (void)deleteFromMyWant:(NSString *)productID {
    for (NSDictionary *dic in self.wantArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            
            if (self.wantArray.count == 1) {
                [self removeFile:@"want.plist"];
                self.wantArray = [[NSMutableArray alloc] init];
            }else{
                [self.wantArray removeObject:dic];
                [self writeToFile:self.wantArray withFileName:@"want.plist"];
            }
            DLog(@"wantArray = %d", self.wantArray.count);
            break;
        }
    }
}

- (void)deleteFromMyUsing:(NSString *)productID {
    for (NSDictionary *dic in self.usingArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            
            if (self.usingArray.count == 1) {
                [self removeFile:@"using.plist"];
                self.usingArray = [[NSMutableArray alloc] init];
            }else{
                [self.usingArray removeObject:dic];
                [self writeToFile:self.usingArray withFileName:@"using.plist"];
            }
            
            DLog(@"usingArray = %d", self.usingArray.count);
            break;
        }
    }
}

- (void)deleteFromMyWantAtIndex:(NSInteger *)row{
    
    if (self.wantArray.count == 1) {
        [self removeFile:@"want.plist"];
        self.wantArray = [[NSMutableArray alloc] init];
    }else{
        [self.wantArray removeObjectAtIndex:row];
        [self writeToFile:self.wantArray withFileName:@"want.plist"];
    }
    DLog(@"wantArray = %d", self.wantArray.count);
}

- (void)deleteFromMyUsingAtIndex:(NSInteger *)row{
    
    if (self.usingArray.count == 1) {
        [self removeFile:@"using.plist"];
        self.usingArray = [[NSMutableArray alloc] init];
    }else{
        [self.usingArray removeObjectAtIndex:row];
        [self writeToFile:self.usingArray withFileName:@"using.plist"];
    }
    DLog(@"usingArray = %d", self.usingArray.count);
}

- (BOOL)isMyWant:(NSString *)productID{
    for (NSDictionary *dic in self.wantArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isMyUsing:(NSString *)productID{
    for (NSDictionary *dic in self.usingArray) {
        if ([dic[@"productID"] isEqualToString:productID]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Weekly

- (void)markWeeklyRead:(NSString *)JID{
    if (![self isWeeklyRead:JID]) {
        [self.weeklyReadArray addObject:JID];
        [[NSUserDefaults standardUserDefaults] setObject:self.weeklyReadArray forKey:@"WeeklyRead"];
    }
    
    DLog(@"%@", self.weeklyReadArray)
}

- (BOOL)isWeeklyRead:(NSString *)JID{
    for (NSString *Journal in self.weeklyReadArray) {
        if ([JID isEqualToString:Journal]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - WriteToFile

- (void)writeToFile:(id)file withFileName:(NSString *)fileName {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = paths[0];
        NSString *filepath = [path stringByAppendingPathComponent:fileName];
        [file writeToFile:filepath atomically:YES];
        DLog(@"writing %@ = %@", fileName, [file writeToFile:filepath atomically:YES]?@"写入成功":@"写入失败");
    });
    
}

@end
