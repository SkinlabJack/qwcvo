//
//  AnswerView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-11.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SkinLab.h"
#import "MBSwitch.h"

@class AnswerView;

@protocol AnswerViewDelegate <NSObject>

- (void)answerViewDidClicked:(AnswerView *)answerView;

@end

@interface AnswerView : UIView{
   
}

@property (weak, nonatomic) id <AnswerViewDelegate> delegate;
@property (strong, nonatomic) UILabel  *answer;
@property (strong, nonatomic) MBSwitch *switchButton;
@property (copy  , nonatomic) NSString *answerID;
@property (copy  , nonatomic) NSString *answerType;

@property (assign, nonatomic) BOOL selectedEnable;
@property (assign, nonatomic) BOOL isSelected;

- (void)setAnswerDic:(NSDictionary *)dic
            isSingle:(BOOL)isSingle;

@end
