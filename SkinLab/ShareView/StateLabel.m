//
//  StateLabel.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-15.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "StateLabel.h"

@implementation StateLabel

- (void)dealloc
{
    DLog(@"StateLabel dealloc")
}

static tapGestureBlock _tapBlock;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.enabled = NO;
        
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = UITextAlignmentCenter;
        self.textColor = TextGrayColor;
        self.font = [UIFont boldSystemFontOfSize:14];
        self.numberOfLines = 2;
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelViewTap)];
        recognizer.numberOfTapsRequired    = 1;
        recognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)addTapGesture:(tapGestureBlock)tapBlock
{
    self.enabled = YES;
    _tapBlock = [tapBlock copy];
}

- (void)labelViewTap
{
    if (self.enabled) {
        _tapBlock(self);
        DLog(@"StateLabelTouched");
    }
}

- (void)setupStateLabel:(StateLabelMode)stateLabelMode{
    
    switch (stateLabelMode) {
        case StateLabelModeHide:
            self.text    = @"";
            self.alpha   = 0;
            self.enabled = NO;
            break;
            
        case StateLabelModeLoading:
            self.text    = @"正在为您加载数据，请稍候...";
            self.alpha   = 1;
            self.enabled = NO;
            break;
            
        case StateLabelModeNothing:
            self.text  = @"抱歉，没有找到符合条件的产品";
            self.alpha = 1;
            self.enabled = NO;
            break;
            
        case StateLabelModeNetworkingError:
            self.text    = @"网络连接超时，点击重试...";
            self.alpha   = 1;
            self.enabled = YES;
            break;
            
        default:
            break;
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
