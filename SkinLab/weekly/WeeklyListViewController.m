//
//  WeeklyListViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-1-22.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "WeeklyListViewController.h"

@interface WeeklyListViewController ()

@end

@implementation WeeklyListViewController

- (void)dealloc
{
    DLog(@"WeeklyListViewController dealloc");
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _classedWeeklyArray = [[NSMutableArray alloc] init];
        _isTableViewShow    = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    [self setupNavigationController];
    [self setupStateLabelView];
    [self httpRequestWeeklyClass];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - WeeklyView

- (void)setupNavigationController{
    
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

- (IBAction)leftBarButtonClicked:(id)sender{
    if (!_isTableViewShow) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _isTableViewShow = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.alpha = 0;
        }];
    }
}


- (void)setupStateLabelView{
    
    self.stateLabel = [[StateLabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
//    self.stateLabel = tempTextLabel;
    self.stateLabel.center = CGPointMake(kScreenWidth/2, (kScreenHeight - KSNHeight)/2);
    [self.view addSubview:self.stateLabel];
    
    __weak typeof(self) blockSelf = self;
    [self.stateLabel addTapGesture:^(UILabel *label) {
        [blockSelf httpRequestWeeklyClass];
    }];
    
    [self.stateLabel setupStateLabel:StateLabelModeLoading];
    
}

- (void)setupMainView{
    
    if (![AppHelper shareHelper].appCenter.isiPhone5) {
        _topViewHeight = 160;
    }else{
        _topViewHeight = 200;
    }
    
    __weak typeof(self) blockSelf = self;
    
    ZKIButton *topButton = [[ZKIButton alloc] initWithFrame:CGRectMake(15, 15, 290, _topViewHeight - 30)];
    self.topView = topButton;
    self.topView.alpha = 0;
    [self.view addSubview:self.topView];
    
    [self.topView addTapBlock:^(NSString *keyID) {
        [blockSelf openWeekly:blockSelf.topLabel.text];
    }];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    topLabel.center = CGPointMake(300/2, _topViewHeight/2 - 30);
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment   = UITextAlignmentCenter;
    topLabel.textColor       = BlackColor;
    topLabel.font            = [UIFont boldSystemFontOfSize:20];
    topLabel.text            = @"最新专题";
    [self.topView.contentView addSubview:topLabel];
    
    UILabel *topNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
    self.topLabel = topNoteLabel;
    self.topLabel.center = CGPointMake(300/2, _topViewHeight/2);
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textAlignment   = UITextAlignmentCenter;
    self.topLabel.textColor       = TextGrayColor;
    self.topLabel.font            = [UIFont systemFontOfSize:16];
    [self.topView.contentView addSubview:self.topLabel];
    
    UIView *tempHotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    tempHotView.center = CGPointMake(300/2 - 60, _topViewHeight/2 - 30);
    tempHotView.backgroundColor = RedColor;
    tempHotView.layer.masksToBounds = YES;
    tempHotView.layer.cornerRadius  = 15;
    [self.topView.contentView addSubview:tempHotView];
    
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationRepeatCount:5];
        
        CGRect rect = tempHotView.frame;
        rect.size.height = rect.size.height * 1.5;
        rect.size.width  = rect.size.width  * 1.5;
        rect.origin.x    = rect.origin.x - 7.5;
        rect.origin.y    = rect.origin.y - 7.5;
        
        tempHotView.frame = rect;
        tempHotView.alpha = 0;
    }];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    hotLabel.center = CGPointMake(300/2 - 60, _topViewHeight/2 - 30);
    hotLabel.backgroundColor = [UIColor whiteColor];
    hotLabel.textAlignment   = UITextAlignmentCenter;
    hotLabel.textColor       = RedColor;
    hotLabel.text            = @"HOT";
    hotLabel.font            = [UIFont boldSystemFontOfSize:12];
    hotLabel.layer.masksToBounds = YES;
    hotLabel.layer.cornerRadius  = 15;
    hotLabel.layer.borderColor   = GreenColor.CGColor;
    hotLabel.layer.borderWidth   = 1;
    [self.topView.contentView addSubview:hotLabel];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, _topViewHeight, kScreenWidth, kScreenHeight - KSNHeight - _topViewHeight)];
    self.typeView = tempView;
    self.typeView.alpha = 0;
    [self.view addSubview:self.typeView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 290, 20)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textAlignment   = UITextAlignmentCenter;
    typeLabel.textColor       = GreenColor;
    typeLabel.text            = @"六大肌肤问题，分类查看美丽宝典";
    typeLabel.font            = [UIFont boldSystemFontOfSize:15];
    [self.typeView addSubview:typeLabel];
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
    self.tableView = tempTableView;
    self.tableView.backgroundColor = GrayColor;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.alpha           = 0;
    [self.view addSubview:self.tableView];
}


- (void)setupMainViewData:(NSArray *)classArray{
    
    if (self.typeView == nil) {
        [self setupMainView];
    }
    
    float height = (kScreenHeight - KSNHeight - _topViewHeight - 20 - 15 * 2 - 10)/2;
    __weak typeof(self) blockSelf = self;
    
    for (int i = 0; i < classArray.count/3; i++) {
        
        for (int j = 0; j < 3; j++) {
            
            NSArray *class = [classArray[i * 3 + j] componentsSeparatedByString:@"$$"];
            
            ZKIButton *weeklyButton = [[ZKIButton alloc] initWithFrame:CGRectMake(15 + 100 * j, 35 + (height + 10) * i, 90, height)];
            weeklyButton.imageView.image = [UIImage imageNamed:class[0]];
            weeklyButton.keyID           = class[0];
            [self.typeView addSubview:weeklyButton];
            
            [weeklyButton addTapBlock:^(NSString *keyID) {
                [blockSelf openWeekly:keyID];
                [ZKIAnalytics addNewAction:ZKIAnalyticsTypeWeekly withSubType:@"type" withKey:keyID];
            }];
            
        }
    }
    
    self.topView.keyID = classArray[classArray.count - 1];
    self.topLabel.text = classArray[classArray.count - 1];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.typeView.alpha = 1;
        self.topView.alpha  = 1;
        
        [self.stateLabel setupStateLabel:StateLabelModeHide];
    }];

}

- (void)showWeeklyView:(NSDictionary *)dic{
    
    WeeklyViewController *weeklyViewController = [[WeeklyViewController alloc] initWithNibName:@"WeeklyViewController" bundle:nil];
    weeklyViewController.weeklyDic = dic;
    [self.navigationController pushViewController:weeklyViewController animated:YES];
    
    [[AppHelper shareHelper].dataCenter markWeeklyRead:dic[@"JID"]];
    [self showNewWeeklyView];
    [self httpRequestWeeklyRead:dic[@"JID"]];
    
    [MobClick event:@"weeklyreaddetail" label:dic[@"JournalTitle"]];
}

- (void)showNewWeeklyView{
    for (UIView *view in [self.typeView subviews]) {
        if ([view isKindOfClass:[ZKIButton class]]) {
            ZKIButton *button = (ZKIButton *)view;
            [button showBadgeView:[self hasNewWeekly:button.keyID]];
        }
    }
    
    [self.topView showBadgeView:[self hasNewWeekly:self.topView.keyID]];
}

- (BOOL)hasNewWeekly:(NSString *)weeklyClass{
    
    for (int i = self.weeklyDataArray.count; i > 0 ; i--) {
        NSDictionary *weeklyDic = self.weeklyDataArray[i - 1];
        NSRange range = [weeklyDic[@"JournalType"] rangeOfString:weeklyClass];
        
        if (range.location != NSNotFound) {
            
            if ([[AppHelper shareHelper].dataCenter isWeeklyRead:weeklyDic[@"JID"]]) {
                return NO;
            }else{
                return YES;
            }
            
        }
    }
    return NO;
}

#pragma mark - httpRequest

//请求周刊分类类表
- (void)httpRequestWeeklyClass{
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeWeeklyClass]
                                    parameters:@{@"id": @""}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                   options:NSJSONReadingMutableLeaves
                                                                                                     error:nil];
                                           NSArray *classArray = [dataDic[@"propValue"] componentsSeparatedByString:@"@@"];
                                           self.classArray = classArray;
                                           
//                                           if ([AppHelper shareHelper].dataCenter.weeklyArray == nil) {
//                                               [self httpRequestWeeklyData];
//                                           }else{
//                                               self.weeklyDataArray = [AppHelper shareHelper].dataCenter.weeklyArray;
//                                               [self setupMainViewData:self.classArray];
//                                               [self showNewWeeklyView];
//                                           }
                                           
                                           [self httpRequestWeeklyData];
//                                           [self httpRequestTestWeeklyData];
                                           DLog(@"%@",self.classArray);
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self.stateLabel setupStateLabel:StateLabelModeNetworkingError];
                                           DLog(@"%@",error);
                                       }];
}

//请求周刊数据列表
- (void)httpRequestWeeklyData{
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeWeeklyData]
                                    parameters:@{@"id": @""}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];;
                                           self.weeklyDataArray = dataArray;
                                           [AppHelper shareHelper].dataCenter.weeklyArray = dataArray;
                                           
                                           [self setupMainViewData:self.classArray];
                                           [self showNewWeeklyView];

                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [self.stateLabel setupStateLabel:StateLabelModeNetworkingError];
                                           DLog(@"%@",error);
                                           
                                       }];
}

- (void)httpRequestTestWeeklyData{
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeWeeklyTestData]
                                    parameters:@{@"id": @""}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                                options:NSJSONReadingMutableLeaves
                                                                                                  error:nil];
                                           self.weeklyDataArray = dataArray;
                                           [AppHelper shareHelper].dataCenter.weeklyArray = dataArray;
                                           
                                           [self setupMainViewData:self.classArray];
                                           [self showNewWeeklyView];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           [self httpRequestWeeklyData];
                                           DLog(@"%@",error);
                                           
                                       }];
}

- (void)httpRequestWeeklyRead:(NSString *)journalID{
    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeWeeklyClicked]
                                    parameters:@{@"JournalID": journalID, @"Username": [AppHelper shareHelper].appCenter.deviceID}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                                           DLog(@"%@",error);
                                           
                                       }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classedWeeklyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WeeklyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WeeklyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic   = self.classedWeeklyArray[self.classedWeeklyArray.count - 1 - indexPath.row];
    if (![IOHelper isNull:dic[@"JournalTitle"]]) {
        cell.nameLabel.text = dic[@"JournalTitle"];
    }else{
        cell.nameLabel.text = @"";
    }
    
    if (![IOHelper isNull:dic[@"JournalSubTitle"]]) {
        cell.infoLabel.text = dic[@"JournalSubTitle"];
    }else{
        cell.infoLabel.text = @"";
    }
    
    if (![IOHelper isNull:dic[@"JournalCreationtime"]]) {
        cell.dateLabel.text = [CustomerMethod createDatelabel:dic[@"JournalCreationtime"] mode:DateModeDayAndMonth];
    }else{
        cell.dateLabel.text = @"";
    }
    
    
    int count = [dic[@"JournalClicked"] integerValue];
    cell.countLabel.text = [NSString stringWithFormat:@"%d次", count];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showWeeklyView:self.classedWeeklyArray[self.classedWeeklyArray.count - 1 - indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}


- (void)openWeekly:(NSString *)weeklyClass{
    DLog(@"%@", weeklyClass);
    
    for (int i = self.weeklyDataArray.count; i > 0 ; i--) {
        NSDictionary *weeklyDic = self.weeklyDataArray[i - 1];
        NSRange range = [weeklyDic[@"JournalType"] rangeOfString:weeklyClass];
        
        if (range.location != NSNotFound) {
            
            if ([[AppHelper shareHelper].dataCenter isWeeklyRead:weeklyDic[@"JID"]]) {
                
                [self ArrayWithClass:weeklyClass];
                [self.tableView reloadData];
                _isTableViewShow = YES;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.alpha = 1;
                }];

                break;
            }else{
                
                [self ArrayWithClass:weeklyClass];
                [self.tableView reloadData];
                _isTableViewShow = YES;
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.alpha = 1;
                } completion:^(BOOL finished) {
                    [self showWeeklyView:weeklyDic];
                }];
                
                break;
            }
            
        }
        
    }
    
    [MobClick event:@"weeklyreadclass" label:weeklyClass];
}

- (void)ArrayWithClass:(NSString *)weeklyClass{
    
    [self.classedWeeklyArray removeAllObjects];
    
    for (NSDictionary *weeklyDic in self.weeklyDataArray) {
        
        NSRange range = [weeklyDic[@"JournalType"] rangeOfString:weeklyClass];
        
        if (range.location != NSNotFound) {
            [self.classedWeeklyArray addObject:weeklyDic];
        }
    
    }
    
}

@end
