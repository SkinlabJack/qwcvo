//
//  WeeklyViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-17.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "WeeklyViewController.h"
#import <mach/mach_time.h>

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define KSNTHeight 113
#define KSTHeight  69

@interface WeeklyViewController ()

@end

@implementation WeeklyViewController


- (void)dealloc
{
    DLog(@"WeeklyViewController dealloc")
    
    
    self.activityView.delegate = nil;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _scroollTag = 100;
        _backing    = NO;
        
        _indexWeeklyArray  = [[NSMutableArray alloc] init];
        _branchWeeklyArray = [[NSMutableArray alloc] init];
        _changeableViewDic = [[NSMutableDictionary alloc] init];;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GreenColor;
    [self setupNavigationController];
    
    UISwipeGestureRecognizer *oneFingerSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipe:)];
    oneFingerSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    oneFingerSwipe.delegate  = self;
    [self.view addGestureRecognizer:oneFingerSwipe];
    
    self.pageStringArray = [self.weeklyDic[@"JournalContentRelation"] componentsSeparatedByString:@"@@"];
    
    [self separatePageArray:[self analysisWeeklyData:self.weeklyDic]];
    [self setWeeklyView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginEvent:@"weeklyreaddetail" label:self.weeklyDic[@"JournalTitle"]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endEvent:@"weeklyreaddetail" label:self.weeklyDic[@"JournalTitle"]];
}

- (void)setupNavigationController{
    
    if (![AppHelper shareHelper].appCenter.isiOS7) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }
    
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        if ([AppHelper shareHelper].appCenter.isiOS7) {
            UIButton *tempTeftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20 + 7.5, 50, 30)];
            self.leftButton = tempTeftButton;
        }else{
            UIButton *tempTeftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7.5, 50, 30)];
            self.leftButton = tempTeftButton;
        }
        
        [self.leftButton setImage:[UIImage imageNamed:@"透明返回"] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.leftButton];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)leftBarButtonClicked:(id)sender{
    
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)oneFingerSwipe:(UISwipeGestureRecognizer *)recognizer {
    
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    if (scrollView.contentOffset.x == 0) {
        if (![AppHelper shareHelper].appCenter.isiPhone5) {

            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)hideHelp:(UIButton *)sender{
    [sender removeFromSuperview];
}

#pragma mark - WeeklyView

- (void)setWeeklyView{
    
    UIScrollView *scrollView = [self creatWeeklyScrollView:self.indexWeeklyArray[0] withTag:++_scroollTag];
    if (_leftButton == nil) {
        [self.view addSubview:scrollView];
    }else{
        [self.view insertSubview:scrollView belowSubview:_leftButton];
    }
    
    [self addActivityViewWithTag:1];
    
}

- (void)setBranchedWeeklyView:(NSArray *)branchedweeklyData{
    [self separatePageArray:branchedweeklyData];
    
    UIScrollView *scrollView = [self creatWeeklyScrollView:self.indexWeeklyArray[_scroollTag - 100] withTag:++_scroollTag];
    scrollView.center = CGPointMake(kScreenWidth + kScreenWidth/2, scrollView.center.y);
    
    if (_leftButton == nil) {
        [self.view addSubview:scrollView];
    }else{
        [self.view insertSubview:scrollView belowSubview:_leftButton];
    }
    
    [self addActivityViewWithTag:2];
    
}

- (void)addActivityViewWithTag:(int)tag{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WeeklyFirstLaunch"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WeeklyFirstLaunch"];
//        UIButton *helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 504)];
//        [helpButton setImage:[UIImage imageNamed:@"用户引导周刊"] forState:UIControlStateNormal];
//        [helpButton setImage:[UIImage imageNamed:@"用户引导周刊"] forState:UIControlStateHighlighted];
//        [helpButton addTarget:self action:@selector(hideHelp:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:helpButton];
//        [helpButton release];
//    }
    
    ActivityView *tempActivityView = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.activityView = tempActivityView;
    self.activityView.delegate = self;
    self.activityView.tag = tag;
    
    if (_leftButton == nil) {
        [self.view addSubview:self.activityView];
    }else{
        [self.view insertSubview:self.activityView belowSubview:_leftButton];
    }
}


- (NSArray *)analysisWeeklyData:(NSDictionary *)weeklyData{
    
    NSMutableArray *pageArrayEdited = [NSMutableArray array];
    NSArray *pageArray;
    
    if ([weeklyData[@"JournalContent"] isEqual:[NSNull null]]) {
        pageArray = nil;
    }else{
        pageArray = weeklyData[@"JournalContent"];
    }
    
    for (NSString *pageString in self.pageStringArray) {
        
        NSMutableDictionary *onePageDic = [NSMutableDictionary dictionary];
        NSMutableArray *scrollViewArray = [NSMutableArray array];
        NSMutableArray *otherViewArray  = [NSMutableArray array];
        
        for (int i = 0; i < pageArray.count; i++) {
            
            NSDictionary *pageDic = pageArray[i];
            NSString *page = [pageDic[@"page"] componentsSeparatedByString:@"@@"][0];
            
            if ([page isEqualToString:pageString]) {
                
                if ([pageDic[@"layer"] isEqualToString:@"0"]) {
                    
                    onePageDic[@"BackGround"] = pageDic;
                    
                }else{
                    
                    NSRange range = [pageDic[@"page"] rangeOfString:@"scrollview"];
                    if (range.location == NSNotFound) {
                        [otherViewArray addObject:pageDic];
                    }else{
                        [scrollViewArray addObject:pageDic];
                    }
                    
                }
            }
        }
        
        onePageDic[@"ScrollView"] = scrollViewArray;
        onePageDic[@"OtherView"] = otherViewArray;
        
        [pageArrayEdited addObject:onePageDic];
    }
    
    return pageArrayEdited;
}

- (void)separatePageArray:(NSArray *)pageArray{
    
    NSMutableArray *indexPageArray     = [NSMutableArray array];
    NSMutableDictionary *branchPageDic = [NSMutableDictionary dictionary];
    NSArray *branchPageNameArray = @[];
    int index = 0;
    
    for (NSDictionary *dic in pageArray) {
        NSString *buttonEffect = dic[@"BackGround"][@"buttonEffect"];
        NSArray  *buttonEffectArray = [buttonEffect componentsSeparatedByString:@"@@"];
        
        NSString *type = buttonEffectArray[0];
        
        if (![type isEqualToString:@"Crossroad"]) {
            [indexPageArray addObject:dic];
            index++;
        }else{
            branchPageNameArray = [buttonEffectArray[1] componentsSeparatedByString:@"$$"];
            [indexPageArray addObject:dic];
            index++;
            break;
        }
    }
    
    
    for (int i = 0; i < branchPageNameArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (; index < pageArray.count; index++) {
            if ([pageArray[index][@"BackGround"][@"page"] isEqualToString:branchPageNameArray[i]]) {
                [array addObject:pageArray[index]];
            }else{
                
                if (i < branchPageNameArray.count - 1) {
                    if (![pageArray[index][@"BackGround"][@"page"] isEqualToString:branchPageNameArray[i + 1]]) {
                        [array addObject:pageArray[index]];
                    }else{
                        branchPageDic[branchPageNameArray[i]] = array;
                        break;
                    }
                }else{
                    [array addObject:pageArray[index]];
                    branchPageDic[branchPageNameArray[i]] = array;
                }
            }
        }
    }
        
    [self.indexWeeklyArray addObject:indexPageArray];
    [self.branchWeeklyArray addObject:branchPageDic];
    
}

- (UIScrollView *)creatWeeklyScrollView:(NSArray *)array withTag:(int)tag{
    
    UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    subScrollView.pagingEnabled = YES;
    subScrollView.showsHorizontalScrollIndicator = NO;
    subScrollView.delegate = self;
    subScrollView.tag = tag;
    
    for (int i = 0; i < array.count; i++) {
        UIView *onePage = [self creatWeeklyPage:array[i]];
        onePage.frame = CGRectMake(320 * i, 0, kScreenWidth, kScreenHeight);
        onePage.tag = 300 + i;
        [subScrollView addSubview:onePage];
    }
    
    if (array.count == 1) {
        subScrollView.contentSize = CGSizeMake(kScreenWidth + 0.5, kScreenHeight);
    }else{
        subScrollView.contentSize = CGSizeMake(kScreenWidth * array.count, kScreenHeight - 20);
    }
    
    return subScrollView;
}


- (UIView *)creatWeeklyPage:(NSDictionary *)dic{
    
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    NSDictionary *backGroundDic   = dic[@"BackGround"];
    NSDictionary *scrollViewArray = dic[@"ScrollView"];
    NSDictionary *otherViewArray  = dic[@"OtherView"];
    
    //    设置周刊当前页背景
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, [backGroundDic[@"width"] floatValue], [backGroundDic[@"height"] floatValue])];
    [backGroundImage setImageWithURL:[SkinLabHttpClient getImageURL:backGroundDic[@"imageURL"]]];
    [pageView addSubview:backGroundImage];
    
    for (NSDictionary *otherDic in otherViewArray) {
        
        float x = [otherDic[@"x"] floatValue];
        float y = [otherDic[@"y"] floatValue];
        float width  = [otherDic[@"width"] floatValue];
        float height = [otherDic[@"height"] floatValue];
        
        if ([otherDic[@"isButton"] isEqualToString:@"0"]) {
            
            //            设置不含交互的周刊SubView
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [imageView setImageWithURL:[SkinLabHttpClient getImageURL:otherDic[@"imageURL"]]];
            [pageView addSubview:imageView];
            
        }else if([otherDic[@"isButton"] isEqualToString:@"1"]) {
            
            //            设置含有交互的周刊SubView
            NSArray *buttonEffectArray = [otherDic[@"buttonEffect"] componentsSeparatedByString:@"@@"];
            
            WeeklyImageView *imageView = [[WeeklyImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [imageView setImageWithURL:[SkinLabHttpClient getImageURL:otherDic[@"imageURL"]]];
            imageView.delegate = self;
            
            if (![IOHelper isNull:otherDic[@"name"]]) {
                NSArray *nameArray = [otherDic[@"name"] componentsSeparatedByString:@"$$"];
                (self.changeableViewDic)[nameArray[1]] = imageView;
            }
            
            //            处理放大缩小点击事件
            if ([buttonEffectArray[0] isEqualToString:@"Zoom"]) {
                
                float zoomTimes = [buttonEffectArray[1] floatValue];
                CGRect rect = CGRectMake(imageView.frame.origin.x - width/2 * (zoomTimes - 1), imageView.frame.origin.y - height/2 * (zoomTimes - 1), width * zoomTimes, height * zoomTimes);
                
                [imageView setTapGestureType:WeeklyImageTypeZoom];
                imageView.zoomRect = rect;
                
                //                处理加载产品推荐点击事件
            }else if ([buttonEffectArray[0] isEqualToString:@"Search"]) {
                
                for (NSString *keyWord in buttonEffectArray) {
                    
                    NSArray  *keyArray = [keyWord componentsSeparatedByString:@"||"];
                    if ([keyArray[0] isEqualToString:@"with"]) {
                        imageView.withKey = keyArray[1];
                    }else if ([keyArray[0] isEqualToString:@"without"]) {
                        imageView.withOutKey = keyArray[1];
                    }else if ([keyArray[0] isEqualToString:@"type"]){
                        imageView.productType = keyArray[1];
                    }
                }
                
                [imageView setTapGestureType:WeeklyImageTypeSearch];
                
                //                处理弹出View点击事件
            }else if ([buttonEffectArray[0] isEqualToString:@"PopUp"]) {
                
                [imageView setTapGestureType:WeeklyImageTypePopUp];
                imageView.viewName = buttonEffectArray[1];
                
            }else if ([buttonEffectArray[0] isEqualToString:@"HiddenPop"]) {
                
                [imageView setTapGestureType:WeeklyImageTypeHiddenPop];
                imageView.alpha = 0;
                
                //                处理更换图片点击事件
            }else if ([buttonEffectArray[0] isEqualToString:@"Exchange"]) {
                
                [imageView setTapGestureType:WeeklyImageTypeExchange];
                imageView.viewName = buttonEffectArray[1];
                
            }else if ([buttonEffectArray[0] isEqualToString:@"Hidden"]) {
                
                [imageView setTapGestureType:WeeklyImageTypeExchange];
                imageView.viewName = buttonEffectArray[1];
                imageView.alpha = 0;
                
                //                处理分支页面点击事件
            }else if ([buttonEffectArray[0] isEqualToString:@"Jump"]){
                
                if (![IOHelper isNull:buttonEffectArray[1]]) {
                    
                    [imageView setTapGestureType:WeeklyImageTypeJump];
                    imageView.viewName = buttonEffectArray[1];
                    
                }
                
            }else{
                
            }
            
            [pageView addSubview:imageView];
        }
    }
    
    //    设置周刊当前页ScrollView
    if (scrollViewArray.count != 0) {
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.pagingEnabled = YES;
        pageScrollView.contentSize   = CGSizeMake(kScreenWidth * scrollViewArray.count, kScreenHeight);
        pageScrollView.bounces       = NO;
        [pageView addSubview:pageScrollView];
        
        for (NSDictionary *scrollDic in scrollViewArray) {
            NSArray *tempArray = [scrollDic[@"page"] componentsSeparatedByString:@"@@"];
            int index = [[tempArray[1] substringFromIndex:10] intValue];
            float x = [scrollDic[@"x"] floatValue] + index * 320;
            float y = [scrollDic[@"y"] floatValue];
            float width = [scrollDic[@"width"] floatValue];
            float height = [scrollDic[@"height"] floatValue];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [imageView setImageWithURL:[SkinLabHttpClient getImageURL:scrollDic[@"imageURL"]]];
            [pageScrollView addSubview:imageView];
        }
    }
    
    return pageView;
}

#pragma mark - WeeklyUX

- (void)jumpToBranch:(NSString *)page {
    [self setBranchedWeeklyView:self.branchWeeklyArray[_scroollTag - 101][page]];
}

- (void)jumpToSearchViewWith:(NSString *)withKey
                     withOut:(NSString *)withOutKey
                    withType:(NSString *)type{
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchViewController.searchMode     = SearchModeWithIngres;
    searchViewController.withKeyWord    = withKey;
    searchViewController.withOutKeyWord = withOutKey;
    searchViewController.type           = type;
    DLog(@"%@", type)
    
    [self.navigationController pushViewController:searchViewController animated:YES];
    
    
    NSString *event = self.weeklyDic[@"JournalTitle"];
    [MobClick event:@"weeklyproduct" label:event];
}

- (void)exchangeImage:(WeeklyImageView *)imageView toImageWithName:(NSString *)pageName {
    
    WeeklyImageView *weeklyImage = self.changeableViewDic[pageName];
    [UIView animateWithDuration:0.3 animations:^{
        weeklyImage.alpha = 1;
        imageView.alpha = 0;
    }];
    
}

- (void)popUpViewWithName:(NSString *)pageName{
    
    WeeklyImageView *weeklyImage = self.changeableViewDic[pageName];
    [UIView animateWithDuration:0.3 animations:^{
        weeklyImage.alpha = 1;
    }];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 101) {
        
        scrollView.bounces = NO;
        
    }else if (scrollView.tag == _scroollTag) {
        
        if (scrollView.contentOffset.x > 0) {
            scrollView.bounces = NO;
        }else{
            scrollView.bounces = YES;
        }
        
        if (scrollView.contentOffset.x < -50) {
            if (_backing == NO) {
                _backing = YES;
                [UIView animateWithDuration:0.35 animations:^{
                    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:_scroollTag];
                    scrollView.center = CGPointMake(kScreenWidth/2 + 320, scrollView.center.y);
                } completion:^(BOOL finished) {
                    [scrollView removeFromSuperview];
                    [self.indexWeeklyArray removeLastObject];
                    [self.branchWeeklyArray removeLastObject];
                    _scroollTag--;
                    _backing = NO;
                }];
            }
        }
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int _pageNumber = scrollView.contentOffset.x/kScreenWidth + 1;
    
    NSString *event = [NSString stringWithFormat:@"%d of %@", _pageNumber, self.weeklyDic[@"JournalTitle"]];
    [MobClick event:@"weeklyreadpage" label:event];

    DLog(@"%d", _pageNumber)
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - WeeklyImageViewDelegate

- (void)weeklyImageViewDidTaped:(WeeklyImageView *)weeklyImageView
                       withType:(WeeklyImageType)weeklyImageType {
    
    switch (weeklyImageType) {
        case WeeklyImageTypeZoom:{
            [UIView animateWithDuration:0.3 animations:^{
                weeklyImageView.frame  = weeklyImageView.zoomRect;
                weeklyImageView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            }];
            break;
        }
            
        case WeeklyImageTypePopUp:{
            [self popUpViewWithName:weeklyImageView.viewName];
            break;
        }
            
        case WeeklyImageTypeHiddenPop:{
            [UIView animateWithDuration:0.3 animations:^{
                weeklyImageView.alpha = 0;
            }];
            break;
        }
            
        case WeeklyImageTypeExchange:{
            [self exchangeImage:weeklyImageView
                toImageWithName:weeklyImageView.viewName];
            
            break;
        }
            
        case WeeklyImageTypeSearch:{
            [self jumpToSearchViewWith:weeklyImageView.withKey
                               withOut:weeklyImageView.withOutKey
                              withType:weeklyImageView.productType];
            break;
        }
            
        case WeeklyImageTypeJump:{
            [self jumpToBranch:weeklyImageView.viewName];
            break;
        }
            
        default:{
            break;
        }
            
    }
    
}

#pragma mark - ActivityViewDelegate

- (void)loadingDataDidFinished:(ActivityView *)activityView {
    [activityView removeFromSuperview];
    
    if (activityView.tag == 2) {
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:_scroollTag];
        [UIView animateWithDuration:0.35 animations:^{
            scrollView.center = CGPointMake(kScreenWidth/2, scrollView.center.y);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

CGFloat BNRTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
} // BNRTimeBlock

@end
