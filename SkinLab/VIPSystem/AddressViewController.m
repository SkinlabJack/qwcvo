//
//  AddressViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-20.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()

@end

@implementation AddressViewController

- (void)dealloc
{
    DLog(@"AddressViewController dealloc")
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
    
    [AppHelper shareHelper].userCenter.hasAddress = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
