//
//  ActivityView.h
//  OSGHCinemas
//
//  Created by Dai Qinfu on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@class ActivityView;

@protocol ActivityViewDelegate <NSObject>

@optional
- (void)loadingDataDidFinished:(ActivityView *)activityView;

@end

@interface ActivityView : UIView{
    NSTimer *_timer;
}

@property (weak, nonatomic) id <ActivityViewDelegate> delegate;
@property (strong, nonatomic) UILabel *noteLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@end
