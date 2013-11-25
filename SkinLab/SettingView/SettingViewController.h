//
//  SettingViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-8.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "SkinLab.h"
#import "SettingViewCell.h"
#import "AboutViewController.h"
#import "SourceViewController.h"
#import "FavoritesViewController.h"

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SettingViewCellDelegate, MFMailComposeViewControllerDelegate>{
    
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UILabel     *userName;

@end
