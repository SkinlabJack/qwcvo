//
//  QuestionView.h
//  tryseason
//
//  Created by Dai Qinfu on 13-1-8.
//  Copyright (c) 2013年 Dai Qinfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "AnswerView.h"
#import "ChooseSlider.h"


@protocol QuestionViewDelegate <NSObject>

- (void)answerButtonDidClicked:(NSInteger)nextTag
                     buttonTag:(NSInteger)buttonTag
                      isSingle:(BOOL)isSingle
                      skinType:(NSString *)skinType
                 nowQuestionID:(int)nowQuestionID;

- (void)questionnaireDidEnded;

@end

@interface QuestionView : UIView <ChooseSliderDelegate, AnswerViewDelegate>{
    NSInteger _nextTag;
}

@property (weak, nonatomic) id <QuestionViewDelegate> delegate;

@property (strong, nonatomic) NSDictionary *questionDic;
@property (strong, nonatomic) UILabel      *questionLabel;
@property (strong, nonatomic) UIView       *selectedView;

@property (copy, nonatomic) NSString *answerID;
@property (copy, nonatomic) NSString *answerType;

@property (assign, nonatomic) int nowQuestionID;

- (void)setQuestionViewData:(NSDictionary *)questionDic
                 questionID:(int)questionID;

- (void)setAnswerViewSelected:(NSString *)answerID;
- (void)answerClicked:(NSString *)answerID;

@end
