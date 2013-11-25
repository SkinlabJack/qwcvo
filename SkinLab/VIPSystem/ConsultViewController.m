//
//  ConsultViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-13.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ConsultViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "ReservationViewController.h"

#define TextHeight 150

@interface ConsultViewController ()

@end

@implementation ConsultViewController

- (void)dealloc
{
    DLog(@"ConsultViewController dealloc")
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
    [self httpRequestAdvisorList];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, TextHeight - 20, 290, 20)];
    textLabel.textAlignment   = UITextAlignmentCenter;
    textLabel.backgroundColor = GreenColor;
    textLabel.font            = [UIFont boldSystemFontOfSize:12];
    textLabel.textColor       = [UIColor whiteColor];
    textLabel.layer.masksToBounds = YES;
    textLabel.layer.cornerRadius  = 5;
    textLabel.text            = @"会员专享护肤顾问 为您提供最权威的护肤咨询服务";
    [self.scrollView addSubview:textLabel];
    
    for (int i = 0; i < 3; i++) {
        
        for (int j = 0; j < 2; j++) {
            
            float height = 140;
            ZKIButton *weeklyButton = [[ZKIButton alloc] initWithFrame:CGRectMake(15 + 150 * j, TextHeight + 15 + (height + 10) * i, height, height)];
            weeklyButton.keyID = @"test";
            [self.scrollView addSubview:weeklyButton];
            
            if (j%2 == 0) {
                [weeklyButton createLabels:@"咨询"];
                
            }else{
                [weeklyButton createLabels:@"预约"];
                
            }
            
            if ([weeklyButton.titelLabel.text isEqualToString:@"预约"]) {
                
                [weeklyButton addTapBlock:^(NSString *keyID) {
                    ReservationViewController *chatViewController = [[ReservationViewController alloc] init];
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }];
                
            }else{
                [weeklyButton addTapBlock:^(NSString *keyID) {
                    ChatViewController *chatViewController = [[ChatViewController alloc] init];
                    chatViewController.fromUser = keyID;
                    [self.navigationController pushViewController:chatViewController animated:YES];
                }];
            }
            
        }
    }

    self.scrollView.contentSize = CGSizeMake(kScreenWidth, TextHeight + 30 + 140 * 3 + 20);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    [rightButton setTitle:@"我的预约" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (IBAction)leftBarButtonClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender {
    
}

#pragma mark - httpRequest

- (void)httpRequestAdvisorList{
    
    [[SkinLabHttpClient sharedClient] getPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeAdvisor]
                                   parameters:@{@"action": @"getadvisors"}
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          
                                          NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                               options:NSJSONReadingMutableLeaves
                                                                                                 error:nil];
                                          DLog(@"%@", dataArray)
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                      }];
}

@end
