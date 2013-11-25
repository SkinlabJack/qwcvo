//
//  OrderDetailViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-20.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)dealloc
{
    DLog(@"OrderDetailViewController dealloc")
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
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 20)];
    textLabel.textAlignment   = UITextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font            = [UIFont boldSystemFontOfSize:18];
    textLabel.textColor       = GreenColor;
    textLabel.text            = @"您已获得以下礼品";
    [self.view addSubview:textLabel];
	   
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 290, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font            = [UIFont boldSystemFontOfSize:15];
    label1.textColor       = GreenColor;
    label1.text            = @"1、护肤品试用新手礼包一份";
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 290, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font            = [UIFont boldSystemFontOfSize:15];
    label2.textColor       = GreenColor;
    label2.text            = @"2、一对一专业护肤咨询一次";
    [self.view addSubview:label2];
    
    __weak typeof(self) blockSelf = self;
    
    ZKIButton *button = [[ZKIButton alloc] initWithFrame:CGRectMake(15, 115, 290, 160)];
    [self.view addSubview:button];
    
    ZKIButton *address = [[ZKIButton alloc] initWithFrame:CGRectMake(15, 290, 290, 60)];
    if ([DataCenter shareData].hasAddress) {
        [address createTitleLabel:@"修改收货地址（点击修改）"];
        [self setupNavigationController];
    }else{
        [address createTitleLabel:@"没有收货地址（点击添加）"];
    }
    
    [self.view addSubview:address];
    
    [address addTapBlock:^(NSString *keyID) {
        AddressViewController *addressViewController = [[AddressViewController alloc] init];
        [blockSelf.navigationController pushViewController:addressViewController animated:YES];
    }];
    
    ZKIButton *reservation = [[ZKIButton alloc] initWithFrame:CGRectMake(15, kScreenHeight - KSNHeight - 60 - 15, 290, 60)];
    [reservation createTitleLabel:@"预约护肤顾问"];
    [self.view addSubview:reservation];
    
    [reservation addTapBlock:^(NSString *keyID) {
        NSDictionary *dic = @{@"ViewName": @"ConsultView"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:blockSelf userInfo:dic];
        [blockSelf dismissModalViewControllerAnimated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DataCenter shareData].hasAddress) {
        [self setupNavigationController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController {
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setTitle:@"完成" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

- (IBAction)leftBarButtonClicked:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
