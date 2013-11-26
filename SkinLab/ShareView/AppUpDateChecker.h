//
//  AppUpDateChecker.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinLabHttpClient.h"

@interface AppUpDateChecker : NSObject <UIAlertViewDelegate> {
    NSString *_newVersion;
    NSString *_appID;
}

@property BOOL isNeedUpDateWhenQuite;

- (void)upDateWhenQuite;
- (void)openUpdateURL;
- (void)startChecker:(NSString *)appID;

@end
