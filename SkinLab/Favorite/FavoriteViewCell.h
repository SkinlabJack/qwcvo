//
//  FavoriteViewCell.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-19.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@class FavoriteViewCell;

@protocol FavoriteViewCellDelegate <NSObject>

- (void)buyButtonDidClicked:(FavoriteViewCell *)cell;
- (void)shareButtonDidClicked:(FavoriteViewCell *)cell;
- (void)deleteButtonDidClicked:(FavoriteViewCell *)cell;

@end

@interface FavoriteViewCell : UITableViewCell{
    
}

@property (weak, nonatomic) id <FavoriteViewCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *productImage;
@property (strong, nonatomic) UILabel     *productName;
@property (strong, nonatomic) UILabel     *productBrand;
@property (strong, nonatomic) UILabel     *productInfo;

@property (copy,   nonatomic) NSString  *taobaoURL;
@property (assign, nonatomic) NSInteger *index;

@property (strong, nonatomic) UIImageView *menuBack;
@property (strong, nonatomic) UIButton    *menuButton;
@property (strong, nonatomic) UIButton    *buyButton;
@property (strong, nonatomic) UIButton    *deleteButton;

- (void)menuButtonClicked:(UIButton *)sender animated:(BOOL)animated;

@end
