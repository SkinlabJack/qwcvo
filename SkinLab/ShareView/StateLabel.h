//
//  StateLabel.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-15.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

typedef enum{
    StateLabelModeLoading,
    StateLabelModeNothing,
    StateLabelModeHide,
    StateLabelModeNetworkingError
}StateLabelMode;

typedef void (^tapGestureBlock)(UILabel *label);

@interface StateLabel : UILabel

@property (assign, nonatomic) BOOL touchEnable;

- (void)addTapGesture:(tapGestureBlock)tapBlock;
- (void)setupStateLabel:(StateLabelMode)stateLabelMode;

@end
