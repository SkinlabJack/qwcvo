//
//  RecommendDetailViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-25.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "ParameterView.h"
#import "IngredientsDetailView.h"
#import "ParametersView.h"
#import "SimilarProductView.h"
#import "SourceViewController.h"

typedef enum{
    RecommendDetailViewModeWithNav,
    RecommendDetailViewModeWithoutNav
}RecommendDetailViewMode;


@interface RecommendDetailViewController : UIViewController <UIScrollViewDelegate, ParametersViewDelegate, SimilarProductViewDelegate>{
    float _infoViewHeight;
}

@property (strong, nonatomic) NSDictionary        *productInfoDic;
@property (strong, nonatomic) NSArray             *productArray;
@property (strong, nonatomic) NSMutableDictionary *ingredientsDic;
@property (strong, nonatomic) NSArray             *ingredientsArray;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView       *infoView;
@property (strong, nonatomic) UIView       *buttonView;

@property (strong, nonatomic) UIImageView *productImage;
@property (strong, nonatomic) UILabel     *productBrand;
@property (strong, nonatomic) UILabel     *productName;
@property (strong, nonatomic) UILabel     *productPrice;

@property (strong, nonatomic) UIButton *wantButton;
@property (strong, nonatomic) UIButton *usingButton;

@property (strong, nonatomic) ParametersView        *parametersView;
@property (strong, nonatomic) IngredientsView       *ingredientsView;
@property (strong, nonatomic) SimilarProductView    *similarProductView;
@property (strong, nonatomic) IngredientsDetailView *ingredientsDetailView;

@property (assign, nonatomic) RecommendDetailViewMode recommendDetailViewMode;
@property (assign, nonatomic) float productImageWidth;

- (void)setProductInfo:(NSDictionary *)dic;
- (void)setProductInfoByID:(NSString *)productID;

@end
