//
//  NewFeaturesViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-9.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 

@interface NewFeaturesViewController : UIViewController <UIScrollViewDelegate>{
    BOOL _start;
}

@property (strong, nonatomic) UIScrollView *scrollView;

- (void)setNewFeatruesImageArray:(NSArray *)imageArray imageType:(NSString *)imageType;

@end
