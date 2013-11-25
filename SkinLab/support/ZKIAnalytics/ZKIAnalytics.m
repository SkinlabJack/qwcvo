//
//  ZKIAnalytics.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-11.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ZKIAnalytics.h"
#import "SkinLabHttpClient.h"
#import "OpenUDID.h"
#import "DataCenter.h"

@implementation ZKIAnalytics

//extern NSString *CTSettingCopyMyPhoneNumber();

- (void)dealloc{
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *version      = infoDict[@"CFBundleVersion"];
        
        _userActionArray = [[NSMutableArray alloc] init];
        _userID          = [OpenUDID value];
        _appVersion      = version;
//        _number          = CTSettingCopyMyPhoneNumber();
        
        if ([DataCenter isFileExist:@"userActionArray.plist"]) {
            
            NSArray *array = [DataCenter readArrayFromFile:@"userActionArray.plist"];
            NSString *isFirstLaunch;
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ZKIAnalyticsLaunch"]) {
                isFirstLaunch = @"no";
            }else{
                isFirstLaunch = @"yes";
            }
            
            NSDictionary *dic = @{@"UserID": _userID, @"Date": [self getCurrentTime],
                                  @"Event": array, @"IsFirstLaunch": isFirstLaunch,
                                  @"AppVersion": _appVersion, @"DateSince1970": [self getTimeSince1970],
                                  @"Client": @"iOS"};
            DLog(@"%@", dic)
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ZKIAnalyticsLaunch"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZKIAnalyticsLaunch"];
            }
            
            if ([NSJSONSerialization isValidJSONObject:dic])
            {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [[SkinLabHttpClient sharedClient] postPath:@"user/index.php?addUserBehavior"
                                                parameters:@{@"Behavior": json, @"userID": [OpenUDID value]}
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       DLog(@"%@", operation.responseString)
                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       DLog(@"%@",error);
                                                   }];
                
            }
            
        }
        
    }
    return self;
}

- (void)addNewAction:(ZKIAnalyticsType)type withSubType:(NSString *)subType withKey:(NSString *)key {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    switch (type) {
        case ZKIAnalyticsTypePage:{
            [dic setObject:@"ZKIAnalyticsTypePage" forKey:@"Type"];
            break;
        }
            
        case ZKIAnalyticsTypeWeekly:{
            [dic setObject:@"ZKIAnalyticsTypeWeekly" forKey:@"Type"];
            break;
        }
            
        case ZKIAnalyticsTypeProduct:{
            [dic setObject:@"ZKIAnalyticsTypeProduct" forKey:@"Type"];
            break;
        }
            
        case ZKIAnalyticsTypeSearch:{
            [dic setObject:@"ZKIAnalyticsTypeSearch" forKey:@"Type"];
            break;
        }
            
        case ZKIAnalyticsTypeIngredient:{
            [dic setObject:@"ZKIAnalyticsTypeIngredient" forKey:@"Type"];
            break;
        }
            
        case ZKIAnalyticsTypeLaunch:{
            [dic setObject:@"ZKIAnalyticsTypeLaunch" forKey:@"Type"];
            break;
        }
            
        case ZKIAnalyticsTypeClose:{
            [dic setObject:@"ZKIAnalyticsTypeClose" forKey:@"Type"];
            break;
        }
            
        default:
            break;
    }
    
    if (![key isEqualToString:@""] && key != nil) {
        [dic setObject:key forKey:@"Key"];
    }else {
        [dic setObject:@"" forKey:@"Key"];
    }
    
    if (![subType isEqualToString:@""] && key != nil) {
        [dic setObject:subType forKey:@"SubType"];
    }else {
        [dic setObject:@"" forKey:@"SubType"];
    }
    
    [dic setObject:[self getCurrentTime] forKey:@"Date"];
    [dic setObject:[self getTimeSince1970] forKey:@"DateSince1970"];
    
    [self.userActionArray addObject:dic];
    
     DLog(@"%@", dic)
}

- (NSString *)getUpLoadDataString {
    
    NSString *isFirstLaunch;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ZKIAnalyticsLaunch"]) {
        isFirstLaunch = @"no";
    }else{
        isFirstLaunch = @"yes";
    }
    
    NSDictionary *dic = @{@"UserID": _userID, @"Date": [self getCurrentTime],
                          @"Event": self.userActionArray, @"IsFirstLaunch": isFirstLaunch,
                          @"AppVersion": _appVersion, @"DateSince1970": [self getTimeSince1970],
                          @"Client": @"iOS"};
    DLog(@"%@", dic)
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ZKIAnalyticsLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZKIAnalyticsLaunch"];
    }
    
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        return json;
    }else{
        return @"";
    }
    
}

- (NSString *)getCurrentTime {
    NSDate *nowUTC = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:nowUTC];
}

- (NSString *)getTimeSince1970{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [NSNumber numberWithDouble:time].stringValue;
}

+ (ZKIAnalytics *)shareAnalytics{
    static ZKIAnalytics *zkiAnalytics;
    
    @synchronized(self) {
        if(!zkiAnalytics) {
            zkiAnalytics = [[ZKIAnalytics alloc] init];
        }
    }
    
    return zkiAnalytics;
}

+ (void)addNewAction:(ZKIAnalyticsType)type withSubType:(NSString *)subType withKey:(NSString *)key{
    [[ZKIAnalytics shareAnalytics] addNewAction:type withSubType:subType withKey:key];
    [DataCenter writeToFileSync:[ZKIAnalytics shareAnalytics].userActionArray withFileName:@"userActionArray.plist"];
}

+ (void)beginUploadData {
    
#ifdef DEBUG
    DLog(@"ZKIAnalytics 关闭状态")
    [[ZKIAnalytics shareAnalytics] getUpLoadDataString];
    [[ZKIAnalytics shareAnalytics].userActionArray removeAllObjects];
#else
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
        if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
            UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
            
            __block UIBackgroundTaskIdentifier background_task; //Create a task object
            
            background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
                [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
                background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
            }];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[SkinLabHttpClient sharedClient] postPath:@"user/index.php?addUserBehavior"
                                                parameters:@{@"Behavior": [[ZKIAnalytics shareAnalytics] getUpLoadDataString], @"userID": [OpenUDID value]}
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       
                                                       DLog(@"%@", operation.responseString)
                                                       [[ZKIAnalytics shareAnalytics].userActionArray removeAllObjects];
                                                       [DataCenter removeFile:@"userActionArray.plist"];
                                                       
                                                       [application endBackgroundTask: background_task];
                                                       background_task = UIBackgroundTaskInvalid;
                                                       
                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       DLog(@"%@",error);
                                                       
                                                       [application endBackgroundTask: background_task];
                                                       background_task = UIBackgroundTaskInvalid;
                                                   }];
                
            });
        }
    }
#endif
    
}

@end
