//
//  InviteViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-19.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "InviteViewController.h"
#import "AppDelegate.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

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
	
    ZKIButton *qrButton = [[ZKIButton alloc] initWithFrame:CGRectMake(40, 40, 240, 240)];
    qrButton.imageView.image = [self createQRImage:@"test" withDeviceID:[AppHelper shareHelper].appCenter.deviceID];
    [self.view addSubview:qrButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
}

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (UIImage *)createQRImage:(NSString *)key withDeviceID:(NSString *)deviceID {
    NSString *text = [NSString stringWithFormat:@"%@-%@", key, deviceID];
    return [QRCodeGenerator qrImageForString:text imageSize:480];
}

@end
