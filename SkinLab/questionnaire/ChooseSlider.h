//
//  ChooseSlider.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-7.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@protocol ChooseSliderDelegate <NSObject>

- (void)chooseSliderVolueDidChanged:(int)index oldIndex:(int)oldIndex;

@end

@interface ChooseSlider : UIView{
    int _index;
    int _number;
    int _oldIndex;
}

@property (assign, nonatomic) id <ChooseSliderDelegate> delegate;
@property (retain, nonatomic) UIButton  *chooseButton;
@property (assign, nonatomic) int index;
@property (assign, nonatomic) int oldIndex;

- (void)setNumberOfSlider:(int)number;
- (void)setSliderCenter:(int)index;

@end
