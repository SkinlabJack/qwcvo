//
//  FavoritesViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-20.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "FavoriteViewCell.h"
#import "RecommendDetailViewController.h"
#import "BCLSegmentControl.h"

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, FavoriteViewCellDelegate, BCLSegmentControlDelegate>{
    
}

@property (strong, nonatomic) NSArray     *productArray;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel     *textLabel;

@property (strong, nonatomic) BCLSegmentControl *topSement;

@end
