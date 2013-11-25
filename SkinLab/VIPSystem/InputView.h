//
//  InputView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "SkinLab.h"

@class InputView;

@protocol InputViewDelegate <NSObject>

- (void)inputViewHeightDidChanged:(float)height;
- (void)inputViewSendMessage:(NSString *)message;
- (void)inputViewDidTouched:(InputView *)inputView;

@end

@interface InputView : UIView <HPGrowingTextViewDelegate>

@property (weak, nonatomic) id <InputViewDelegate> delegate;
@property (strong, nonatomic) UIImageView       *textBack;
@property (strong, nonatomic) HPGrowingTextView *growingTextView;

@end
