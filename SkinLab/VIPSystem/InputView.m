//
//  InputView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (void)dealloc
{
    DLog(@"InputView dealloc")
    self.delegate = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor   = [UIColor whiteColor];
        self.layer.borderColor = GreenColor.CGColor;
        self.layer.borderWidth = 1;
        
        _textBack = [[UIImageView alloc] initWithFrame:CGRectMake(50, 8, 220, 34)];
        _textBack.backgroundColor        = [UIColor whiteColor];
        _textBack.userInteractionEnabled = YES;
        _textBack.layer.masksToBounds    = YES;
        _textBack.layer.cornerRadius     = 17;
        _textBack.layer.borderWidth      = 1;
        _textBack.layer.borderColor      = GreenColor.CGColor;
        [self addSubview:_textBack];
        
        _growingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 1, 200, 30)];
        _growingTextView.contentInset     = UIEdgeInsetsMake(0, 0, 0, 0);
        _growingTextView.minNumberOfLines = 1;
        _growingTextView.maxNumberOfLines = 2;
        _growingTextView.font             = [UIFont systemFontOfSize:15.0f];
        _growingTextView.delegate         = self;
        _growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        [_textBack addSubview:_growingTextView];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 8, 40, 34)];
        sendButton.backgroundColor = GreenColor;
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius  = 5;
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];

    }
    return self;
}

#pragma mark HPGroingTextView Delegate

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    [self.delegate inputViewDidTouched:self];
}


- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    return NO;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    
    self.textBack.frame = CGRectMake(50, 8, 220, height + 4);
    self.frame          = CGRectMake(0, self.frame.origin.y, kScreenWidth, height + 20);
    
    [self.delegate inputViewHeightDidChanged:(height + 20)];
}

- (IBAction)sendButtonClicked:(UIButton *)sender {
    [self.delegate inputViewSendMessage:self.growingTextView.text];
    self.growingTextView.text = @"";
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
