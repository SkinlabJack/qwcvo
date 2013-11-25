//
//  NewFeaturesViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-9.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "NewFeaturesViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define KSNTHeight 113
#define KSTHeight 69

@interface NewFeaturesViewController ()

@end

@implementation NewFeaturesViewController


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
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
}

- (void)setNewFeatruesImageArray:(NSArray *)imageArray imageType:(NSString *)imageType{
    
    UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20)];
    self.scrollView = tempScrollView;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth *imageArray.count, kScreenHeight - 20);
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < imageArray.count; i++) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:imageArray[i] ofType:imageType];
        NSData *image = [NSData dataWithContentsOfFile:filePath];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:image]];
        imageView.frame  = CGRectMake(0, 0, 280, 480 * 280 / 320);
        imageView.center = CGPointMake(kScreenWidth/2 + 320 * i, (kScreenHeight - 20)/2);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius  = 10;
        [self.scrollView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrView{
        
    if (scrView.contentOffset.x > 960 + 40) {
        _start = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_start) {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}


@end
