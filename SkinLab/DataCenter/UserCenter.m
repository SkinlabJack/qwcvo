//
//  UserCenter.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "UserCenter.h"

@implementation UserCenter

- (id)init
{
    self = [super init];
    if (self) {
        _isLogin    = NO;
        _hasAddress = NO;
    }
    return self;
}

@end
