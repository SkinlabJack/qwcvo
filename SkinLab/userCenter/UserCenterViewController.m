//
//  UserCenterViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-4.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "UserCenterViewController.h"
#import "AppDelegate.h"


@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

- (void)dealloc
{
    DLog(@"LeftViewController dealloc")
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
        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = GrayColor;
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.contentInset    = UIEdgeInsetsMake(130, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    UserInfoView *userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, -130, kScreenWidth, 130)];
    [self.tableView addSubview:userInfoView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"升级" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)rightBarButtonClicked:(UIButton *)sender {
    NSDictionary *dic = @{@"ViewName": @"VIPMainView"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifierWithoutLine = @"WithoutLine";
    static NSString *CellIdentifier            = @"Cell";
    SettingViewCell *cell;
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"收藏夹";
        }else if (indexPath.row == 1) {
            cell.titleLabel.text = @"预约";
        }
        
    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"我的礼包";
        }else if (indexPath.row == 1) {
            cell.titleLabel.text = @"地址管理";
        }
        
    }else if (indexPath.section == 2) {
        
        if (indexPath.row != 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWithoutLine];
            if (cell == nil) {
                cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierWithoutLine];
            }
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"积分规则";
        }
        
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            FavoritesViewController *favoritesViewController = [[FavoritesViewController alloc] init];
            [self.navigationController pushViewController:favoritesViewController animated:YES];
        }
        
    }
    
    if (indexPath.section == 2) {
    
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"我的";
            break;
            
        case 1:
            return @"订单";
            break;
            
        case 2:
            return @"信息";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end
