//
//  AppStoreComment.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-23.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataCenter.h"

@interface AppStoreComment : NSObject <UIAlertViewDelegate>{
    int _delayDays;
    NSString *_appID;
    
}

@property (copy, nonatomic) NSString *firstLaunchDateWithVersion;

- (void)startAppStoreComment:(NSString *)appID withDelay:(int)days;

@end
