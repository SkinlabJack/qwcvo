//
//  ParameterView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-6.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ParameterView.h"

@implementation ParameterView

- (void)dealloc
{
    DLog(@"ParameterView dealloc");
    
    self.delegate  = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isSelected  = NO;
        _clickEnable = YES;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 90, 25)];
        _nameLabel.backgroundColor = GreenColor;
        _nameLabel.textAlignment   = UITextAlignmentLeft;
        _nameLabel.textColor       = [UIColor whiteColor];
        _nameLabel.font            = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(105, 2.5, 170, 25)];
        back.backgroundColor = [UIColor whiteColor];
        [self addSubview:back];
        
        _percentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
        _percentImage.backgroundColor = GreenColor;
        [back addSubview:_percentImage];
        
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(170 - 45, 0, 40, 25)];
        _percentLabel.text = @"0%";
        _percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.textAlignment   = UITextAlignmentRight;
        _percentLabel.textColor       = TextGrayColor;
        _percentLabel.font            = [UIFont systemFontOfSize:14];
        [back addSubview:_percentLabel];
        
        _indexButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 30, 30)];
        [_indexButton setImage:[UIImage imageNamed:@"指数按钮"] forState:UIControlStateNormal];
        [_indexButton setTitleColor:GreenColor forState:UIControlStateNormal];
        [_indexButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_indexButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
        tap.numberOfTapsRequired    = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (IBAction)buttonClicked:(UIButton *)sender{
    
    if (self.clickEnable) {
        [self.delegate parameterViewDidClicked:self];
        
        
    }
    
}

- (void)setPercent:(int)percent animated:(BOOL)animated{
    NSString *p = @"%";
    
    self.percentLabel.text = [NSString stringWithFormat:@"%d%@", percent, p];
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.percentImage.frame = CGRectMake(0, 0, percent * 170/100, 25);
        }];
    }else{
        self.percentImage.frame = CGRectMake(0, 0, percent * 170/100, 25);
    }
    
}

- (void)setClickEnableNo{
    self.clickEnable = NO;
    [self.indexButton setImage:[UIImage imageNamed:@"指数按钮灰度"] forState:UIControlStateNormal];
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
