//
//  WeeklyImageView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-10.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    WeeklyImageTypeJump,
    WeeklyImageTypeSearch,
    WeeklyImageTypePopUp,
    WeeklyImageTypeHiddenPop,
    WeeklyImageTypeExchange,
    WeeklyImageTypeZoom,
    WeeklyImageTypeNomal
}WeeklyImageType;

@class WeeklyImageView;

@protocol WeeklyImageViewDelegate <NSObject>

- (void)weeklyImageViewDidTaped:(WeeklyImageView *)weeklyImageView withType:(WeeklyImageType)weeklyImageType;

@end

@interface WeeklyImageView : UIImageView{
    CGRect _rect;
    CGRect _newRect;
    BOOL   _clicked;
    WeeklyImageType _type;
}

@property (weak, nonatomic) id <WeeklyImageViewDelegate> delegate;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *viewName;

@property (copy, nonatomic) NSString *withKey;
@property (copy, nonatomic) NSString *withOutKey;
@property (copy, nonatomic) NSString *productType;

@property (assign, nonatomic) CGRect zoomRect;

- (void)setTapGestureType:(WeeklyImageType)type;

@end
