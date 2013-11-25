//
//  ParameterView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-6.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@class ParameterView;

@protocol ParameterViewDelegate <NSObject>

- (void)parameterViewDidClicked:(ParameterView *)parameterView;

@end

typedef enum{
    ParameterMod,
    ParameterM,
    ParameterModew
}ParameterMode;

@interface ParameterView : UIView{
}

@property (weak, nonatomic) id <ParameterViewDelegate> delegate;
@property (strong, nonatomic) UILabel     *nameLabel;
@property (strong, nonatomic) UILabel     *percentLabel;
@property (strong, nonatomic) UIImageView *percentImage;
@property (strong, nonatomic) UIButton    *indexButton;

@property (copy,   nonatomic) NSString *indexName;
@property (assign, nonatomic) BOOL     isSelected;
@property (assign, nonatomic) BOOL     clickEnable;

- (void)setPercent:(int)percent animated:(BOOL)animated;
- (void)setClickEnableNo;

@end
