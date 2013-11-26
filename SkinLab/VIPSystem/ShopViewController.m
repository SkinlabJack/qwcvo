//
//  ShopViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ShopViewController.h"
#import "AppDelegate.h"

#define PackageHeight  200
#define UserViewHeight 130

@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)dealloc
{
    DLog(@"ShopViewController dealloc")
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
    self.scrollView.contentInset = UIEdgeInsetsMake(130, 0, 0, 0);
    [self.view addSubview:self.scrollView];
    
    self.userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, -130, kScreenWidth, UserViewHeight)];
    [self.scrollView addSubview:self.userInfoView];
    
    for (int i = 0; i < 4; i++) {
        UIView *tempView = [self createPackageView:nil];
        tempView.frame = CGRectMake(0, 15 + PackageHeight * i, kScreenWidth, PackageHeight);
        [self.scrollView addSubview:tempView];
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 15 + PackageHeight * 4);
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationController{
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"升级" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender {
    NSDictionary *dic = @{@"ViewName": @"VIPMainView"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
}

- (UIView *)createPackageView:(NSDictionary *)dic {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, PackageHeight)];
    
    UIView *center = [[UIView alloc] initWithFrame:CGRectMake(15 - 2.5, 7, 6, 6)];
    center.layer.masksToBounds = YES;
    center.layer.cornerRadius  = 3;
    center.backgroundColor     = GreenColor;
    [view addSubview:center];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 20, 1, view.frame.size.height - 20)];
    line.backgroundColor = GreenColor;
    [view addSubview:line];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 290, 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font            = [UIFont boldSystemFontOfSize:15];
    textLabel.textColor       = GreenColor;
    textLabel.text            = @"新手礼包";
    [view addSubview:textLabel];
    
    ZKIButton *button = [[ZKIButton alloc] initWithFrame:CGRectMake(30, 30, 275, PackageHeight - 45)];
    [view addSubview:button];
    
    [button addTapBlock:^(NSString *keyID) {
        if (![DataCenter isLogin]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您还没有登录"
                                                            message:@"成为SkinLab会员，尽享专属服务"
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"兑换XXX礼包"
                                                            message:@"礼包包含SkinLab免费试用小样一套，一对一专业护肤咨询一次。兑换本礼包将扣除您XXX积分，感谢您对SkinLab的支持！"
                                                           delegate:self
                                                  cancelButtonTitle:@"考虑一下"
                                                  otherButtonTitles:@"兑换", nil];
            alert.tag = 2;
            [alert show];
        }
        
    }];
    
    return view;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            DLog(@"兑换XXX礼包")
            OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:orderDetailViewController];
            
            if ([AppHelper shareHelper].appCenter.isiOS7) {
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
            }else{
                [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
            }
            [self presentViewController:navigationController animated:YES completion:^{
                
            }];
        }
    }
}


@end
