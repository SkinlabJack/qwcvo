//
//  UserCenterViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-4.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "UserInfoView.h"
#import "SettingViewCell.h"

@interface UserCenterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView  *tableView;
@property (strong, nonatomic) UserInfoView *userInfoView;

@end
