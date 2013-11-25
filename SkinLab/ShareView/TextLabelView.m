//
//  TextLabelView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-10.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "TextLabelView.h"

@implementation TextLabelView

- (void)dealloc
{
    self.delegate  = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_backImage];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_textLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouched)];
        tap.numberOfTapsRequired    = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)viewTouched{
    [self.delegate textLabelViewDidTouched:self];
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
