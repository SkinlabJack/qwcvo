//
//  AboutViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-11.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


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
    
//    UIButton *weibo = [[UIButton alloc] initWithFrame:CGRectMake(100, kScreenHeight - 230, 120, 30)];
//    [weibo setImage:[UIImage imageNamed:@"官方微博"] forState:UIControlStateNormal];
//    [self.view addSubview:weibo];
//    [weibo release];
    
    UIButton *webSite = [[UIButton alloc] initWithFrame:CGRectMake(100, kScreenHeight - 190, 120, 30)];
    [webSite setImage:[UIImage imageNamed:@"产品主页"] forState:UIControlStateNormal];
    [webSite addTarget:self action:@selector(webSite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webSite];
    
    UIButton *contactUs = [[UIButton alloc] initWithFrame:CGRectMake(100, kScreenHeight - 150, 120, 30)];
    [contactUs setImage:[UIImage imageNamed:@"联系我们"] forState:UIControlStateNormal];
    [contactUs addTarget:self action:@selector(contactUs:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactUs];
    
    UILabel *copyRight1 = [[UILabel alloc] initWithFrame:CGRectMake(60, kScreenHeight - 64 - 35, 200, 15)];
    copyRight1.backgroundColor = [UIColor clearColor];
    copyRight1.font            = [UIFont systemFontOfSize:10];
    copyRight1.textAlignment   = UITextAlignmentCenter;
    copyRight1.textColor       = TextGrayColor;
    copyRight1.text            = @"Copyright©2013";
    [self.view addSubview:copyRight1];
    
    UILabel *copyRight = [[UILabel alloc] initWithFrame:CGRectMake(60, kScreenHeight - 64 - 20, 200, 15)];
    copyRight.backgroundColor = [UIColor clearColor];
    copyRight.font = [UIFont systemFontOfSize:10];
    copyRight.textAlignment = UITextAlignmentCenter;
    copyRight.textColor = TextGrayColor;
    copyRight.text = @"www.skin-lab.org All Rights Reserved.";
    [self.view addSubview:copyRight];
    
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

- (IBAction)leftBarButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)webSite:(id)sender{
    NSString *appURL = @"http://www.skin-lab.org/app";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
}

- (IBAction)contactUs:(id)sender{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        MFMailComposeViewController * mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        
        //Set the subject
        [mailView setSubject:[NSString stringWithFormat:@"SkinLab-V%@-%@", [DataCenter shareData].appVersion, [DataCenter shareData].appMarket]];
        [mailView setToRecipients:@[@"tryseason@gmail.com"]];
        //Set the mail body
        
        //Display Email Composer
        if([mailClass canSendMail]) {
            [self presentModalViewController:mailView animated:YES];
        }
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //DLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            //DLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            //DLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            //DLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
