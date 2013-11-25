//
//  UpDateChecker.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-23.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinLab.h"

@interface UpDateChecker : NSObject <UIAlertViewDelegate>{
    NSString *_newVersion;
    NSString *_appID;
    
}

- (void)startChecker:(NSString *)appID;

@end
