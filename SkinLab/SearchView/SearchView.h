//
//  SearchView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-4.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

typedef enum{
    SearchViewModeMainView,
    SearchViewModeSearchView
}SearchViewMode;

@protocol SearchViewDelegate <NSObject>

@optional
- (void)searchFieldDidTouched;
- (void)cancelButtonDidTouched;
- (void)backButtonDidTouched;
- (void)searchButtonDidTouched:(NSString *)keyWord;
- (void)qrButtonDidTouched;
- (void)searchTextDidChanged:(NSString *)text;

- (void)brandsButtonDidClicked:(UIButton *)btn;
- (void)typesButtonDidClicked:(UIButton *)btn;
- (void)priceButtonDidClicked:(UIButton *)btn;

@end

@interface SearchView : UIView <UITextFieldDelegate>{
    SearchViewMode _searchViewMode;
}

@property (weak, nonatomic) id <SearchViewDelegate> delegate;
@property (strong, nonatomic) UITextField *searchField;
@property (strong, nonatomic) UIView   *backGroundView;
@property (strong, nonatomic) UIView   *fieldBack;

@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) UIButton *brandsButton;
@property (strong, nonatomic) UIButton *typesButton;
@property (strong, nonatomic) UIButton *priceButton;

@property (copy  , nonatomic) NSString *tempKeyWord;

- (id)initWithFrame:(CGRect)frame withMode:(SearchViewMode)searchViewMode;
- (IBAction)cancelButtonClicked:(id)sender;
- (void)cleanSearchCondition;

@end
