//
//  AppUpDateChecker.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-26.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AppUpDateChecker.h"

@implementation AppUpDateChecker

- (id)init
{
    self = [super init];
    if (self) {
        _isNeedUpDateWhenQuite = NO;
    }
    return self;
}

- (void)startChecker:(NSString *)appID{
    _appID = appID;
    [self httpRequestCheckUpData];
    
    DLog(@"版本检测启动")
}

- (void)upDateWhenQuite {
    if (self.isNeedUpDateWhenQuite) {
        
        UILocalNotification * localNotification = [[UILocalNotification alloc] init];
        if (localNotification) {
            localNotification.fireDate    = [NSDate dateWithTimeIntervalSinceNow:0.1];
            localNotification.timeZone    = [NSTimeZone defaultTimeZone];
            localNotification.alertBody   = @"升级SkinLab到最新版本。";
            localNotification.alertAction = @"升级";
            localNotification.soundName   = @"";
            
            UIApplication *application = [UIApplication sharedApplication];
            [application scheduleLocalNotification:localNotification];
        }
    }
    
}

- (void)openUpdateURL{
    if (self.isNeedUpDateWhenQuite) {
        DLog(@"退出时更新")
        [self performSelector:@selector(methodToRedirectToURL) withObject:nil afterDelay:0.1];
        self.isNeedUpDateWhenQuite = NO;
    }
}

- (void)methodToRedirectToURL {
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", _appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)httpRequestCheckUpData{
    
    [[SkinLabHttpClient sharedClient] getPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSystemVersion]
                                   parameters:@{@"id": @""}
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          
                                          NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                  options:NSJSONReadingMutableLeaves
                                                                                                    error:nil];
                                          
                                          NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
                                          NSString *version =[infoDict objectForKey:@"CFBundleVersion"];
                                          NSString *appName =[infoDict objectForKey:@"CFBundleDisplayName"];
                                          
                                          NSString *skipVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"SkipVersion"];
                                          BOOL isSkip;
                                          
                                          if ([skipVersion isEqualToString:dataDic[@"newVersion"]]) {
                                              isSkip = YES;
                                          }else{
                                              isSkip = NO;
                                          }
                                          
                                          if ([dataDic[@"newVersion"] floatValue] > version.floatValue) {
                                              if ([dataDic[@"mustUpdate"] isEqualToString:@"true"]) {
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName
                                                                                                  message:@"全新的SkinLab上线啦！请到AppStore更新吧。由于更新了数据结构，您现在的版本将无法继续使用，给您带来的不便敬请谅解。"
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:nil
                                                                                        otherButtonTitles:@"更新",nil];
                                                  alert.tag = 1;
                                                  [alert show];
                                                  
                                              }else{
                                                  if (!isSkip) {
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName
                                                                                                      message:@"有新版本上架了哦！赶快去AppStore更新吧！"
                                                                                                     delegate:self
                                                                                            cancelButtonTitle:@"退出时更新"
                                                                                            otherButtonTitles:@"更新", @"跳过此版本",nil];
                                                      alert.tag = 2;
                                                      [alert show];
                                                  }
                                              }
                                          }
                                          
                                          _newVersion = [dataDic[@"newVersion"] copy];
                                          DLog(@"最新版本 = %@ 当前版本 = %@ 跳过版本 = %@", dataDic[@"newVersion"], version,skipVersion);
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          DLog(@"%@",error);
                                      }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", _appID];
    
    if (alertView.tag == 2) {
        
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }else if (buttonIndex == 2) {
            [[NSUserDefaults standardUserDefaults] setValue:_newVersion forKey:@"SkipVersion"];
        }else if (buttonIndex == 0) {
            self.isNeedUpDateWhenQuite = YES;
        }
        
    }else if (alertView.tag == 1){
        
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
        
    }
}


@end
