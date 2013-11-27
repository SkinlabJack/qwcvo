//
//  MainViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-1.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

#define KCellheight 40

@interface MainViewController ()

@end

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isQuickSearch = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    
    [self httpRequestSearchClass];
    [self httpRequestWeeklyData];
    
    if (![IOHelper isFileExist:@"BreadsList.plist"]) {
        [self httpRequestBranch];
    }else{
        self.braedsListArray = [IOHelper readArrayFromFile:@"BreadsList.plist"];
    }
    
    [self setupButtonView];
    
    if (self.qrSearchViewController == nil) {
        QRSearchViewController *qrSeach = [[QRSearchViewController alloc] init];
        self.qrSearchViewController = qrSeach;
        self.qrSearchViewController.readerDelegate = self;
    }
    
    [self setupNavigationController];
    [self setupSearchView];
    
    UIView *tempViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    self.touchViewTop = tempViewTop;
    self.touchViewTop.alpha = 0;
    [self.view addSubview:self.touchViewTop];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewTouched:)];
    tap.numberOfTapsRequired    = 1;
    tap.numberOfTouchesRequired = 1;
    [self.touchViewTop addGestureRecognizer:tap];
    
    UIView *tempViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.touchViewBottom = tempViewBottom;
    self.touchViewBottom.alpha = 0;
    [self.contentView addSubview:self.touchViewBottom];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewTouched:)];
    tap1.numberOfTapsRequired    = 1;
    tap1.numberOfTouchesRequired = 1;
    [self.touchViewBottom addGestureRecognizer:tap1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weeklyButtonClicked:) name:@"ShowWeeklyView" object:nil];
    
//    [self showNewFeaturesView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [ZKIAnalytics addNewAction:ZKIAnalyticsTypePage withSubType:@"begin" withKey:@"MainView"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [ZKIAnalytics addNewAction:ZKIAnalyticsTypePage withSubType:@"end" withKey:@"MainView"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchView cancelButtonClicked:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationController {
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
}

- (void)setupSearchView {
    
    SearchView *tempView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)
                                                    withMode:SearchViewModeMainView];
    self.searchView = tempView;
    self.searchView.backgroundColor = [UIColor clearColor];
    self.searchView.delegate        = self;
    self.searchView.clipsToBounds   = YES;
    [self.view addSubview:self.searchView];
    
    UIView *tempQuickView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight)];
    self.quickSearchView = tempQuickView;
    self.quickSearchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.quickSearchView.alpha           = 0;
    [self.view addSubview:self.quickSearchView];
    
    UITableView *moreSearchViewBack = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KCellheight * 6)];
    self.searchTypeTableView = moreSearchViewBack;
    self.searchTypeTableView.bounces = NO;
    [self.quickSearchView addSubview:self.searchTypeTableView];
    
}

- (void)setupButtonView {
    
    float gapHeight      = 15;
    float SearchHeight   = 100;
    float qrButtonHeight = 70;
    float viewHeight     = (kScreenHeight - KSNHeight - SearchHeight - 3 * gapHeight - qrButtonHeight)/2;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, SearchHeight, kScreenWidth, kScreenHeight)];
    self.contentView = tempView;
    [self.view addSubview:self.contentView];
    
    __weak typeof(self) blockSelf = self;
    
//    创建扫一扫按钮
    
    ZKIButton *qrButton = [[ZKIButton alloc] initWithFrame:CGRectMake(15, 0, 290, qrButtonHeight)];
    [self.contentView addSubview:qrButton];
    
    [qrButton addTapBlock:^(NSString *keyID) {
        [blockSelf presentModalViewController:blockSelf.qrSearchViewController animated:YES];
    }];
    
    qrButton.imageView.image = [UIImage imageNamed:@"主页扫一扫"];
    
//    创建美丽宝典按钮
    
    ZKIButton *weeklyButton = [[ZKIButton alloc] initWithFrame:CGRectMake(15, gapHeight + qrButtonHeight, 290, viewHeight)];
    [self.contentView addSubview:weeklyButton];
    
    [weeklyButton addTapBlock:^(NSString *keyID) {
        WeeklyListViewController *weeklyListViewController = [[WeeklyListViewController alloc] initWithNibName:@"WeeklyListViewController" bundle:nil];
        [blockSelf.navigationController pushViewController:weeklyListViewController animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            blockSelf.weeklyBadge.alpha = 0;
        }];
    }];
    
    weeklyButton.imageView.image = [UIImage imageNamed:@"主页周刊"];
    
    UIImageView *badge = [[UIImageView alloc] initWithFrame:CGRectMake(weeklyButton.imageView.frame.size.width - 40, weeklyButton.imageView.frame.size.height - 40, 25, 25)];
    self.weeklyBadge = badge;
    self.weeklyBadge.image = [UIImage imageNamed:@"new"];
    self.weeklyBadge.alpha = 0;
    [weeklyButton.imageView addSubview:self.weeklyBadge];
    
//    创建测试按钮
    
    ZKIButton *testButton = [[ZKIButton alloc] initWithFrame:CGRectMake(15, viewHeight + gapHeight * 2 + qrButtonHeight, 290, viewHeight)];
    [self.contentView addSubview:testButton];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[IOHelper getStringWithVersion:@"test"]]) {
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 20)];
        textLabel.textAlignment   = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font            = [UIFont boldSystemFontOfSize:15];
        textLabel.textColor       = GreenColor;
        textLabel.text            = @"为了改善您的肌肤问题，我们推荐您使用";
        textLabel.layer.masksToBounds = YES;
        textLabel.layer.cornerRadius  = 5;
        [testButton.contentView addSubview:textLabel];
        
        [self setupProductView];
        self.productView.center = CGPointMake(testButton.frame.size.width/2, testButton.frame.size.height/2 + 10);
        [testButton.contentView addSubview:self.productView];
        
    }else{
        
        testButton.imageView.image = [UIImage imageNamed:@"主页测试"];
        
        [testButton addTapBlock:^(NSString *keyID) {
            
            QuestionnaireViewController *questionnaireViewController = [[QuestionnaireViewController alloc] initWithNibName:@"QuestionnaireViewController" bundle:nil];
            questionnaireViewController.delegate = blockSelf;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:questionnaireViewController];
            
            if ([AppHelper shareHelper].appCenter.isiOS7) {
                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
            }else{
                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
            }
            
            [blockSelf presentViewController:nav animated:YES completion:^{
                
            }];
            
        }];
        
    }
    
}

- (void)setupProductView {
    
    UIScrollView *tempView = [[UIScrollView alloc]  initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 100)];
    self.productView = tempView;
    self.productView.showsHorizontalScrollIndicator = NO;
    self.productView.pagingEnabled = YES;
    
    NSArray *array = [AppHelper shareHelper].dataCenter.testResultArray[@"Products"];
    
    for (int i = 0; i < array.count; i++) {
        
        RecommendView *tempView = [[RecommendView alloc] initWithFrame:CGRectMake((kScreenWidth - 30) * i, 0, kScreenWidth - 30, 100)];
        tempView.delegate              = self;
        tempView.backgroundColor       = [UIColor clearColor];
        tempView.nameLabel.text        = array[i][@"ProductName"];
        tempView.infoLabel.text        = array[i][@"ProductBrand"];
        tempView.descriptionLabel.text = [NSString stringWithFormat:@"针对您的%@问题", array[i][@"Description"]];
        tempView.productID             = array[i][@"ProductID"];
        
        NSString *imageURLString = [array[i][@"ProductImage"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
        NSURL    *imageURL       = [SkinLabHttpClient getImageURL:imageURLString];
        [tempView.imageView setImageWithURL:imageURL];
        
        [self.productView addSubview:tempView];

    }
    self.productView.contentSize = CGSizeMake((kScreenWidth - 30) * array.count, 100);
    
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeHandle) userInfo:nil repeats:YES];
}

- (void)timeHandle{
    if (self.productView.contentOffset.x + kScreenWidth - 30 < self.productView.contentSize.width) {
        [self.productView setContentOffset:CGPointMake(self.productView.contentOffset.x + kScreenWidth - 30, 0) animated:YES];
    }else{
        [self.productView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}


- (void)setupQuickSearchLabel {
    
    if (self.searchClassArray != nil) {
        
        NSMutableArray *classArray = [NSMutableArray array];
        [classArray addObject:self.searchClassArray[0][@"basicType"]];
        
        for (int i = 0; i < self.searchClassArray.count; i++) {
            if (i != self.searchClassArray.count - 1) {
                if (![self.searchClassArray[i][@"basicType"] isEqualToString:self.searchClassArray[i + 1][@"basicType"]]) {
                    [classArray addObject:self.searchClassArray[i + 1][@"basicType"]];
                }
            }
        }
        
        UIView *tempType = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 40)];
        self.typeView = tempType;
        [self.view addSubview:self.typeView];
        
        UILabel *searchTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 20)];
        searchTextLabel.backgroundColor = [UIColor clearColor];
        searchTextLabel.textColor       = GreenColor;
        searchTextLabel.text            = @"快速搜索:";
        searchTextLabel.font            = [UIFont systemFontOfSize:13];
        [self.typeView addSubview:searchTextLabel];
        
        for (int i = 0; i < classArray.count/3; i++) {
            
            UIView *typeViewBack = [[UIView alloc] initWithFrame:CGRectMake(70, 20 * i, 235, 20)];
            typeViewBack.tag = 200 + i;
            [self.typeView addSubview:typeViewBack];
            
            for (int j = 0; j < 3; j++) {
                TextLabelView *quickSearchLabel  = [[TextLabelView alloc] initWithFrame:CGRectMake(80 * j, 0, 70, 20)];
                quickSearchLabel.textLabel.text  = classArray[i * 3 + j];
                quickSearchLabel.textLabel.backgroundColor = [UIColor clearColor];
                quickSearchLabel.textLabel.textAlignment   = UITextAlignmentCenter;
                quickSearchLabel.textLabel.textColor = GreenColor;
                quickSearchLabel.textLabel.font      = [UIFont systemFontOfSize:13];
                quickSearchLabel.delegate = self;
                quickSearchLabel.tag   = i;
                quickSearchLabel.alpha = 0;
                [typeViewBack insertSubview:quickSearchLabel belowSubview:self.quickSearchView];
                
                [UIView animateWithDuration:0.25 animations:^{
                    quickSearchLabel.alpha = 1;
                }];
            }
        }
     
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(90, 20, 215, 50)];
        self.subTypeView = subView;
        self.subTypeView.backgroundColor     = [UIColor whiteColor];
        self.subTypeView.layer.masksToBounds = YES;
        self.subTypeView.layer.cornerRadius  = 5;
        self.subTypeView.alpha = 0;
        [self.typeView addSubview:self.subTypeView];
        
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(105 * j, 25 * i, 105, 25)];
                [button setTitleColor:GreenColor forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.tag = i * 2 + j;
                [button addTarget:self action:@selector(subTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.subTypeView addSubview:button];
            }
        }
        
    }

}

- (void)setupSubTypeView:(NSArray *)array {
    
    for (UIView *view in [self.subTypeView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            TextLabelView *quickSearchLabel  = [[TextLabelView alloc] initWithFrame:CGRectMake(120 * j, 20 * i, 120, 20)];
            quickSearchLabel.textLabel.text  = array[i * 3 + j];
            quickSearchLabel.textLabel.backgroundColor = [UIColor clearColor];
            quickSearchLabel.textLabel.textAlignment   = UITextAlignmentCenter;
            quickSearchLabel.textLabel.textColor = GreenColor;
            quickSearchLabel.textLabel.font      = [UIFont systemFontOfSize:13];
            quickSearchLabel.delegate = self;
            quickSearchLabel.tag   = i * 3 + j;
            
            [self.typeView insertSubview:quickSearchLabel belowSubview:self.quickSearchView];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.subTypeView.alpha = 1;
    }];
    
}

- (void)showQuickSearchView:(BOOL)show {
   
    if (show) {
        [UIView animateWithDuration:0.25 animations:^{
            self.quickSearchView.alpha = 1;
            self.typeView.alpha        = 0;
        } completion:^(BOOL finished) {
            [self searchTextDidChanged:@""];
        }];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            self.quickSearchView.alpha = 0;
            self.typeView.alpha        = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showNewFeaturesView {
    
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion   = infoDict[@"CFBundleVersion"];
    NSString *showVersion  = [[NSUserDefaults standardUserDefaults] stringForKey:@"ShowNewView"];
    
    if (![nowVersion isEqualToString:showVersion]) {
        NSArray *imageNameArray = @[@"新功能1", @"新功能2", @"新功能3", @"新功能4"];
        NewFeaturesViewController *newFeaturesViewController = [[NewFeaturesViewController alloc] initWithNibName:@"NewFeaturesViewController" bundle:nil];
        [newFeaturesViewController setNewFeatruesImageArray:imageNameArray imageType:@"jpg"];
        [self presentModalViewController:newFeaturesViewController animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setValue:nowVersion forKey:@"ShowNewView"];
    }
    
}

- (NSMutableArray *)handleSkinTypeArray:(NSArray *)array {
    
    NSMutableArray *classArray = [NSMutableArray array];
    [classArray addObject:array[0][@"basicType"]];
    
    for (int i = 0; i < array.count; i++) {
        if (i != array.count - 1) {
            if (![array[i][@"basicType"] isEqualToString:array[i + 1][@"basicType"]]) {
                [classArray addObject:array[i + 1][@"basicType"]];
            }
        }
    }
    NSMutableArray *typeArray = [NSMutableArray array];
    
    for (NSString *basicType in classArray) {
        
        NSMutableArray *subTypeArray = [NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            if ([dic[@"basicType"] isEqualToString:basicType]) {
                [subTypeArray addObject:dic];
            }
        }
        
        NSDictionary *typeDic = @{@"basicType": basicType, @"subType": subTypeArray};
        [typeArray addObject:typeDic];
    }
    
    return typeArray;
}

#pragma mark - ButtonClicked

- (IBAction)rightBarButtonClicked:(UIButton *)sender {
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (IBAction)leftBarButtonClicked:(UIButton *)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

- (IBAction)weeklyButtonClicked:(UIButton *)sender {
    
    WeeklyListViewController *weeklyListViewController = [[WeeklyListViewController alloc] initWithNibName:@"WeeklyListViewController" bundle:nil];
    [self.navigationController pushViewController:weeklyListViewController animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.weeklyBadge.alpha = 0;
    }];
    
}


- (IBAction)subTypeButtonClicked:(UIButton *)sender {
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    [self touchViewTouched:nil];
    
    self.searchView.searchField.text = sender.titleLabel.text;
    [self searchButtonDidTouched:sender.titleLabel.text];
    
    [MobClick event:@"QuickSearch" label:sender.titleLabel.text];
    
}


- (void)moreSearchViewTouched {
    [self.searchView cancelButtonClicked:nil];
}

- (IBAction)touchViewTouched:(id)sender{
    
    self.touchViewTop.alpha    = 0;
    self.touchViewBottom.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in [self.typeView subviews]) {
            if (view.tag == 201) {
                CGRect rect = view.frame;
                rect.origin.y = 20;
                view.frame = rect;
            }else if (view.tag == 200) {
                CGRect rect = view.frame;
                rect.origin.y = 0;
                view.frame = rect;
            }else{
                self.subTypeView.alpha = 0;
                
                CGRect rect = view.frame;
                rect.origin.y = 0;
                view.frame = rect;
            }
        }
        
        CGRect rect = self.contentView.frame;
        rect.origin.y = 100;
        self.contentView.frame = rect;
    }];
    
    CGRect rect = self.typeView.frame;
    rect.size.height    = 40;
    self.typeView.frame = rect;
    
}

#pragma mark - httpRequest

- (void)httpRequestSearchClass {
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSearchClass]
                                    parameters:@{@"": @""}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                      options:NSJSONReadingMutableLeaves
                                                                                                        error:nil];
                                           
                                           self.searchClassArray = dataArray;
                                           [self setupQuickSearchLabel];
                                           
                                           [AppHelper shareHelper].dataCenter.classArray = [self handleSkinTypeArray:dataArray];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
    
}

- (void)httpRequestProductInfoByBarCode:(NSString *)barCode {
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSearchByQRCode]
                                    parameters:@{@"BarCode": barCode}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];
                                           
                                           DLog(@"%@", dataArray)
                                           
                                           if ([IOHelper isNull:operation.responseString]) {
                                               [self.qrSearchViewController showUpdateView:YES];
                                           }else{
                                               RecommendDetailViewController *recommendDetailViewController = [[RecommendDetailViewController alloc] initWithNibName:@"RecommendDetailViewController" bundle:nil];
                                               recommendDetailViewController.recommendDetailViewMode        = RecommendDetailViewModeWithNav;
                                               [recommendDetailViewController setProductInfoByID:dataArray[0][@"productID"]];
                                               [self.navigationController pushViewController:recommendDetailViewController animated:YES];
                                               
                                               [self.qrSearchViewController dismissModalViewControllerAnimated:YES];
                                           }
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
}

- (void)httpRequestBranch {
    
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSearchBrands]
                                    parameters:@{@"": @""}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];
                                           if (![IOHelper isNull:dataArray]) {
                                               
                                               self.braedsListArray = [dataArray sortedArrayUsingFunction:brandsSort context:NULL];
                                               [IOHelper writeToFileAsyn:self.braedsListArray withFileName:@"BreadsList.plist"];
                                               
                                           }
                                           DLog(@" %d", dataArray.count)
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"%@",error);
                                       }];
    
}

- (void)httpRequestWeeklyData {
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeWeeklyData]
                                    parameters:@{@"id": @""}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                     options:NSJSONReadingMutableLeaves
                                                                                                       error:nil];
                                           [AppHelper shareHelper].dataCenter.weeklyArray = dataArray;
                                           
                                           NSDictionary *weeklyDic = dataArray[dataArray.count - 1];
                                           
                                           if (![[AppHelper shareHelper].dataCenter isWeeklyRead:weeklyDic[@"JID"]]) {
                                               [UIView animateWithDuration:0.25 animations:^{
                                                   self.weeklyBadge.alpha = 1;
                                               }];
                                           }
                                           
                                           
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           DLog(@"%@",error);
                                           
                                       }];
}

NSInteger brandsSort(id user1, id user2, void *context)
{
    NSString *u1,*u2;
    u1 = (NSString *)(user1[@"productBrand"]);
    u2 = (NSString *)(user2[@"productBrand"]);
    return  [u1 localizedCompare:u2];
}

#pragma mark - SearchViewDelegate

- (void)searchFieldDidTouched {
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [self showQuickSearchView:YES];
}

- (void)searchButtonDidTouched:(NSString *)keyWord {
    
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchViewController.keyWord    = self.searchView.searchField.text;
    searchViewController.searchMode = SearchModeNommal;
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}

- (void)cancelButtonDidTouched {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showQuickSearchView:NO];
}

- (void)searchTextDidChanged:(NSString *)text{
    
    if (!_isQuickSearch) {
        NSString       *keyName       = @"productBrand";
        NSMutableArray *filteredArray = nil;
        
        if ([text isEqualToString:@""] || text == nil) {
            
            filteredArray = [NSMutableArray arrayWithArray:self.braedsListArray];
            
        }else{
            /**< 模糊查找*/
            NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyName, text];
            /**< 精确查找*/
            //  NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K == %@", keyName, searchText];
            
            filteredArray = [NSMutableArray arrayWithArray:[self.braedsListArray filteredArrayUsingPredicate:predicateString]];
        }
        
        static NSString *const CellIdentifier = @"PhotoCell";
        
        ArrayDataSource *temp = [[ArrayDataSource alloc] initWithItems:filteredArray
                                                        cellIdentifier:CellIdentifier
                                                    configureCellBlock:^(id cell, id item) {
                                                        
                                                        UITableViewCell *tempCell = cell;
                                                        tempCell.textLabel.text   = item[@"productBrand"];
                                                        tempCell.textLabel.textColor = GreenColor;
                                                        tempCell.textLabel.font      = [UIFont systemFontOfSize:18];
                                                        tempCell.selectionStyle      = UITableViewCellSeparatorStyleNone;
                                                        
                                                    }];
        self.brandTableDataSource = temp;
        
        if (self.brandTableDelegate == nil) {
            
            ArrayDelegate *temp = [[ArrayDelegate alloc] initWithHeight:KCellheight
                                                       cellClickedBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                                                           UITableViewCell *tempCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                                                           self.searchView.searchField.text  = tempCell.textLabel.text;
                                                           [self searchButtonDidTouched:tempCell.textLabel.text];
                                                           
                                                           DLog(@"%@", tempCell.textLabel.text)
                                                       }];
            self.brandTableDelegate = temp;
            
        }
        
        self.searchTypeTableView.dataSource = self.brandTableDataSource;
        self.searchTypeTableView.delegate   = self.brandTableDelegate;
        [self.searchTypeTableView reloadData];

    }

}

#pragma mark - QuestionnaireViewControllerDelegate

- (void)questionnaireDidFinished:(NSDictionary *)dic {
    
    DLog(@"测试完成 %@", dic);
    [AppHelper shareHelper].dataCenter.testResultArray = dic;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[IOHelper getStringWithVersion:@"test"]];
    [IOHelper writeToFileAsyn:dic withFileName:@"testResult.plist"];
    
    ResultViewController *userCenterViewController = [[ResultViewController alloc] init];
    userCenterViewController.showDescription = YES;
    [self.navigationController pushViewController:userCenterViewController animated:NO];
}

#pragma mark - TextLabelViewDelagate

- (void)textLabelViewDidTouched:(TextLabelView *)textLabelView {
    
    self.touchViewTop.alpha    = 1;
    self.touchViewBottom.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (textLabelView.tag == 0) {
            for (UIView *view in [self.typeView subviews]) {
                if (view.tag == 201) {
                    CGRect rect = view.frame;
                    rect.origin.y = 20 + 50;
                    view.frame = rect;
                }else if (view.tag == 200) {
                    CGRect rect = view.frame;
                    rect.origin.y = 0;
                    view.frame = rect;
                }else{
                    CGRect rect = view.frame;
                    rect.origin.y = 20;
                    view.frame = rect;
                }
            }
        }else{
            for (UIView *view in [self.typeView subviews]) {
                if (view.tag == 201) {
                    CGRect rect = view.frame;
                    rect.origin.y = 20;
                    view.frame = rect;
                }else if (view.tag == 200) {
                    CGRect rect = view.frame;
                    rect.origin.y = 0;
                    view.frame = rect;
                }else{
                    CGRect rect = view.frame;
                    rect.origin.y = 40;
                    view.frame = rect;
                }
            }
        }

        self.subTypeView.alpha = 1;
    }];
    
    CGRect rect = self.typeView.frame;
    rect.size.height = 40 + 50;
    self.typeView.frame    = rect;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.contentView.frame;
        rect.origin.y = 100 + 50;
        self.contentView.frame = rect;
    }];
    
    NSArray *array = [AppHelper shareHelper].dataCenter.classArray;
    
    for (NSDictionary *dic in array) {
        if ([dic[@"basicType"] isEqualToString:textLabelView.textLabel.text]) {
            DLog(@"%@", dic)
            NSArray *subArray = dic[@"subType"];
            
            for (UIButton *button in [self.subTypeView subviews]) {
                if (button.tag < subArray.count) {
                    [button setTitle:subArray[button.tag][@"subType"] forState:UIControlStateNormal];
                }else{
                    [button setTitle:@"" forState:UIControlStateNormal];
                }
                
            }
            
        }
    }

}

#pragma mark - ZBarReaderDelegate

- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    [self httpRequestProductInfoByBarCode:symbol.data];
    
    NSString *productID = [NSString stringWithFormat:@"%@ByQR", @"test"];
    [MobClick event:@"productview" label:productID];
    
    DLog(@"%@", symbol.data)
}

#pragma mark - RecommendViewDelegate

- (void)recommendViewDidClicked:(NSString *)productID{
    
    ResultViewController *userCenterViewController = [[ResultViewController alloc] init];
    userCenterViewController.productID = productID;
    [self.navigationController pushViewController:userCenterViewController animated:YES];
    
    DLog(@"%@", productID)

}

@end
