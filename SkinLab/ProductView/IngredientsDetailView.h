//
//  IngredientsDetailView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
//#import "RCLabel.h"

@interface IngredientsDetailView : UIView

@property (strong, nonatomic) UIImageView  *backImage;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *textLabel;

@property (copy,   nonatomic) NSString *ingreDes;

- (void)setIngredientView:(NSDictionary *)dic;

@end
