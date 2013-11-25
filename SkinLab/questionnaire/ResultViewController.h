//
//  ResultViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-4.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionnaireViewController.h"
#import "RecommendView.h"

@interface ResultViewController : UIViewController <QuestionnaireViewControllerDelegate, RecommendViewDelegate, UIAlertViewDelegate> {
    
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *typeScrollView;
@property (strong, nonatomic) UIScrollView *weeklyScrollView;

@property (strong, nonatomic) UIImageView *selectView;
@property (strong, nonatomic) UIView *recommendView;
@property (strong, nonatomic) UIView *resultView;
@property (strong, nonatomic) UIView *weeklyView;
@property (strong, nonatomic) UIView *descriptionView;

@property (copy,   nonatomic) NSString *productID;
@property (assign) BOOL showDescription;

@end
