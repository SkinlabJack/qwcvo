//
//  ChooseSlider.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-7.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ChooseSlider.h"

@implementation ChooseSlider

- (void)dealloc
{
    self.delegate = nil;
    self.chooseButton = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = 0;
        _oldIndex = 0;
    }
    return self;
}

- (void)setNumberOfSlider:(int)number{
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    _number   = number;
    _index    = 0;
    _oldIndex = 0;
    
    for (int i = 0; i < number; i++) {
        UIImageView *sliderBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40 * i, 15, 44)];
        sliderBack.center = CGPointMake(50/2, sliderBack.center.y);
        [self addSubview:sliderBack];
        [sliderBack release];
        
        if (i == 0) {
            sliderBack.image = [UIImage imageNamed:@"单选背景头"];
        }else if (i == number - 1){
            sliderBack.image = [UIImage imageNamed:@"单选背景尾"];
        }else{
            sliderBack.image = [UIImage imageNamed:@"单选背景"];
        }
    }
    
    UIButton *tempChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.chooseButton = tempChooseButton;
    [tempChooseButton release];
    self.chooseButton.center = CGPointMake(50/2, 20);
    [self.chooseButton setImage:[UIImage imageNamed:@"单选"] forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(chooseButtonDraged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.chooseButton addTarget:self action:@selector(chooseButtonClicked:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseButton addTarget:self action:@selector(chooseButtonClicked:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.chooseButton];
    
}

- (void)setSliderCenter:(int)index{
    [UIView animateWithDuration:0.2 animations:^{
        self.chooseButton.center = CGPointMake(self.chooseButton.center.x, 20 + index * 40);
    }];
    self.index = index;
    self.oldIndex = index;
}

- (IBAction)chooseButtonDraged:(UIButton *)sender withEvent:event{
    CGPoint center = [[[event allTouches] anyObject] locationInView:self];
    
    if (center.y >= 20 && center.y <= 40 * _number - 20) {
        sender.center = CGPointMake(sender.center.x, center.y);
    }
    
    int a = sender.center.y/40;
    self.index = a;
    
}

- (IBAction)chooseButtonClicked:(UIButton *)sender withEvent:event{
    CGPoint center = [[[event allTouches] anyObject] locationInView:self];
    if (center.y >= 20 && center.y <= 40 * _number - 20){
        float i = (center.y - 20)/40 * 10;
        int j = (int)i % 10;
        
        if (j < _number) {
            [UIView animateWithDuration:0.1 animations:^{
                sender.center = CGPointMake(sender.center.x, 20 + (int)i/10 * 40);
                self.index = (int)i/10;
            }];
            
        }else{
            [UIView animateWithDuration:0.1 animations:^{
                sender.center = CGPointMake(sender.center.x, 20 + ((int)i/10 + 1) * 40);
                self.index = (int)i/10 + 1;
            }];
        }
    };
    if (self.index != _oldIndex) {
        [self.delegate chooseSliderVolueDidChanged:self.index oldIndex:_oldIndex];
        _oldIndex = self.index;
    }
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
