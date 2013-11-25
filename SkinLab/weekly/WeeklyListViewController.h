//
//  WeeklyListViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-22.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "WeeklyViewController.h"
#import "NewFeaturesViewController.h"
#import "StateLabel.h"
#import "WeeklyTableViewCell.h"

@interface WeeklyListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    float _topViewHeight;
    BOOL  _isTableViewShow;
}


@property (strong, nonatomic) ZKIButton   *topView;
@property (strong, nonatomic) UILabel     *topLabel;
@property (strong, nonatomic) UIView      *typeView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) StateLabel     *stateLabel;
@property (strong, nonatomic) NSArray        *weeklyDataArray;
@property (strong, nonatomic) NSArray        *classArray;
@property (strong, nonatomic) NSMutableArray *classedWeeklyArray;

@end
