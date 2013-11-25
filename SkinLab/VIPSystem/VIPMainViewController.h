//
//  VIPMainViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-28.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "VIPDetailPopView.h"
#import "AppDelegate.h"

@interface VIPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView      *topView;

@end
