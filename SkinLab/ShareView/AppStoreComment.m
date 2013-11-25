//
//  AppStoreComment.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-23.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AppStoreComment.h"

@implementation AppStoreComment


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)startAppStoreComment:(NSString *)appID withDelay:(int)days{
    _delayDays = days;
    _appID     = appID;
    
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDict[@"CFBundleVersion"];
    
    self.firstLaunchDateWithVersion = [NSString stringWithFormat:@"FirstLaunchDate%@", version];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.firstLaunchDateWithVersion]) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Commented"]){
            [self performSelector:@selector(appStoreHandle) withObject:nil afterDelay:30];
        }
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Commented"];
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:self.firstLaunchDateWithVersion];
    }
}


- (void)appStoreHandle{
    NSDate *firstLaunchDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.firstLaunchDateWithVersion];
    NSTimeInterval time = [firstLaunchDate timeIntervalSinceNow];
    NSLog(@"time %lf", -time);
    
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *appName =infoDict[@"CFBundleDisplayName"];
    
    if ((-time) > _delayDays * 24 * 3600) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName
                                                        message:[NSString stringWithFormat:@"喜欢%@？那就给我们一个五星吧！", appName]
                                                       delegate:self
                                              cancelButtonTitle:@"再用用看"
                                              otherButtonTitles:@"去AppStore打分", @"不要再提醒我",nil];
        alert.tag = 1;
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Commented"];
            
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", _appID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        if (buttonIndex == 2) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Commented"];
        }
    }
    if (alertView.tag == 2){
        if (buttonIndex == 1) {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", _appID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

@end
