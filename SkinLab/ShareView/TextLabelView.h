//
//  TextLabelView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-10.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextLabelView;

@protocol TextLabelViewDelagate <NSObject>

- (void)textLabelViewDidTouched:(TextLabelView *)textLabelView;

@end

@interface TextLabelView : UIView

@property (weak, nonatomic) id <TextLabelViewDelagate> delegate;
@property (strong, nonatomic) UIImageView *backImage;
@property (strong, nonatomic) UILabel     *textLabel;


@end
