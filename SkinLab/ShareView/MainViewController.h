//
//  MainViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-1.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeeklyListViewController.h"
#import "FavoritesViewController.h"
#import "ResultViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "RecommendDetailViewController.h"
#import "QuestionnaireViewController.h"
#import "ZBarReaderViewController.h"
#import "QRSearchViewController.h"

#import "SearchView.h"
#import "TextLabelView.h"
#import "RecommendView.h"
#import "SkinLab.h"

#import "ArrayDataSource.h"
#import "ArrayDelegate.h"

@interface MainViewController : UIViewController <UITextFieldDelegate, TextLabelViewDelagate, SearchViewDelegate, QuestionnaireViewControllerDelegate, ZBarReaderDelegate, RecommendViewDelegate>{
    BOOL _searching;
    BOOL _isQuickSearch;
    int  _page;
}

@property (strong, nonatomic) NSMutableArray *productListArray;
@property (strong, nonatomic) NSMutableArray *searchTypeArray;
@property (strong, nonatomic) NSArray        *searchClassArray;
@property (strong, nonatomic) NSArray        *braedsListArray;
@property (strong, nonatomic) NSArray        *weeklyDataArray;

@property (strong, nonatomic) SearchView   *searchView;
@property (strong, nonatomic) UIView       *typeView;
@property (strong, nonatomic) UIView       *subTypeView;
@property (strong, nonatomic) UIView       *quickSearchView;
@property (strong, nonatomic) UIView       *contentView;
@property (strong, nonatomic) UITableView  *searchTypeTableView;
@property (strong, nonatomic) UIImageView  *weeklyBadge;
@property (strong, nonatomic) UIScrollView *productView;

@property (strong, nonatomic) UIView *touchViewTop;
@property (strong, nonatomic) UIView *touchViewBottom;

@property (copy  , nonatomic) NSString     *keyWord;

@property (strong, nonatomic) ArrayDataSource *brandTableDataSource;
@property (strong, nonatomic) ArrayDelegate   *brandTableDelegate;
@property (strong, nonatomic) QRSearchViewController *qrSearchViewController;

@end
