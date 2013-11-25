//
//  QuestionnaireViewController.h
//  tryseason
//
//  Created by Dai Qinfu on 13-1-8.
//  Copyright (c) 2013年 Dai Qinfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "QuestionView.h"
#import "QuestionnaireProgressView.h"
#import "StateLabel.h"


@protocol QuestionnaireViewControllerDelegate <NSObject>

@optional

- (void)questionnaireDidFinished:(NSDictionary *)dic;

@end

@interface QuestionnaireViewController : UIViewController <QuestionViewDelegate>{
    int _doneNumber;
}

@property (weak, nonatomic) id <QuestionnaireViewControllerDelegate> delegate;

@property (strong, nonatomic) QuestionnaireProgressView *questionnaireProgressView;
@property (strong, nonatomic) QuestionView *questionView;
@property (strong, nonatomic) UIButton     *nextButton;
@property (strong, nonatomic) UIButton     *PreviouseButton;
@property (strong, nonatomic) StateLabel   *stateLabel;
@property (strong, nonatomic) UIButton     *noteView;

@property (strong, nonatomic) NSArray        *questionArray;
@property (strong, nonatomic) NSMutableArray *previousArray;
@property (strong, nonatomic) NSMutableArray *userAnswer;
@property (strong, nonatomic) NSMutableDictionary *answerDic;

@property (copy,   nonatomic) NSString *skinType;

@end
