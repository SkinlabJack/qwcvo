//
//  QRSearchViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-9-10.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "QRSearchViewController.h"

@interface QRSearchViewController ()

@end

@implementation QRSearchViewController

- (void)dealloc
{
    DLog(@"QRSearchViewController dealloc")
    
    
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
    
    self.showsZBarControls    = NO;
    self.view.backgroundColor = GrayColor;
    [self.scanner setSymbology:ZBAR_I25
                        config:ZBAR_CFG_ENABLE
                            to:0];
    
    UIImageView *black = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 568)];
    black.image = [UIImage imageNamed:@"QRBlack"];
    black.alpha = 0.7;
    [self.view addSubview:black];
    
    UIImageView *square = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 200)];
    square.layer.borderColor = GreenColor.CGColor;
    square.layer.borderWidth = 1;
    [black addSubview:square];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(70, 100, 180, 1.5)];
    line.backgroundColor = [UIColor redColor];
    line.alpha = 0;
    [black addSubview:line];
    
    [UIView animateWithDuration:2 animations:^{
        
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        line.alpha = 1;
        line.frame = CGRectMake(70, 298, 180, 1.5);
        
    }completion:^(BOOL finished) {
        line.alpha = 0;
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 320, 200, 40)];
    label.textAlignment   = UITextAlignmentCenter;
    label.textColor       = GreenColor;
    label.font            = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines   = 2;
    label.text            = @"扫描商品条码，获取最权威的护肤品安全数据";
    [black addSubview:label];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 54, kScreenWidth, 54)];
    toolBar.backgroundColor = GreenColor;
    [self.view addSubview:toolBar];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 12, 50, 30)];
    [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 55, 12, 50, 30)];
    [rightButton setImage:[UIImage imageNamed:@"闪光灯"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:rightButton];


    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 54)];
    self.upDateView = tempView;
    self.upDateView.backgroundColor = GrayColor;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(80, 60, 160, 160)];
    logo.image = [UIImage imageNamed:@"关于logo"];
    [self.upDateView addSubview:logo];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 300, 200, 20)];
    label1.textAlignment   = UITextAlignmentCenter;
    label1.textColor       = GreenColor;
    label1.font            = [UIFont boldSystemFontOfSize:18];
    label1.backgroundColor = [UIColor clearColor];
    label1.text            = @"抱歉";
    [self.upDateView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 325, 240, 20)];
    label2.textAlignment   = UITextAlignmentCenter;
    label2.textColor       = GreenColor;
    label2.font            = [UIFont boldSystemFontOfSize:13];
    label2.backgroundColor = [UIColor clearColor];
    label2.text            = @"SkinLab  还没有分析此产品的相关数据";
    [self.upDateView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 350, 240, 20)];
    label3.textAlignment   = UITextAlignmentCenter;
    label3.textColor       = GreenColor;
    label3.font            = [UIFont boldSystemFontOfSize:13];
    label3.backgroundColor = [UIColor clearColor];
    label3.text            = @"我们会在48小时内完善您所需的产品信息";
    [self.upDateView addSubview:label3];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self showUpdateView:NO];
}

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender{
    
    if (!sender.selected) {
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }else{
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
    sender.selected = !sender.selected;
    
}

- (void)showUpdateView:(BOOL)show{
    if (show) {
//        [self.readerView stop];
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
            [self.view addSubview:self.upDateView];
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            [self.upDateView removeFromSuperview];
        }];
    }
}


@end
