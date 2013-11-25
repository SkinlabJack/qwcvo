//
//  SearchView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-4.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SearchView.h"

#define SearchFieldWidth      290
#define SearchFieldWidthShort 235
#define SearchFieldWidthLong  255

#define SearchGap    20
#define SearchHeight 70


@implementation SearchView

- (void)dealloc
{
    DLog(@"SearchView dealloc")
    
    self.delegate       = nil;
    
    
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withMode:(SearchViewMode)searchViewMode
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GrayColor;
        
        _searchViewMode = searchViewMode;
        
        if ([DataCenter shareData].deviceType == DeviceTypeiPhone4) {
            _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            _backGroundView.backgroundColor = GreenColor;
            [self addSubview:_backGroundView];
        }
        
        if (searchViewMode == SearchViewModeMainView) {
            _fieldBack    = [[UIView alloc] initWithFrame:CGRectMake(15, SearchGap, SearchFieldWidth, 30)];
            _searchField  = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, SearchFieldWidth - 10, SearchHeight)];
            _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(SearchFieldWidth - 15, 25, 20, 20)];
            _backGroundView.alpha = 0;
            
        }else if (searchViewMode == SearchViewModeSearchView){
            _fieldBack = [[UIView alloc] initWithFrame:CGRectMake(50, SearchGap, SearchFieldWidthLong, 30)];
            _searchField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SearchFieldWidthLong - 10, SearchHeight)];
            _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(50 + SearchFieldWidthLong - 30, 25, 20, 20)];
            _backGroundView.alpha = 1;
            
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SearchGap, 50, 30)];
            [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:leftButton];
            
            [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        }
        
        _fieldBack.backgroundColor     = [UIColor whiteColor];
        _fieldBack.layer.masksToBounds = YES;
        _fieldBack.layer.cornerRadius  = 15;
        _fieldBack.layer.borderWidth   = 1;
        _fieldBack.layer.borderColor   = GreenColor.CGColor;
        [self addSubview:_fieldBack];
        
        _searchField.delegate = self;
        _searchField.contentVerticalAlignment      = UIControlContentVerticalAlignmentCenter;
        _searchField.enablesReturnKeyAutomatically = YES;
        _searchField.returnKeyType   = UIReturnKeySearch;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.textColor       = BlackColor;
        _searchField.font            = [UIFont systemFontOfSize:15];
        _searchField.placeholder     = @"搜索品牌/成分/功效/产品";
        [self addSubview:_searchField];
        
        [_searchField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [_searchButton setImage:[UIImage imageNamed:@"搜索按钮"] forState:UIControlStateNormal];
        [self addSubview:_searchButton];
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 55, 0, 55, 70)];
        _cancelButton.alpha = 0;
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        if ([DataCenter shareData].deviceType == DeviceTypeiPhone4) {
            [_cancelButton setImage:[UIImage imageNamed:@"取消按钮"] forState:UIControlStateNormal];
        }else{
            [_cancelButton setImage:[UIImage imageNamed:@"取消按钮反色"] forState:UIControlStateNormal];
        }
        
        UIImageView *segmentBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, SearchHeight, kScreenWidth, 40)];
        segmentBack.image = [UIImage imageNamed:@"segment"];
        segmentBack.userInteractionEnabled = YES;
        segmentBack.alpha = 0.7;
        [self addSubview:segmentBack];
        
        UIButton *tempBrandsButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
        self.brandsButton = tempBrandsButton;
        self.brandsButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.brandsButton setTitle:@"所有品牌" forState:UIControlStateNormal];
        [self.brandsButton addTarget:self action:@selector(brandsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [segmentBack addSubview:self.brandsButton];
        
        UIButton *tempTypesButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 0, 100, 40)];
        self.typesButton = tempTypesButton;
        self.typesButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.typesButton setTitle:@"所有类型" forState:UIControlStateNormal];
        [self.typesButton addTarget:self action:@selector(typesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [segmentBack addSubview:self.typesButton];
        
        UIButton *tempPriceButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 0, 100, 40)];
        self.priceButton = tempPriceButton;
        self.priceButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.priceButton setTitle:@"所有价格" forState:UIControlStateNormal];
        [self.priceButton addTarget:self action:@selector(priceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [segmentBack addSubview:self.priceButton];
        
    }
    return self;
}

- (IBAction)searchButtonClicked:(id)sender{
    
}

- (IBAction)cancelButtonClicked:(id)sender{
    [self.delegate cancelButtonDidTouched];
    [self beginSearch:NO];
    [self.searchField resignFirstResponder];
}

- (IBAction)backButtonClicked:(id)sender{
    [self.delegate backButtonDidTouched];
}

- (IBAction)qrButtonClicked:(id)sender{
    [self.delegate qrButtonDidTouched];
}

- (IBAction)brandsButtonClicked:(UIButton *)sender{
    [self.delegate brandsButtonDidClicked:sender];
}

- (IBAction)typesButtonClicked:(UIButton *)sender{
    [self.delegate typesButtonDidClicked:sender];
}

- (IBAction)priceButtonClicked:(UIButton *)sender{
    [self.delegate priceButtonDidClicked:sender];
}


- (void)beginSearch:(BOOL)begin{
    if (begin) {
        [UIView animateWithDuration:0.25 animations:^{
            self.backGroundView.alpha = 1;
            self.searchButton.alpha   = 0;
            self.cancelButton.alpha   = 1;
            
            if (_searchViewMode == SearchViewModeMainView) {
                self.fieldBack.frame   = CGRectMake(15, SearchGap, SearchFieldWidthShort, 30);
                self.searchField.frame = CGRectMake(25, 0, SearchFieldWidthShort - 10, SearchHeight);
            }else{
                self.fieldBack.frame   = CGRectMake(50, SearchGap, SearchFieldWidthLong - 55, 30);
                self.searchField.frame = CGRectMake(60, 0, SearchFieldWidthLong - 65, SearchHeight);
            }

        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            
            self.searchButton.alpha = 1;
            self.cancelButton.alpha = 0;
            
            if (_searchViewMode == SearchViewModeMainView) {
                self.backGroundView.alpha = 0;
                
                self.fieldBack.frame   = CGRectMake(15, SearchGap, SearchFieldWidth, 30);
                self.searchField.frame = CGRectMake(25, 0, SearchFieldWidth - 10, SearchHeight);
                
            }else{
                self.backGroundView.alpha = 1;
                
                self.fieldBack.frame   = CGRectMake(50, SearchGap, SearchFieldWidthLong, 30);
                self.searchField.frame = CGRectMake(60, 0, SearchFieldWidthLong - 10, SearchHeight);
            }
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [MobClick event:@"searchview" label:textField.text];
    
    [self.delegate searchButtonDidTouched:textField.text];
    [self.searchField resignFirstResponder];
    [self beginSearch:NO];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate searchFieldDidTouched];
    [self beginSearch:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void)cleanSearchCondition {
    [self.brandsButton setTitle:@"全部品牌" forState:UIControlStateNormal];
    [self.typesButton  setTitle:@"全部类型" forState:UIControlStateNormal];
}

- (void)textFieldEditChanged:(UITextField *)textField {
    if (![textField.text isEqualToString:self.tempKeyWord]) {
        NSLog(@"%@", textField.text);
        [self.delegate searchTextDidChanged:textField.text];
    }
    self.tempKeyWord = textField.text;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
