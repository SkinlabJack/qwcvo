//
//  VIPDetailPopView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-28.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "VIPDetailPopView.h"

#define ViewHeight 420

@implementation VIPDetailPopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(15, 25, frame.size.width - 30, ViewHeight)];
        tempView.center  = CGPointMake(frame.size.width/2, frame.size.height/2);
        tempView.backgroundColor = [UIColor whiteColor];
        tempView.layer.masksToBounds = YES;
        tempView.layer.cornerRadius  = 5;
        [self addSubview:tempView];
        
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tempView.frame.size.width, 44)];
        _topLabel.textAlignment   = UITextAlignmentCenter;
        _topLabel.backgroundColor = GreenColor;
        _topLabel.font            = [UIFont boldSystemFontOfSize:15];
        _topLabel.textColor       = [UIColor whiteColor];
        _topLabel.text            = @"升级成为SkinLab中级会员";
        [tempView addSubview:_topLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, tempView.frame.size.width, 50)];
        _priceLabel.textAlignment   = UITextAlignmentCenter;
        _priceLabel.backgroundColor = [UIColor whiteColor];
        _priceLabel.font            = [UIFont boldSystemFontOfSize:25];
        _priceLabel.textColor       = GreenColor;
        _priceLabel.text            = @"￥169/季度";
        [tempView addSubview:_priceLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, ViewHeight - 55, 125, 40)];
        closeButton.layer.masksToBounds = YES;
        closeButton.layer.cornerRadius  = 5;
        closeButton.backgroundColor   = GreenColor;
        closeButton.titleLabel.font   = [UIFont systemFontOfSize:15];
        [closeButton setTitle:@"考虑一下" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:closeButton];
        
        UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(150, ViewHeight - 55, 125, 40)];
        updateButton.layer.masksToBounds = YES;
        updateButton.layer.cornerRadius  = 5;
        updateButton.backgroundColor     = GreenColor;
        updateButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        [updateButton setTitle:@"升级" forState:UIControlStateNormal];
        [updateButton addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:updateButton];

    }
    return self;
}

- (void)setupPopViewData:(NSDictionary *)dic {
    self.topLabel.text = dic[@"mumbler"];
    self.priceLabel.text = dic[@"price"];
}

- (IBAction)closeButtonClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (IBAction)updateButtonClicked:(UIButton *)sender {
    
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
