//
//  NoteView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 528)];
        backGround.image = [UIImage imageNamed:@"问卷背景"];
        [self addSubview:backGround];
        [backGround release];
        
        UIImageView *bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 20 - 50, kScreenWidth, 50)];
        bottom.image = [UIImage imageNamed:@"问卷底边"];
        [self addSubview:bottom];
        [bottom release];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 55, self.frame.size.width - 16, 40)];
        [_txtLabel setFont:[UIFont systemFontOfSize:16]];
        [_txtLabel setBackgroundColor:[UIColor clearColor]];
        [_txtLabel setTextColor:[UIColor grayColor]];
        _txtLabel.numberOfLines = 10;
        [self addSubview:_txtLabel];
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 55, 40, 40)];
        [_closeButton setImage:[UIImage imageNamed:@"消息关闭"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return self;
}

- (IBAction)closeButtonClicked:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64);
    }];
}

- (void)setNoteText:(NSString *)text{
    CGSize labelsize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                         constrainedToSize:CGSizeMake(280, 500)
                             lineBreakMode:UILineBreakModeWordWrap];
    _txtLabel.frame = CGRectMake(20, 100, self.frame.size.width - 40, labelsize.height);
    _txtLabel.text = text;
    
    _closeButton.frame = CGRectMake(kScreenWidth - 50, labelsize.height + 100, 40, 40);
    
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
