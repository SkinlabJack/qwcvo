//
//  WeeklyImageView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-10.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "WeeklyImageView.h"

@implementation WeeklyImageView

- (void)dealloc
{
    DLog(@"WeeklyImageView dealloc")
    self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rect    = frame;
        _clicked = NO;
    }
    return self;
}

- (IBAction)imageClickedWithBlock:(id)sender{
}

- (void)setTapGestureType:(WeeklyImageType)type{
    _type = type;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:recognizer];
    
    self.userInteractionEnabled = YES;

}


- (IBAction)imageClicked:(id)sender {
    
    if (_type == WeeklyImageTypeZoom) {
        if (_clicked) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = _rect;
            }];
            _clicked = NO;
        }else{
            [self.delegate weeklyImageViewDidTaped:self withType:_type];
            _clicked = YES;
        }
        
    }else {
        [self.delegate weeklyImageViewDidTaped:self withType:_type];
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
