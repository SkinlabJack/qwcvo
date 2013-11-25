//
//  ReservationViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-13.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ReservationViewController.h"

@interface ReservationViewController ()

@end

@implementation ReservationViewController

- (void)dealloc
{
    DLog(@"ReservationViewController dealloc")
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = GrayColor;
    [self setupNavigationController];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 565);
    [self.view addSubview:self.scrollView];
    
    self.userImage = [[ZKIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.userImage.center             = CGPointMake(320/2, 130/2);
    self.userImage.layer.cornerRadius = 40;
    self.userImage.layer.borderColor  = GreenColor.CGColor;
    self.userImage.layer.borderWidth  = 2;
    self.userImage.imageView.image    = [UIImage imageNamed:@"关于logo"];
    [self.scrollView addSubview:self.userImage];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 130, 270, 100)];
    textLabel.textAlignment   = UITextAlignmentCenter;
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.font            = [UIFont boldSystemFontOfSize:15];
    textLabel.textColor       = GreenColor;
    textLabel.text            = @"";
    textLabel.layer.masksToBounds = YES;
    textLabel.layer.cornerRadius  = 5;
    [self.scrollView addSubview:textLabel];
    
    UIView *thisWeek = [self createReservationButtonView:nil withTitle:@"预约未来9天的专业护肤咨询服务"];
    thisWeek.frame   = CGRectMake(0, 245, kScreenWidth, 320);
    [self.scrollView addSubview:thisWeek];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    
    if (![DataCenter isiOS7]) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }
    
}

- (IBAction)leftBarButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender {
    
}

- (UIView *)createReservationButtonView:(NSArray *)array withTitle:(NSString *)title {
    
    UIView *weekButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 270, 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font            = [UIFont boldSystemFontOfSize:15];
    textLabel.textColor       = BlackColor;
    textLabel.text            = title;
    [weekButtonView addSubview:textLabel];
    
    for (int i = 0; i < 3; i++) {
        
        for (int j = 0; j < 3; j++) {
            if (i != 1 || j != 3) {
                float height = 90;
                ZKIButton *weeklyButton = [[ZKIButton alloc] initWithFrame:CGRectMake(25 + height * j, 30 + height * i, height, height)];
                weeklyButton.keyID = @"test";
                weeklyButton.layer.borderColor   = GreenColor.CGColor;
                weeklyButton.layer.borderWidth   = 1;
                weeklyButton.layer.cornerRadius  = 0;
                [weekButtonView addSubview:weeklyButton];
                
                [weeklyButton addTapBlock:^(NSString *keyID) {
                    DLog(@"预约")
                }];
            }
        }
    }

    return weekButtonView;
}


@end
