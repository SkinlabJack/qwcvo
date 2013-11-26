//
//  AppCenter.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenUDID.h"

@interface AppCenter : NSObject

@property (assign) BOOL isiOS7;
@property (assign) BOOL isiPhone5;

@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *appMarket;
@property (copy, nonatomic) NSString *deviceToken;
@property (copy, nonatomic) NSString *deviceID;
@property (assign, nonatomic) float  deviceSystemVersion;

@end
