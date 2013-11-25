//
//  SearchViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-3.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "ActivityView.h"
#import "SearchViewCell.h"
#import "SearchView.h"
#import "StateLabel.h"
#import "RecommendDetailViewController.h"

#import "ArrayDataSource.h"
#import "ArrayDelegate.h"

typedef enum{
    SearchModeAll,
    SearchModeNommal,
    SearchModeWithIngres,
    SearchModeNoSearch
}SearchMode;

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SearchViewDelegate, ActivityViewDelegate>{
    float _contenty;
    
    BOOL _loadingMore;
    BOOL _searching;
    BOOL _brandsButtonSelected;
    BOOL _typesButtonSelected;
    BOOL _priceButtonSelected;
}

@property (strong, nonatomic) NSMutableArray *productListArray;
@property (strong, nonatomic) NSArray        *productBrandsArray;
@property (strong, nonatomic) NSArray        *productTypesArray;
@property (strong, nonatomic) NSArray        *productPriceArray;

@property (strong, nonatomic) UIView       *mainView;
@property (strong, nonatomic) UIView       *quickSearchView;
@property (strong, nonatomic) SearchView   *searchView;
@property (strong, nonatomic) UIView       *skinTypeView;
@property (strong, nonatomic) UITableView  *skintypeTableView;
@property (strong, nonatomic) UITableView  *searchTableView;
@property (strong, nonatomic) ActivityView *activityView;
@property (strong, nonatomic) StateLabel   *stateLabel;

@property (strong, nonatomic) UIView      *filterView;
@property (strong, nonatomic) UITableView *filterTableView;
@property (strong, nonatomic) UIImageView *filterImageView;
@property (strong, nonatomic) ArrayDataSource *priceTableDataSource;
@property (strong, nonatomic) ArrayDelegate   *priceTableDelegate;
@property (strong, nonatomic) ArrayDataSource *typesTableDataSource;
@property (strong, nonatomic) ArrayDelegate   *typesTableDelegate;
@property (strong, nonatomic) ArrayDataSource *brandTableDataSource;
@property (strong, nonatomic) ArrayDelegate   *brandTableDelegate;
@property (strong, nonatomic) ArrayDataSource *skintypeTableDataSource;
@property (strong, nonatomic) ArrayDelegate   *skintypeTableDelegate;

@property (assign, nonatomic) SearchMode searchMode;
@property (copy,   nonatomic) NSString *keyWord;
@property (copy,   nonatomic) NSString *withKeyWord;
@property (copy,   nonatomic) NSString *withOutKeyWord;
@property (copy,   nonatomic) NSString *brands;
@property (copy,   nonatomic) NSString *type;
@property (copy,   nonatomic) NSString *priceLow;
@property (copy,   nonatomic) NSString *priceHigh;
@property (copy,   nonatomic) NSString *effect;

@end
