//
//  AnswerView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-11.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AnswerView.h"

@implementation AnswerView

- (void)dealloc
{
    DLog(@"AnswerView dealloc");
    self.delegate     = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _answer = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 240, 40)];
        _answer.font      = [UIFont systemFontOfSize:14];
        _answer.textColor = BlackColor;
        _answer.numberOfLines   = 2;
        _answer.backgroundColor = [UIColor clearColor];
        [self addSubview:_answer];
        
        _switchButton = [[MBSwitch alloc] initWithFrame:CGRectMake(255, 8, 50, 28)];
        [_switchButton setTintColor:RedColor];
        [_switchButton setOnTintColor:GreenColor];
        [_switchButton addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerTaped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
        self.alpha          = 0;
        self.isSelected     = NO;
        self.selectedEnable = YES;
        
    }
    return self;
}

- (IBAction)switchChanged:(UISwitch *)sender{
    
}

- (void)setAnswerDic:(NSDictionary *)dic
            isSingle:(BOOL)isSingle{
    
    if (isSingle) {
        self.selectedEnable     = YES;
        self.switchButton.alpha = 0;
    }else{
        self.selectedEnable     = NO;
        self.switchButton.alpha = 1;
    }
    
    
    self.answer.text = dic[@"AContent"];
    self.answerID    = dic[@"AID"];
    self.answerType  = dic[@"AType"];
}

- (IBAction)answerTaped:(id)sender{
    if (self.selectedEnable) {
        [self.delegate answerViewDidClicked:self];
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
