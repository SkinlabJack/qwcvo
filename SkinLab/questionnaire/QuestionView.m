//
//  QuestionView.m
//  tryseason
//
//  Created by Dai Qinfu on 13-1-8.
//  Copyright (c) 2013年 Dai Qinfu. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

- (void)dealloc
{
    DLog(@"QuestionView dealloc");
    self.delegate = nil;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, 50)];
        _questionLabel.backgroundColor = [UIColor clearColor];
        _questionLabel.textColor = BlackColor;
        _questionLabel.numberOfLines = 2;
        [self addSubview:_questionLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(5, 50, 310, 1)];
        line.image = [UIImage imageNamed:@"分割线"];
        [self addSubview:line];
        
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 40)];
        _selectedView.backgroundColor = GreenColor;
        _selectedView.alpha           = 0;
        [self addSubview:_selectedView];
        
        for (int i = 0; i < 7; i++) {
            AnswerView *answerView = [[AnswerView alloc] initWithFrame:CGRectMake(0, 55 + 40 * i, kScreenWidth, 40)];
            answerView.delegate    = self;
            answerView.tag         = i + 100;
            [self addSubview:answerView];
        }
        
    }
    return self;
}

- (void)setAnswerSelected:(int)index{
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedView.frame = CGRectMake(0, 55 + 40 * index, kScreenWidth, 40);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setQuestionViewData:(NSDictionary *)questionDic questionID:(int)questionID{
    
    self.nowQuestionID = questionID;
    self.questionDic   = questionDic;
    self.questionLabel.text = questionDic[@"QContent"];
    NSArray  *answerArray   = questionDic[@"Answers"];
    NSString *type          = questionDic[@"Type"];
    
    for (int i = 0; i < 7; i++) {
       
        AnswerView *view = (AnswerView *)[self viewWithTag:i + 100];
       
        if (i < answerArray.count) {
            view.alpha = 1;
            
            if ([type isEqualToString:@"1"]) {
                
                [view setAnswerDic:answerArray[i]
                          isSingle:NO];
               
                self.selectedView.alpha = 0;
                //        DLog(@"多选");
            }else{
                
                [view setAnswerDic:answerArray[i]
                          isSingle:YES];
                
                self.selectedView.alpha = 1;
                //        DLog(@"单选");
            }
                        
        }else{
            
            view.alpha = 0;
            view.answerID = nil;
            view.answerType = nil;
            view.answer.text = nil;
        }
        
        if (i == 0) {
            self.answerID   = view.answerID;
            self.answerType = view.answerType;
        }
        
    }
    
    [self setAnswerSelected:0];
    
}

- (void)setAnswerViewSelected:(NSString *)answerID{
    NSArray *answerArray = _questionDic[@"Answers"];
    
    for (int i = 0; i < answerArray.count; i++) {
        AnswerView *view = (AnswerView *)[self viewWithTag:i + 100];
        
        if ([answerArray[i][@"AID"] isEqualToString:answerID]) {
            
            [self setAnswerSelected:i];
            self.answerID = view.answerID;
            DLog(@"%d", i)
            break;
        }
    }
    
}

- (void)answerClicked:(NSString *)answerID{
    
    NSArray *answerArray = _questionDic[@"Answers"];
    NSString *skinType;
    for (NSDictionary *dic in answerArray) {
        if ([dic[@"AID"] isEqualToString:answerID]) {
            skinType = dic[@"AType"];
        }
    }
    
    NSString *next     = _questionDic[@"Sequence"];
    NSString *type     = _questionDic[@"Type"];
    NSArray *nextArray = [next componentsSeparatedByString:@"@@"];
    BOOL isSingle      = [type isEqualToString:@"0"]?YES:NO;
    
    for (NSString *nextTag in nextArray) {
        NSArray *nextTagArray = [nextTag componentsSeparatedByString:@"::"];
        
        if ([nextTagArray[1] isEqualToString:@"over"]) {
            
            [self.delegate questionnaireDidEnded];
            DLog(@"测试结束");
            break;
            
        }else if ([nextTagArray[0] isEqualToString:@"All"]) {
            
            [self.delegate answerButtonDidClicked:[nextTagArray[1] integerValue]
                                        buttonTag:[answerID integerValue]
                                         isSingle:isSingle
                                         skinType:skinType
                                    nowQuestionID:self.nowQuestionID];
            break;
            
        }else if([nextTagArray[0] isEqualToString:answerID]){
            
            [self.delegate answerButtonDidClicked:[nextTagArray[1] integerValue]
                                        buttonTag:[answerID integerValue]
                                         isSingle:isSingle
                                         skinType:skinType
                                    nowQuestionID:self.nowQuestionID];
            break;
        }
    }
}

#pragma mark - ChooseSliderDelegate

- (void)chooseSliderVolueDidChanged:(int)index oldIndex:(int)oldIndex{
    AnswerView *view = (AnswerView *)[self viewWithTag:index + 100];
    self.answerID = view.answerID;
    [self setAnswerSelected:index];
}

#pragma mark - AnswerViewDelegate

- (void)answerViewDidClicked:(AnswerView *)answerView{
    self.answerID = answerView.answerID;
    [self setAnswerSelected:answerView.tag - 100];
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
