//
//  ChatTextView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-31.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface ChatTextView : UIView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont   *textFont;
@property (strong, nonatomic) UIColor  *textColor;
@property (assign, nonatomic) float    lineSpacing;

- (float)getHeightOfTextView;

@end
