//
//  FavoritesViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-20.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "FavoritesViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define KSNTHeight 113
#define KSTHeight 69

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationController];
    
    BCLSegmentControl *tempTopSement = [[BCLSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.topSement = tempTopSement;
    [self.topSement setButtonNumbers:2];
    [self.topSement setDelegate:self];
    [self.topSement setTitle:@"想用" atIndex:0 seleted:NO];
    [self.topSement setTitle:@"在用" atIndex:1 seleted:NO];
    [self.topSement setSegmentDefaultIndex:0];
    [self.view addSubview:self.topSement];
    
    self.productArray = [DataCenter shareData].wantArray;
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - KSNHeight - 40)];
    self.tableView = tempTableView;
    self.tableView.backgroundColor = GrayColor;
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor  = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    UILabel *tempTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    self.textLabel = tempTextLabel;
    self.textLabel.center          = CGPointMake(kScreenWidth/2, (kScreenHeight - KSNHeight)/2);
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment   = UITextAlignmentCenter;
    self.textLabel.textColor       = BlackColor;
    self.textLabel.font            = [UIFont boldSystemFontOfSize:15];
    self.textLabel.numberOfLines   = 2;
    self.textLabel.text            = @"没有收藏哦，赶快去浏览美肤周刊或测试一下自己的皮肤类型吧！";
    [self.view addSubview:self.textLabel];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadTable];
    [MobClick event:@"favoritesview"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationController{
    
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

- (void)reloadTable{
    
    [UIView animateWithDuration:0.1 animations:^{
        if (self.productArray.count == 0) {
            self.textLabel.alpha = 1;
        }else{
            self.textLabel.alpha = 0;
        }
    }];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FavoriteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FavoriteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    
    if (cell.menuButton.selected) {
        [cell menuButtonClicked:cell.menuButton animated:NO];
    }
    
    NSDictionary *cellDataDic = self.productArray[indexPath.row];
    
    NSURL    *imageURL;
    NSString *productName;
    NSString *productBrand;
    NSString *productInfo;
    NSString *productEffect;
    
    if (![DataCenter isNull:cellDataDic[@"productImage"]]) {
        NSString *imageURLString = [cellDataDic[@"productImage"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
        imageURL = [SkinLabHttpClient getImageURL:imageURLString];
    }else{
        imageURL = nil;
    }
    
    if (![DataCenter isNull:cellDataDic[@"productName"]]) {
        productName = cellDataDic[@"productName"];
    }else{
        productName = @"";
    }
    
    if (![DataCenter isNull:cellDataDic[@"productBrand"]]) {
        productBrand = cellDataDic[@"productBrand"];
    }else{
        productBrand = @"";
    }
    
    if (![DataCenter isNull:cellDataDic[@"produtEffect"]]) {
        NSString *produtEffectString = [cellDataDic[@"produtEffect"] stringByReplacingOccurrencesOfString:@"@@" withString:@","];
        productEffect = [NSString stringWithFormat:@"效果：%@", produtEffectString];
    }else{
        productEffect = @"";
    }
    
    if (![DataCenter isNull:cellDataDic[@"productType"]]) {
        productInfo = [NSString stringWithFormat:@"产品类型：%@  %@", cellDataDic[@"productType"], productEffect];
    }else{
        productInfo = @"";
    }
    
    cell.index     = indexPath.row;
    cell.taobaoURL = cellDataDic[@"productURL"];
    cell.productName.text  = productName;
    cell.productBrand.text = productBrand;
    cell.productInfo.text  = productInfo;
    
    [cell.productImage setImageWithURL:imageURL];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendDetailViewController *recommendDetailViewController = [[RecommendDetailViewController alloc] initWithNibName:@"RecommendDetailViewController" bundle:nil];
    recommendDetailViewController.recommendDetailViewMode = RecommendDetailViewModeWithNav;
    [recommendDetailViewController setProductInfoByID:[DataCenter shareData].wantArray[indexPath.row][@"productID"]];
    [self.navigationController pushViewController:recommendDetailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - FavoriteViewCellDelegate

- (void)buyButtonDidClicked:(FavoriteViewCell *)cell{
    
}

- (void)shareButtonDidClicked:(FavoriteViewCell *)cell{
    
}

- (void)deleteButtonDidClicked:(FavoriteViewCell *)cell{
    [self.tableView beginUpdates];
    
    if (self.topSement.index == 0) {
        [[DataCenter shareData] deleteFromMyWantAtIndex:cell.index];
        self.productArray = [DataCenter shareData].wantArray;
    }else{
        [[DataCenter shareData] deleteFromMyUsingAtIndex:cell.index];
        self.productArray = [DataCenter shareData].usingArray;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:1];
}

#pragma mark - BCLSegmentControlDelegate

- (void)segmentValueChanged:(NSInteger)index {
    
    if (index == 0) {
        self.productArray = [DataCenter shareData].wantArray;
    }else{
        self.productArray = [DataCenter shareData].usingArray;
    }
    
    [self reloadTable];
}

@end
