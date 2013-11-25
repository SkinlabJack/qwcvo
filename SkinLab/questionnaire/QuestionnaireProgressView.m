//
//  QuestionnaireProgressView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-29.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "QuestionnaireProgressView.h"

@implementation QuestionnaireProgressView

- (void)dealloc
{
    DLog(@"QuestionnaireProgressView dealloc");
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *tempProgress = [[UIImageView alloc] initWithFrame:CGRectMake(15, 26, 0, 4)];
        self.progress = tempProgress;
        self.progress.backgroundColor     = GreenColor;
        self.progress.layer.masksToBounds = YES;
        self.progress.layer.cornerRadius  = 1.25;
        [self addSubview:self.progress];
        
        UIImageView *tempProgressNumberBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 26)];
        self.progressNumberBack = tempProgressNumberBack;
        self.progressNumberBack.image = [UIImage imageNamed:@"测试进度数字"];
        [self addSubview:self.progressNumberBack];
        
        UILabel *tempProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        self.progressLabel = tempProgressLabel;
        self.progressLabel.textAlignment   = UITextAlignmentCenter;
        self.progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel.font      = [UIFont systemFontOfSize:15];
        self.progressLabel.textColor = [UIColor whiteColor];
        self.progressLabel.text      = @"0%";
        [self.progressNumberBack addSubview:self.progressLabel];
    }
    return self;
}

- (void)setProgressData:(int)progress{
    
    self.progressLabel.text = [NSString stringWithFormat:@"%d%@", progress, @"%"];
    [UIView animateWithDuration:0.3 animations:^{
        self.progress.frame = CGRectMake(15, 26, 290 / 100.0 * progress, 4);
        self.progressNumberBack.frame = CGRectMake(15 + 290 / 100.0 * progress - 25, 0, 50, 26);
    }];
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
