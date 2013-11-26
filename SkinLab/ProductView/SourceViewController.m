//
//  SourceViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-8-13.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SourceViewController.h"

@interface SourceViewController ()

@end

@implementation SourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _showNav = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIScrollView *scrollView = nil;
    
    if ([DataCenter shareData].deviceType == DeviceTypeiPhone4) {
        if (self.showNav) {
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
        }else{
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20)];
        }
        
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
    }
    
    scrollView.backgroundColor = GrayColor;
    [self.view addSubview:scrollView];
    
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 200, 20)];
    label0.backgroundColor = [UIColor clearColor];
    label0.textAlignment = NSTextAlignmentCenter;
    label0.font = [UIFont boldSystemFontOfSize:18];
    label0.text = @"SkinLab数据来源";
    [scrollView addSubview:label0];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 290, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont boldSystemFontOfSize:16];
    label1.text = @"CIR (Cosmetic Ingredient Review)";
    [scrollView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, 290, 80)];
    label2.numberOfLines = 4;
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"2006. CIR Compendium, containing abstracts, discussions, and conclusions of CIR cosmetic ingredient safety assessments. Washington DC.";
    [scrollView addSubview:label2];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 210, 290, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont boldSystemFontOfSize:16];
    label3.text = @"EC (Environment Canada)";
    [scrollView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 235, 290, 80)];
    label4.numberOfLines = 4;
    label4.backgroundColor = [UIColor clearColor];
    label4.font = [UIFont systemFontOfSize:14];
    label4.text = @"2008. Domestic Substances List Categorization. Canadian Environmental Protection Act (CEPA) Environmental Registry.";
    [scrollView addSubview:label4];
    
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15, 340, 290, 20)];
    label5.backgroundColor = [UIColor clearColor];
    label5.font = [UIFont boldSystemFontOfSize:16];
    label5.text = @"IFRA (International Fragrance Assocication)";
    [scrollView addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(15, 365, 290, 80)];
    label6.numberOfLines = 4;
    label6.backgroundColor = [UIColor clearColor];
    label6.font = [UIFont systemFontOfSize:14];
    label6.text = @"2010. IFRA Fragrance Ingredient List based on 2008 Use Survey.";
    [scrollView addSubview:label6];
    
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(15, 470, 290, 20)];
    label7.backgroundColor = [UIColor clearColor];
    label7.font = [UIFont boldSystemFontOfSize:16];
    label7.text = @"NLM (National Library of Medicine)";
    [scrollView addSubview:label7];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(15, 495, 290, 80)];
    label8.numberOfLines = 4;
    label8.backgroundColor = [UIColor clearColor];
    label8.font = [UIFont systemFontOfSize:14];
    label8.text = @"2012. PubMed online scientific bibliography data. http://www.pubmed.gov.";
    [scrollView addSubview:label8];
    
//    UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(15, 600, 290, 20)];
//    label9.backgroundColor = [UIColor clearColor];
//    label9.font = [UIFont boldSystemFontOfSize:16];
//    label9.text = @"COSDNA";
//    [scrollView addSubview:label9];
//    [label9 release];
//    
//    UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(15, 625, 290, 40)];
//    label10.numberOfLines = 4;
//    label10.backgroundColor = [UIColor clearColor];
//    label10.font = [UIFont systemFontOfSize:14];
//    label10.text = @"www.cosdna.com";
//    [scrollView addSubview:label10];
//    [label10 release];
    
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, 680);
    [self setupNavigationController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    
    if ([DataCenter shareData].deviceType == DeviceTypeiPhone4) {
        if (!self.showNav) {
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 50, 30)];
            [leftButton setImage:[UIImage imageNamed:@"透明返回"] forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:leftButton];

        }
    }
    
    if (![AppHelper shareHelper].appCenter.isiOS7) {
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

@end
