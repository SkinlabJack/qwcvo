//
//  AppHelper.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppCenter.h"
#import "UserCenter.h"
#import "AppStoreComment.h"
#import "AppUpDateChecker.h"


@interface AppHelper : NSObject

@property (strong, nonatomic) AppCenter        *appCenter;
@property (strong, nonatomic) UserCenter       *userCenter;
@property (strong, nonatomic) AppStoreComment  *appStoreComment;
@property (strong, nonatomic) AppUpDateChecker *appUpDateChecker;

+ (AppHelper *)shareHelper;

@end
