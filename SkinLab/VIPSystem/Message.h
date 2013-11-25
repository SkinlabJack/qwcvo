//
//  Message.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-31.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatTextView.h"

@interface Message : NSObject

@property (copy) NSString *type;
@property (copy) NSString *text;
@property (assign) float  height;
@property (copy) NSString *date;
@property (copy) NSString *from;
@property (copy) NSString *to;
@property (copy) NSString *key;
@property (copy) NSString *state;
@property (copy) NSString *cellMode;

@property (strong) ChatTextView *textView;

@end
