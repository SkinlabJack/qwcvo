//
//  ActivityView.m
//  OSGHCinemas
//
//  Created by Dai Qinfu on 12-6-26.
//  Copyright (c) 2012年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView

- (void)dealloc{
    DLog(@"ActivityView dealloc")
    self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                
        UIImageView *blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        [blackView setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
        blackView.backgroundColor = GreenColor;
        CALayer *lay = blackView.layer;
        lay.masksToBounds = YES;
        lay.cornerRadius = 5.0;
        [self addSubview:blackView];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 120, 20)];
        self.noteLabel = tempLabel;
        self.noteLabel.backgroundColor = [UIColor clearColor];
        self.noteLabel.textAlignment = UITextAlignmentCenter;
        self.noteLabel.textColor = [UIColor whiteColor];
        self.noteLabel.font = [UIFont boldSystemFontOfSize:15];
        self.noteLabel.text = @"加载中...";
        [blackView addSubview:self.noteLabel];

        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
        self.activityView = activity;
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [blackView addSubview:self.activityView];
        [self.activityView startAnimating];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timerHandle{
    if ([UIApplication sharedApplication].networkActivityIndicatorVisible == NO) {
        [self.delegate loadingDataDidFinished:self];
        [_timer invalidate];
    }
}

@end
