//
//  UserInfoView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-5.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "UserInfoView.h"

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = GreenColor;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize   = CGSizeMake(kScreenWidth * 3, 130);
        self.scrollView.scrollEnabled = NO;
        [self addSubview:self.scrollView];
        
        if ([AppHelper shareHelper].userCenter.isLogin) {
            [self createInfoView];
            [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 2, 0) animated:NO];
        }else{
            [self createUserView];
        }
    
    }
    
    return self;
}

- (void)createUserView {
    if (self.userField == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 260, 20)];
        label.textAlignment   = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font            = [UIFont boldSystemFontOfSize:12];
        label.textColor       = [UIColor whiteColor];
        label.text            = @"输入您的邮箱地址，登录或注册SkinLab";
        [self.scrollView addSubview:label];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(30, 50, 260, 30)];
        back.backgroundColor     = [UIColor whiteColor];
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius  = 15;
        back.layer.borderColor   = GreenColor.CGColor;
        back.layer.borderWidth   = 1;
        [self.scrollView addSubview:back];
        
        self.userField = [[UITextField alloc] initWithFrame:CGRectMake(40, 50, 240, 30)];
        self.userField.contentVerticalAlignment      = UIControlContentVerticalAlignmentCenter;
        self.userField.enablesReturnKeyAutomatically = YES;
        self.userField.keyboardType    = UIKeyboardTypeEmailAddress;
        self.userField.backgroundColor = [UIColor clearColor];
        self.userField.returnKeyType   = UIReturnKeyDone;
        self.userField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userField.textColor       = BlackColor;
        self.userField.font            = [UIFont systemFontOfSize:15];
        self.userField.placeholder     = @"输入邮箱";
        [self.scrollView addSubview:self.userField];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 90, 80, 30)];
        nextButton.layer.masksToBounds = YES;
        nextButton.layer.cornerRadius  = 5;
        nextButton.backgroundColor     = GreenColor;
        nextButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:nextButton];
    }
}

- (void)createPassView {
    if (self.passField == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.frame.size.height)];
        [self.scrollView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 260, 15)];
        label.textAlignment   = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font            = [UIFont boldSystemFontOfSize:12];
        label.textColor       = [UIColor whiteColor];
        label.text            = @"您在使用以下邮箱登录SkinLab";
        [view addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 260, 15)];
        label1.textAlignment   = UITextAlignmentCenter;
        label1.backgroundColor = [UIColor clearColor];
        label1.font            = [UIFont boldSystemFontOfSize:12];
        label1.textColor       = [UIColor whiteColor];
        label1.text            = self.userField.text;
        [view addSubview:label1];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(30, 50, 260, 30)];
        back.backgroundColor     = [UIColor whiteColor];
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius  = 15;
        back.layer.borderColor   = GreenColor.CGColor;
        back.layer.borderWidth   = 1;
        [view addSubview:back];
        
        self.userField = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 240, 30)];
        self.userField.contentVerticalAlignment      = UIControlContentVerticalAlignmentCenter;
        self.userField.enablesReturnKeyAutomatically = YES;
        self.userField.keyboardType    = UIKeyboardTypeAlphabet;
        self.userField.backgroundColor = [UIColor clearColor];
        self.userField.returnKeyType   = UIReturnKeyDone;
        self.userField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userField.textColor       = BlackColor;
        self.userField.font            = [UIFont systemFontOfSize:15];
        self.userField.placeholder     = @"输入密码";
        [view addSubview:self.userField];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 90, 80, 30)];
        nextButton.layer.masksToBounds = YES;
        nextButton.layer.cornerRadius  = 5;
        nextButton.backgroundColor     = GreenColor;
        nextButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        [nextButton setTitle:@"完成" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:nextButton];
    }
}

- (void)createInfoView {
    if (self.imageView == nil) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.frame.size.height)];
        [self.scrollView addSubview:view];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 35, 180, 25)];
        self.nameLabel.textAlignment   = UITextAlignmentCenter;
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        self.nameLabel.font            = [UIFont boldSystemFontOfSize:15];
        self.nameLabel.textColor       = GreenColor;
        self.nameLabel.text            = @"WingZki";
        self.nameLabel.layer.masksToBounds = YES;
        self.nameLabel.layer.cornerRadius  = 5;
        [view addSubview:self.nameLabel];
        
        self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 70, 85, 25)];
        self.levelLabel.textAlignment   = UITextAlignmentCenter;
        self.levelLabel.backgroundColor = [UIColor whiteColor];
        self.levelLabel.font            = [UIFont boldSystemFontOfSize:15];
        self.levelLabel.textColor       = GreenColor;
        self.levelLabel.text            = @"VIP会员";
        self.levelLabel.layer.masksToBounds = YES;
        self.levelLabel.layer.cornerRadius  = 5;
        [view addSubview:self.levelLabel];
        
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 70, 85, 25)];
        self.scoreLabel.textAlignment   = UITextAlignmentCenter;
        self.scoreLabel.backgroundColor = [UIColor whiteColor];
        self.scoreLabel.font            = [UIFont boldSystemFontOfSize:15];
        self.scoreLabel.textColor       = GreenColor;
        self.scoreLabel.text            = @"积分1288";
        self.scoreLabel.layer.masksToBounds = YES;
        self.scoreLabel.layer.cornerRadius  = 5;
        [view addSubview:self.scoreLabel];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 100, 100)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius  = backView.frame.size.width/2;
        [view addSubview:backView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        self.imageView.image = [UIImage imageNamed:@"关于logo"];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius  = self.imageView.frame.size.width/2;
        self.imageView.layer.borderColor   = GreenColor.CGColor;
        self.imageView.layer.borderWidth   = 2;
        [backView addSubview:self.imageView];

    }
}

- (IBAction)nextButtonClicked:(id)sender {
    [self createPassView];
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.passField resignFirstResponder];
    [self.userField resignFirstResponder];
    [self createInfoView];
    [AppHelper shareHelper].userCenter.isLogin = YES;
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 2, 0) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
