//
//  Message.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-31.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id)init
{
    self = [super init];
    if (self) {
        self.type   = @"TextMessage";
        self.text   = @"";
        self.height = 20;
        self.date   = @"";
        self.from   = @"";
        self.to     = @"";
        self.key    = @"";
        self.state  = @"已发";
        
        [self addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    ChatTextView *textView = [[ChatTextView alloc] initWithFrame:CGRectMake(10, 10, 230 - 20, 230 - 20)];
    textView.text    = change[@"new"];
    CGRect rect      = textView.frame;
    rect.size.height = [textView getHeightOfTextView];
    textView.frame   = rect;
    self.textView    = textView;
    
    self.height = rect.size.height + 20 + 40;
    
    DLog(@"CellHeight = %f", self.height)
    
}

@end
