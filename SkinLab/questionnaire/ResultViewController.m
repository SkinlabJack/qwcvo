//
//  ResultViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-4.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ResultViewController.h"
#import "RecommendDetailViewController.h"
#import "SettingViewController.h"
#import "WeeklyViewController.h"

#define RecommendViewHeight  300
#define ResultTextViewHeight 180
#define WeeklyViewHeight     200

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)dealloc
{
    DLog(@"ResultViewController dealloc")
    
    
    
    
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
    [self setupNavigationController];
    
    UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
    self.scrollView = tempScrollView;
    self.scrollView.canCancelContentTouches = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = GrayColor;
    self.scrollView.contentSize     = CGSizeMake(kScreenWidth, kScreenHeight * 2);
    [self.view addSubview:self.scrollView];
    
    [self refreashView];
    
    if (self.productID != nil) {
        
        NSString *type;
        
        for (NSDictionary *dic in [DataCenter shareData].testResultArray[@"Products"]) {
            if ([dic[@"ProductID"] isEqualToString:self.productID]) {
                [self setupProductView:[self getProductDataArray:dic[@"ProductType"]]];
                type = dic[@"ProductType"];
                break;
            }
        }
        
        for (UIView *view in [self.typeScrollView subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if ([button.titleLabel.text isEqualToString:type]) {
                    [UIView animateWithDuration:0.25 animations:^{
                        self.selectView.frame = CGRectMake(25 + button.tag * 70, 40, 20, 10);
                    }];
                    self.typeScrollView.contentOffset = CGPointMake(button.tag * 70, 0);
                    
                    break;
                }
            }
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationController{
    
    if (![DataCenter isiOS7]) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"重测" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}


- (void)setupTypeScrollView:(NSArray *)typeArray {
    
    [self.typeScrollView removeFromSuperview];
    
    UIScrollView *tempView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.typeScrollView = tempView;
    self.typeScrollView.showsHorizontalScrollIndicator = NO;
    self.typeScrollView.backgroundColor = [UIColor whiteColor];
    self.typeScrollView.clipsToBounds   = NO;
    [self.scrollView addSubview:self.typeScrollView];
    
    if (typeArray.count <= 4) {
        for (int i = 0; i < typeArray.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(320/typeArray.count * i, 0, 320/typeArray.count, 40)];
            [button setTitle:typeArray[i] forState:UIControlStateNormal];
            [button setTitleColor:GreenColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.typeScrollView addSubview:button];
            
            if (i != typeArray.count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width - 1, 3, 1, 34)];
                line.backgroundColor = GreenColor;
                [button addSubview:line];
            }
        }
        
        self.typeScrollView.contentSize = CGSizeMake(kScreenWidth, 40);
        
    }else{
        
        for (int i = 0; i < typeArray.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70 * i, 0, 70, 40)];
            button.tag = i;
            [button setTitle:typeArray[i] forState:UIControlStateNormal];
            [button setTitleColor:GreenColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.typeScrollView addSubview:button];
            
            if (i != typeArray.count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width - 1, 10, 1, 20)];
                line.backgroundColor = GreenColor;
                [button addSubview:line];
            }
        }
        
        UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 40, 20, 10)];
        self.selectView = tempView;
        self.selectView.image = [UIImage imageNamed:@"三角倒"];
        [self.typeScrollView addSubview:self.selectView];
        
        self.typeScrollView.contentSize = CGSizeMake(70 * typeArray.count, 40);
    }
    
}

- (void)setupProductView:(NSArray *)array {
    
    if (self.recommendView == nil) {
        UIView *tempRecommendView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, RecommendViewHeight)];
        self.recommendView = tempRecommendView;
        [self.scrollView addSubview:self.recommendView];
    }
    
    for (UIView *view in [self.recommendView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < array.count; i++) {
        
        RecommendView *tempView = [[RecommendView alloc] initWithFrame:CGRectMake(0, RecommendViewHeight * i, kScreenWidth, RecommendViewHeight)];
        tempView.delegate = self;
        tempView.nameLabel.text        = array[i][@"ProductName"];
        tempView.infoLabel.text        = array[i][@"ProductBrand"];
        tempView.descriptionLabel.text = [NSString stringWithFormat:@"针对%@问题", array[i][@"Description"]];
        tempView.productID             = array[i][@"ProductID"];
        
        NSString *description  = [NSString stringWithFormat:@"您的肌肤可能存在问题：%@", array[i][@"Description"]];
        NSString *suggestion   = [NSString stringWithFormat:@"SkinLab建议您%@", array[i][@"Suggestion"]];
        NSString *hint         = @"";
        
        if (![DataCenter isNull:array[i][@"Hint"]]) {
            hint = [NSString stringWithFormat:@"Tips：%@", array[i][@"Hint"]];
        }
        
        tempView.textView.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@", description, suggestion, array[i][@"DetailDes"], hint];
        
        NSString *imageURLString = [array[i][@"ProductImage"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
        NSURL    *imageURL       = [SkinLabHttpClient getImageURL:imageURLString];
        [tempView.imageView setImageWithURL:imageURL];
        
        [self.recommendView addSubview:tempView];
        
    }
    
    self.recommendView.frame    = CGRectMake(0, 40, kScreenWidth, RecommendViewHeight * array.count);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, RecommendViewHeight * array.count + 40 + WeeklyViewHeight);
    
    [self setupWeeklyView:[DataCenter shareData].testResultArray[@"Journals"] y:40 + RecommendViewHeight * array.count];
    
}

- (void)setupWeeklyView:(NSArray *)array y:(float)y{
    
    if (self.weeklyView == nil) {
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, WeeklyViewHeight)];
        self.weeklyView = tempView;
        [self.scrollView addSubview:self.weeklyView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 20)];
        label.numberOfLines   = 2;
        label.backgroundColor = [UIColor clearColor];
        label.textColor       = GreenColor;
        label.font            = [UIFont boldSystemFontOfSize:15];
        label.text            = @"了解您肌肤问题的针对性解决方案";
        [self.weeklyView addSubview:label];
        
        UIScrollView *tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 130)];
        self.weeklyScrollView = tempScrollView;
        self.weeklyScrollView.backgroundColor = [UIColor clearColor];
        self.weeklyScrollView.showsHorizontalScrollIndicator = NO;
        [self.weeklyView addSubview:self.weeklyScrollView];
        
        for (int i = 0; i < array.count; i++) {
            UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 100, 130)];
            [imageView setImage:[UIImage imageNamed:@"测试周刊"] forState:UIControlStateNormal];
            [imageView setImage:[UIImage imageNamed:@"测试周刊"] forState:UIControlStateHighlighted];
            imageView.center = CGPointMake(10 + 110/2 + 110 * i, 130/2);
            NSString *jID    = array[i][@"JID"];
            imageView.tag    = jID.intValue;
            [imageView addTarget:self action:@selector(weeklyClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.weeklyScrollView addSubview:imageView];
            
            UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 80, 40)];
            titelLabel.numberOfLines = 2;
            titelLabel.font      = [UIFont systemFontOfSize:13];
            titelLabel.textColor = GreenColor;
            titelLabel.text      = [array[i][@"JournalTitle"] substringFromIndex:8];
            [imageView addSubview:titelLabel];
        }
        
    }else{
        self.weeklyView.frame = CGRectMake(0, y, kScreenWidth, WeeklyViewHeight);
    }
    
    self.weeklyScrollView.contentSize = CGSizeMake(10 * 2 + 110 * array.count, 130);
    DLog(@"%@", array)
}

- (void)setupDescriptionView:(NSArray *)array {
    if (self.descriptionView == nil) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.descriptionView = tempView;
        self.descriptionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(15, 80, 290, 160)];
        label.editable    = NO;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor       = GreenColor;
        label.font            = [UIFont boldSystemFontOfSize:16];
        label.text            = @"了解您肌肤问题的针对性解决方案";
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius  = 5;
        [self.descriptionView addSubview:label];
        
        UILabel *button = [[UILabel alloc] initWithFrame:CGRectMake(90, 270, 140, 40)];
        button.textAlignment   = UITextAlignmentCenter;
        button.backgroundColor = GreenColor;
        button.textColor       = [UIColor whiteColor];
        button.font = [UIFont systemFontOfSize:15];
        button.text = @"点击查看解决方案";
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 5;
        [self.descriptionView addSubview:button];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descriptionViewTouched:)];
        tap.numberOfTapsRequired    = 1;
        tap.numberOfTouchesRequired = 1;
        [self.descriptionView addGestureRecognizer:tap];
    }
    
    if (self.showDescription) {
        self.descriptionView.alpha = 1;
        [self.view addSubview:self.descriptionView];
    }
    
    DLog(@"%@", array)
    
    for (UIView *view in [self.descriptionView subviews]) {
        if ([view isKindOfClass:[UITextView class]]) {
            
            UITextView *textView = (UITextView *)view;
            NSString   *text     = @"您的肌肤可能存在以下问题\n";
            
            for (NSDictionary *dic in array) {
                text = [NSString stringWithFormat:@"%@\n%@", text, dic[@"Description"]];
            }
            
            textView.text = text;
        }
    }
    
}


- (void)refreashView {
    
    NSArray *productsArray    = [DataCenter shareData].testResultArray[@"Products"];
    NSArray *sortArray        = [productsArray sortedArrayUsingFunction:nameSort context:NULL];
    NSMutableArray *typeArray = [NSMutableArray array];
    
    if (![DataCenter isNull:sortArray]) {
        if (sortArray.count > 1) {
            
            [typeArray addObject:sortArray[0][@"ProductType"]];
            
            for (int i = 1; i < sortArray.count; i++) {
                if (![sortArray[i][@"ProductType"] isEqualToString:sortArray[i - 1][@"ProductType"]]) {
                    [typeArray addObject:sortArray[i][@"ProductType"]];
                }
            }
            
        }else{
            if (sortArray.count == 1) {
                [typeArray addObject:sortArray[0][@"ProductType"]];
            }
        }
    }
    
    NSArray *array = [self getProductDataArray:sortArray[0][@"ProductType"]];
    
    [self setupProductView:array];
    [self setupTypeScrollView:typeArray];
    [self setupDescriptionView:array];
    
}

NSInteger nameSort(id user1, id user2, void *context)
{
    NSString *u1,*u2;
    u1 = (NSString *)(user1[@"ProductType"]);
    u2 = (NSString *)(user2[@"ProductType"]);
    return  [u1 localizedCompare:u2];
}

- (NSArray *)getProductDataArray:(NSString *)type {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in [DataCenter shareData].testResultArray[@"Products"]) {
        if ([dic[@"ProductType"] isEqualToString:type]) {
            [array addObject:dic];
        }
    }
    
    return array;
}

#pragma mark - ButtonClicked

- (IBAction)leftBarButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender {
    
    QuestionnaireViewController *questionnaireViewController = [[QuestionnaireViewController alloc] initWithNibName:@"QuestionnaireViewController" bundle:nil];
    questionnaireViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:questionnaireViewController];
    
    if ([DataCenter isiOS7]) {
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }else{
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}

- (IBAction)typeButtonClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.selectView.frame = CGRectMake(25 + sender.tag * 70, 40, 20, 10);
    }];
    
    [self setupProductView:[self getProductDataArray:sender.titleLabel.text]];
    DLog(@"%@", sender.titleLabel.text)
}

- (IBAction)descriptionViewTouched:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.descriptionView.alpha = 0;
    }];
    
    [self.descriptionView removeFromSuperview];
    
}

- (IBAction)weeklyClicked:(UIButton *)sender {
    
    NSString *JID = [NSString stringWithFormat:@"%d", sender.tag];
    
    for (NSDictionary *dic in [DataCenter shareData].weeklyArray) {
        if ([dic[@"JID"] isEqualToString:JID]) {
            DLog(@"%@", dic)
            WeeklyViewController *weeklyViewController = [[WeeklyViewController alloc] initWithNibName:@"WeeklyViewController" bundle:nil];
            weeklyViewController.weeklyDic = dic;
            [self.navigationController pushViewController:weeklyViewController animated:YES];
        }
    }
    
}

#pragma mark - RecommendViewDelegate

- (void)recommendViewDidClicked:(NSString *)productID{
    DLog(@"%@", productID)
    RecommendDetailViewController *recommendDetailViewController = [[RecommendDetailViewController alloc] initWithNibName:@"RecommendDetailViewController" bundle:nil];
    recommendDetailViewController.recommendDetailViewMode = RecommendDetailViewModeWithNav;
    [recommendDetailViewController setProductInfoByID:productID];
    [self.navigationController pushViewController:recommendDetailViewController animated:YES];
    
    NSString *product = [NSString stringWithFormat:@"%@ByTest", productID];
    [MobClick event:@"productview" label:product];
}

#pragma mark - QuestionnaireViewControllerDelegate

- (void)questionnaireDidFinished:(NSDictionary *)dic {
    
    [DataCenter shareData].testResultArray = dic;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[DataCenter getStringWithVersion:@"test"]];
    [[DataCenter shareData] writeToFile:dic withFileName:@"testResult.plist"];
    
    self.showDescription = YES;
    
    [self refreashView];
    
}


@end
