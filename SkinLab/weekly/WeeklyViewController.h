//
//  WeeklyViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-17.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "SearchViewController.h"
#import "WeeklyImageView.h"
#import "RecommendDetailViewController.h"
#import "ActivityView.h"

@interface WeeklyViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, ActivityViewDelegate, WeeklyImageViewDelegate>{
    int  _scroollTag;
    BOOL _backing;
}


@property (retain, nonatomic) NSDictionary        *weeklyDic;
@property (retain, nonatomic) NSMutableArray      *indexWeeklyArray;
@property (retain, nonatomic) NSMutableArray      *branchWeeklyArray;
@property (retain, nonatomic) NSArray             *pageStringArray;

@property (retain, nonatomic) NSMutableDictionary *changeableViewDic;
@property (retain, nonatomic) ActivityView        *activityView;
@property (retain, nonatomic) UIButton            *leftButton;

@end
