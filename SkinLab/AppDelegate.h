//
//  AppDelegate.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-17.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "LeftViewController.h"
#import "MainViewController.h"
#import "ShopViewController.h"
#import "UserCenterViewController.h"
#import "ConsultViewController.h"
#import "VIPMainViewController.h"
#import "InviteViewController.h"

#import "ZKIXmppServer.h"
#import "UpDateChecker.h"
#import "AppStoreComment.h"

#ifdef DEBUG
    #define MobStart NSLog(@"关闭友盟");
#else
    #define MobStart [MobClick startWithAppkey:@"513e9ed15270152000000043" reportPolicy:REALTIME channelId:[DataCenter shareData].appMarket];
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>{

}

@property (strong,    retain) NSString *wbtoken;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UpDateChecker     *upDateChecker;
@property (strong, nonatomic) AppStoreComment    *appStoreComment;
@property (strong, nonatomic) ZKIXmppServer      *xmppServer;
@property (strong, nonatomic) MMDrawerController *drawerController;

@property (strong, nonatomic) UINavigationController *mainViewController;
@property (strong, nonatomic) UINavigationController *shopViewController;
@property (strong, nonatomic) UINavigationController *userCenterViewController;
@property (strong, nonatomic) UINavigationController *consultViewController;

@end
