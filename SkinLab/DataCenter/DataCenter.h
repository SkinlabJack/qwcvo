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

@class AppDelegate;

@interface DataCenter : NSObject{

}

@property (strong, nonatomic) NSMutableArray *wantArray;
@property (strong, nonatomic) NSMutableArray *usingArray;
@property (strong, nonatomic) NSMutableArray *weeklyReadArray;
@property (strong, nonatomic) NSDictionary   *testResultArray;
@property (strong, nonatomic) NSArray        *classArray;
@property (strong, nonatomic) NSArray        *weeklyArray;

@property (strong, nonatomic) NSMutableDictionary *notReadNumberDictionary;

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

@end
