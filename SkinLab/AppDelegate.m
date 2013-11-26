//
//  AppDelegate.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-17.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "SkinLabHttpClient.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    初始化用户行为分析模块
    [ZKIAnalytics addNewAction:ZKIAnalyticsTypeLaunch withSubType:nil withKey:nil];
    
//    初始化微博模块
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
//    初始化XMPP服务
    self.xmppServer = [[ZKIXmppServer alloc] init];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        DLog(@"首次启动");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PushOn"];
    }

//    版本检测
//    [[AppHelper shareHelper].upDateChecker startChecker:@"663805293"];
    
//    评价应用
    [[AppHelper shareHelper].appStoreComment startAppStoreComment:@"663805293" withDelay:1];

//    启动友盟Appe分析工具
    MobStart
    
//    初始化数据中心
    if ([DataCenter isFileExist:@"want.plist"]) {
        [DataCenter shareData].wantArray = [[NSMutableArray alloc] initWithArray:[DataCenter readArrayFromFile:@"want.plist"]];
    }else{
        [DataCenter shareData].wantArray = [[NSMutableArray alloc] init];
    }
    
    if ([DataCenter isFileExist:@"using.plist"]) {
        [DataCenter shareData].usingArray = [[NSMutableArray alloc] initWithArray:[DataCenter readArrayFromFile:@"using.plist"]];
    }else{
        [DataCenter shareData].usingArray = [[NSMutableArray alloc] init];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[DataCenter getStringWithVersion:@"test"]]) {
        [DataCenter shareData].testResultArray = [DataCenter readDictionaryFromFile:@"testResult.plist"];
    }else{
        
    }
    
//    初始化主页面
    MainViewController *tempMainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tempMainViewController];
    self.mainViewController = navigationController;
    
    if ([AppHelper shareHelper].appCenter.isiOS7) {
        LeftViewController * leftDrawer = [[LeftViewController alloc] init];
        leftDrawer.view.backgroundColor = GrayColor;
        UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftDrawer];
        MMDrawerController * mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:self.mainViewController leftDrawerViewController:leftNavigationController];
        self.drawerController = mmDrawerController;
        
        [self.drawerController setShowsShadow:YES];
    }else{
        LeftViewController * leftDrawer = [[LeftViewController alloc] init];
        leftDrawer.view.backgroundColor = GrayColor;
        MMDrawerController * mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:self.mainViewController leftDrawerViewController:leftDrawer];
        self.drawerController = mmDrawerController;
        [self.drawerController setShowsShadow:YES];
    }
    
//    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:260];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    if ([AppHelper shareHelper].appCenter.isiOS7) {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }else{
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView:) name:@"ChangeView" object:nil];
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [ZKIAnalytics addNewAction:ZKIAnalyticsTypeClose withSubType:nil withKey:nil];
    
//    [[AppHelper shareHelper].upDateChecker upDateWhenQuite];
    
    [ZKIAnalytics beginUploadData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [ZKIAnalytics addNewAction:ZKIAnalyticsTypeLaunch withSubType:nil withKey:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [DataCenter shareData].deviceToken = token;
    
//    如果Push功能为开启状态则上传deviceToken
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PushOn"]) {
        [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSystemUploadToken]
                                        parameters:@{@"UserID": [DataCenter shareData].deviceID, @"DeviceToken": token}
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               DLog(@"%@", [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                           options:NSJSONReadingMutableLeaves
                                                                                             error:nil]);
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               DLog(@"%@",error);
                                           }];
    }

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DLog(@"退出时更新")
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateInactive) {
        DLog(@"看过")
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"663805293"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        DLog(@"没看过")
    }
   
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
    DLog(@"userinfo:%@",userInfo);
    
    for (NSString *key in [[userInfo objectForKey:@"aps"] allKeys]) {
        if ([key isEqualToString:@"weekly"]) {
            DLog(@"收到推送消息:宝典")
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWeeklyView" object:nil];
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        DLog(@"%@", response.userInfo)
        DLog(@"%@", response.requestUserInfo)
        DLog(@"%@", [(WBAuthorizeResponse *)response expirationDate])
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            NSString *info = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@", [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken]];
            [[AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info]]
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {                                                        
                                                                 
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiboLoginSuccess" object:nil userInfo:JSON];
                                                                 
                                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                 DLog(@"%@", error);
                                                             }] start];
        }
    }
    
}

- (void)changeView:(NSNotification *)notification {
    NSString *viewName = notification.userInfo[@"ViewName"];
    DLog(@"%@", notification.userInfo)
    
    if ([viewName isEqualToString:@"MainView"]) {
        
        [self.drawerController setCenterViewController:self.mainViewController withFullCloseAnimation:YES completion:nil];
        
    }else if ([viewName isEqualToString:@"ShopView"]) {
        if (self.shopViewController == nil) {
            ShopViewController *tempViewController = [[ShopViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tempViewController];
            self.shopViewController = navigationController;
            
            if ([AppHelper shareHelper].appCenter.isiOS7) {
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
            }else{
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
            }
        }
        
        [self.drawerController setCenterViewController:self.shopViewController withFullCloseAnimation:YES completion:nil];
        
    }else if ([viewName isEqualToString:@"UserCenterView"]) {
        if (self.userCenterViewController == nil) {
            UserCenterViewController *tempMainViewController = [[UserCenterViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tempMainViewController];
            self.userCenterViewController = navigationController;
            
            if ([AppHelper shareHelper].appCenter.isiOS7) {
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
            }else{
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
            }
        }
        
        [self.drawerController setCenterViewController:self.userCenterViewController withFullCloseAnimation:YES completion:nil];
        
    }else if ([viewName isEqualToString:@"ConsultView"]) {
        if (self.consultViewController == nil) {
            ConsultViewController *tempViewController = [[ConsultViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tempViewController];
            self.consultViewController = navigationController;
            
            if ([AppHelper shareHelper].appCenter.isiOS7) {
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
            }else{
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
            }
        }
        
        [self.drawerController setCenterViewController:self.consultViewController withFullCloseAnimation:YES completion:nil];
        
    }else if ([viewName isEqualToString:@"SettingView"]) {
        
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
        
        if ([AppHelper shareHelper].appCenter.isiOS7) {
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        }else{
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        }
        
        [self.drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:nil];
        
    }else if ([viewName isEqualToString:@"InviteView"]) {
        
        InviteViewController *settingViewController = [[InviteViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
        
        if ([AppHelper shareHelper].appCenter.isiOS7) {
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        }else{
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        }
        
        [self.drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:nil];
        
    }else if ([viewName isEqualToString:@"VIPMainView"]) {
        
        VIPMainViewController *vipMainViewController = [[VIPMainViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vipMainViewController];
        
        if ([AppHelper shareHelper].appCenter.isiOS7) {
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
        }else{
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        }
        
        [self.drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:nil];
        
    }
    
}


@end
