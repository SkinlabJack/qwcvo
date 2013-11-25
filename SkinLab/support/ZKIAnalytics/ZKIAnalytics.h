//
//  ZKIAnalytics.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-11.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ZKIAnalyticsTypePage,
    ZKIAnalyticsTypeWeekly,
    ZKIAnalyticsTypeSearch,
    ZKIAnalyticsTypeProduct,
    ZKIAnalyticsTypeIngredient,
    ZKIAnalyticsTypeLaunch,
    ZKIAnalyticsTypeClose
}ZKIAnalyticsType;

typedef enum{
    ZKIAnalyticsSubTypeNone,
    ZKIAnalyticsSubTypePageBegin,
    ZKIAnalyticsSubTypePageEnd,
    ZKIAnalyticsSubTypePageNormal
}ZKIAnalyticsSubType;

@interface ZKIAnalytics : NSObject {
    NSString *_userID;
    NSString *_appVersion;
    NSString *_number;
}

@property (strong) NSMutableArray *userActionArray;

+ (ZKIAnalytics *)shareAnalytics;
+ (void)beginUploadData;
+ (void)addNewAction:(ZKIAnalyticsType)type withSubType:(NSString *)subType withKey:(NSString *)key;

- (void)addNewAction:(ZKIAnalyticsType)type withSubType:(NSString *)subType withKey:(NSString *)key;
- (NSString *)getUpLoadDataString;

@end
