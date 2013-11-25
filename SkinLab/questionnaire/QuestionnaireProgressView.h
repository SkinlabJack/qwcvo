//
//  QuestionnaireProgressView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-29.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@interface QuestionnaireProgressView : UIView

@property (strong, nonatomic) UIImageView *progressNumberBack;
@property (strong, nonatomic) UIImageView *progress;
@property (strong, nonatomic) UILabel *progressLabel;

- (void)setProgressData:(int)progress;

@end
