//
//  UserInfoView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-5.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@interface UserInfoView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *nameLabel;
@property (strong, nonatomic) UILabel     *levelLabel;
@property (strong, nonatomic) UILabel     *scoreLabel;

@property (strong, nonatomic) UITextField *userField;
@property (strong, nonatomic) UITextField *passField;

@end
