//
//  AppCenter.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AppCenter.h"

@implementation AppCenter

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *version = infoDict[@"CFBundleVersion"];
        
        _appVersion          = version;
        _appMarket           = @"AppStore";
        _deviceID            = [OpenUDID value];
        _deviceToken         = @"NoToken";
        _deviceSystemVersion = [[[UIDevice currentDevice] systemVersion] intValue];
        
        if (_deviceSystemVersion >= 7) {
            _isiOS7 = YES;
        }else{
            _isiOS7 = NO;
        }
        
        if ([UIScreen mainScreen].bounds.size.height > 480) {
            _isiPhone5 = YES;
        }else{
            _isiPhone5 = NO;
        }
        
        DLog(@"用户识别码 = %@", _deviceID)
    }
    return self;
}

@end
