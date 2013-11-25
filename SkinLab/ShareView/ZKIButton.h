//
//  ZKIButton.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-29.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapBlock)(NSString *keyID);

@interface ZKIButton : UIView <UIGestureRecognizerDelegate>{
    TapBlock _zkiTapbBlock;
    BOOL     _clickEnable;
}

@property (strong, nonatomic) UIView      *contentView;
@property (strong, nonatomic) UIImageView *clickedView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *badgeView;
@property (strong, nonatomic) UIColor     *backgroundColorHighlighted;
@property (strong, nonatomic) UIColor     *backgroundColorNormal;
@property (strong, nonatomic) NSString    *keyID;

@property (strong, nonatomic) UILabel     *titelLabel;
@property (strong, nonatomic) UILabel     *detailLabel;

- (void)addTapBlock:(TapBlock)block;
- (void)showBadgeView:(BOOL)show;
- (void)createLabels:(NSString *)text;
- (void)createTitleLabel:(NSString *)text;

@end
