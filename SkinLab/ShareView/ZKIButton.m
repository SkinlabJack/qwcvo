//
//  ZKIButton.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-29.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ZKIButton.h"

#define GreenColor         [UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1]
#define TextGrayColor      [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1]


@implementation ZKIButton

- (void)dealloc
{
    DLog(@"ZKIButton dealloc")
    
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _clickEnable = NO;
        self.backgroundColorHighlighted = [UIColor colorWithRed:154/255.0 green:194/255.0 blue:192/255.0 alpha:1];
        self.backgroundColorNormal      = [UIColor whiteColor];
        
        self.backgroundColor = self.backgroundColorNormal;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 5;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        [_imageView addObserver:self forKeyPath:@"image" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
        
    }
    return self;
}

- (void)createLabels:(NSString *)text{
    _titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
    _titelLabel.textAlignment   = UITextAlignmentCenter;
    _titelLabel.backgroundColor = GreenColor;
    _titelLabel.font            = [UIFont boldSystemFontOfSize:15];
    _titelLabel.textColor       = [UIColor whiteColor];
    _titelLabel.text            = text;
    [self addSubview:_titelLabel];
}

- (void)createTitleLabel:(NSString *)text{
    _titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titelLabel.textAlignment   = UITextAlignmentCenter;
    _titelLabel.backgroundColor = [UIColor clearColor];
    _titelLabel.font            = [UIFont boldSystemFontOfSize:15];
    _titelLabel.textColor       = GreenColor;
    _titelLabel.text            = text;
    [self addSubview:_titelLabel];
}

- (void)addTapBlock:(TapBlock)block {
    _clickEnable  = YES;
    _zkiTapbBlock = [block copy];
}

- (void)showBadgeView:(BOOL)show {
    
    if (self.badgeView == nil) {
        self.badgeView = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 26, 0, 26, 26)];
        self.badgeView.textAlignment   = UITextAlignmentCenter;
        self.badgeView.backgroundColor = [UIColor clearColor];
        self.badgeView.font            = [UIFont boldSystemFontOfSize:8];
        self.badgeView.textColor       = [UIColor whiteColor];
        self.badgeView.alpha           = 0;
        self.badgeView.layer.masksToBounds = YES;
        self.badgeView.layer.cornerRadius  = 13;
        self.badgeView.text = @"NEW";
        self.badgeView.backgroundColor = [UIColor colorWithRed:228/255.0 green:179/255.0 blue:156/255.0 alpha:1];
        [self addSubview:self.badgeView];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        if (show) {
            self.badgeView.alpha = 1;
        }else{
            self.badgeView.alpha = 0;
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"begin")
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"end")
    
    if (_clickEnable) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundColor = self.backgroundColorHighlighted;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.backgroundColor = self.backgroundColorNormal;
            } completion:^(BOOL finished) {
                _zkiTapbBlock(self.keyID);
            }];
        }];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIImage *image = change[@"new"];
    self.imageView.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * image.size.height/image.size.width);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
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
