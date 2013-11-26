//
//  AppHelper.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

- (id)init{
    self = [super init];
    if (self) {
        
        _appCenter       = [[AppCenter alloc] init];
        _userCenter      = [[UserCenter alloc] init];
        _upDateChecker   = [[UpDateChecker alloc] init];
        _appStoreComment = [[AppStoreComment alloc] init];
        
    }
    return  self;
}

+ (AppHelper *)shareHelper{
    static AppHelper *appHelper;
    
    @synchronized(self) {
        if(!appHelper) {
            appHelper = [[AppHelper alloc] init];
        }
    }
    
    return appHelper;
}

@end
