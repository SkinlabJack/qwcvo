//
//  ShopViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"
#import "UserInfoView.h"
#import "OrderDetailViewController.h"

@interface ShopViewController : UIViewController <UIAlertViewDelegate>

@property (strong) UserInfoView *userInfoView;
@property (strong) UIScrollView *scrollView;

@end
