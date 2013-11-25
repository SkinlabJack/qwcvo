//
//  DataCenter.h
//  tryseason
//
//  Created by Dai Qinfu on 12-8-15.
//  Copyright (c) 2012年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SkinLabHttpClient.h"
#import "OpenUDID.h"

typedef enum{
    DeviceTypeiPhone5,
    DeviceTypeiPhone4
}DeviceType;

@class AppDelegate;

@interface DataCenter : NSObject{

}


@property BOOL pushOn;
@property BOOL upDataWhenQuite;
@property BOOL isiOS7;
@property BOOL isLogin;
@property BOOL hasAddress;

@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *appMarket;
@property (copy, nonatomic) NSString *deviceToken;
@property (copy, nonatomic) NSString *deviceID;

@property (assign, nonatomic) float deviceSystemVersion;
@property (assign, nonatomic) DeviceType deviceType;

@property (strong, nonatomic) NSMutableArray *favoriteArray;
@property (strong, nonatomic) NSMutableArray *wantArray;
@property (strong, nonatomic) NSMutableArray *usingArray;
@property (strong, nonatomic) NSMutableArray *weeklyReadArray;
@property (strong, nonatomic) NSDictionary   *testResultArray;
@property (strong, nonatomic) NSArray        *classArray;
@property (strong, nonatomic) NSArray        *weeklyArray;

+ (DataCenter *)shareData;

+ (BOOL)isiOS7;
+ (BOOL)isLogin;

+ (NSData *)cleanNullOfString:(NSString *)string;
+ (NSString *)getStringWithVersion:(NSString *)string;
+ (NSString *)getCurrentTime;
+ (NSString *)getDocumentFilePath:(NSString*)fileName;
+ (BOOL)isFileExist:(NSString *)filePath;
+ (NSMutableDictionary *)readDictionaryFromFile:(NSString *)fileName;
+ (NSMutableArray *)readArrayFromFile:(NSString *)fileName;

+ (BOOL)removeFile:(NSString *)fileName;
+ (BOOL)isNull:(id)file;
+ (void)writeToFile:(id)file withFileName:(NSString *)fileName;
+ (void)writeToFileSync:(id)file withFileName:(NSString *)fileName;

- (void)addToMyWant:(NSDictionary *)dic;
- (void)addToMyUsing:(NSDictionary *)dic;

- (void)deleteFromMyWant:(NSString *)productID;
- (void)deleteFromMyUsing:(NSString *)productID;

- (void)deleteFromMyWantAtIndex:(NSInteger *)row;
- (void)deleteFromMyUsingAtIndex:(NSInteger *)row;

- (BOOL)isMyWant:(NSString *)productID;
- (BOOL)isMyUsing:(NSString *)productID;

- (void)markWeeklyRead:(NSString *)JID;
- (BOOL)isWeeklyRead:(NSString *)JID;

- (void)writeToFile:(id)file withFileName:(NSString *)fileName;

@end
