//
//  SkinLab.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-17.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

//系统
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>

//Http请求库
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SkinLabHttpClient.h"

//图片异步加载库
#import "UIImageView+AFNetworking.h"

//自定义
#import "DataCenter.h"
#import "CustomerMethod.h"
#import "ZKIButton.h"

#import "MMDrawerBarButtonItem.h"

//友盟统计
#import "MobClick.h"
//新浪微博
#import "WeiboSDK.h"

#import "ZKIAnalytics.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KSNTHeight 113
#define KSTHeight  69
#define KSNHeight  64
#define KSHeight   20

#define BlueColor          [UIColor colorWithRed:43/255.0  green:184/255.0 blue:209/255.0 alpha:1]
#define GreenColor         [UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1]
#define LightGreenColor    [UIColor colorWithRed:154/255.0 green:194/255.0 blue:192/255.0 alpha:1]
#define RedColor           [UIColor colorWithRed:228/255.0 green:179/255.0 blue:156/255.0 alpha:1]
#define BlackColor         [UIColor colorWithRed:65/255.0  green:65/255.0  blue:65/255.0  alpha:1]
#define GrayColor          [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define TextGrayColor      [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1]

#define kAppKey         @"4107220967"
#define kRedirectURI    @"http://skin-lab.org"
