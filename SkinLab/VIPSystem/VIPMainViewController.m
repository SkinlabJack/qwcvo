//
//  VIPMainViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-28.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "VIPMainViewController.h"
#import "ChatViewController.h"

#define TopViewHeight 220

@interface VIPMainViewController ()

@end

@implementation VIPMainViewController

- (void)dealloc
{
    DLog(@"VIPMainViewController dealloc")
    
    
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
	
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight)];
    self.tableView = tempTableView;
    self.tableView.backgroundColor = GrayColor;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.contentInset   = UIEdgeInsetsMake(TopViewHeight, 0, 40, 0);
    [self.view addSubview:self.tableView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -TopViewHeight, kScreenWidth, TopViewHeight)];
    self.topView.backgroundColor = GrayColor;
    [self.tableView addSubview:self.topView];
    
    UILabel *topTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 290, 30)];
    topTextLabel.textAlignment   = UITextAlignmentCenter;
    topTextLabel.backgroundColor = [UIColor clearColor];
    topTextLabel.font            = [UIFont boldSystemFontOfSize:16];
    topTextLabel.textColor       = GreenColor;
    topTextLabel.text            = @"升级到SkinLab会员，享受专享服务";
    [self.topView addSubview:topTextLabel];
    
    UILabel *rightsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TopViewHeight - 20, 320, 20)];
    rightsLabel.backgroundColor = GreenColor;
    rightsLabel.font            = [UIFont boldSystemFontOfSize:12];
    rightsLabel.textColor       = [UIColor whiteColor];
    rightsLabel.text            = @"      会员专享服务";
    [self.topView addSubview:rightsLabel];
    
    NSArray *mumbler = @[@{@"mumbler": @"中级", @"price": @"169"}, @{@"mumbler": @"高级", @"price": @"299"}, @{@"mumbler": @"VIP", @"price": @"499"}];
    
    for (int i = 0; i < 3; i++) {
        
        ZKIButton *button = [[ZKIButton alloc] initWithFrame:CGRectMake(15, 135, 140, 50)];
        [self.topView addSubview:button];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, button.frame.size.width, 20)];
        nameLabel.textAlignment   = UITextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font            = [UIFont boldSystemFontOfSize:13];
        nameLabel.textColor       = BlackColor;
        nameLabel.text            = @"中级会员";
        [button.contentView addSubview:nameLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, button.frame.size.width, 20)];
        textLabel.textAlignment   = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font            = [UIFont boldSystemFontOfSize:13];
        textLabel.textColor       = GreenColor;
        textLabel.text            = @"￥299/季度(3个月)";
        [button.contentView addSubview:textLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
        [button.contentView addSubview:imageView];

        __weak typeof(self) blockSelf = self;
        
        switch (i) {
            case 0: {
                button.frame   = CGRectMake(15, 70, 140, 50);
                button.keyID   = @"0";
                nameLabel.text = @"中级会员";
                textLabel.text = @"￥169/季度(3个月)";
                imageView.image = [UIImage imageNamed:@"中级会员"];
                
                [button addTapBlock:^(NSString *keyID) {
                    DLog(@"%@", keyID)
                    [blockSelf updataButtonClickde:mumbler[i]];
                }];
                
                break;
            }
                
            case 1: {
                button.frame   = CGRectMake(15, 130, 140, 50);
                button.keyID   = @"1";
                nameLabel.text = @"高级会员";
                textLabel.text = @"￥299/季度(3个月)";
                imageView.image = [UIImage imageNamed:@"高级会员"];
                
                [button addTapBlock:^(NSString *keyID) {
                    DLog(@"%@", keyID)
                    [blockSelf updataButtonClickde:mumbler[i]];
                }];
                
                break;
            }
                
            case 2: {
                button.frame   = CGRectMake(165, 70, 140, 110);
                button.keyID   = @"2";
                nameLabel.frame = CGRectMake(0, 55, button.frame.size.width, 20);
                nameLabel.text = @"VIP会员";
                textLabel.frame = CGRectMake(0, 75, button.frame.size.width, 20);
                textLabel.text = @"￥499/季度(3个月)";
                
                imageView.frame = CGRectMake(50, 15, 40, 40);
                imageView.image = [UIImage imageNamed:@"vip会员"];
                
                [button addTapBlock:^(NSString *keyID) {
                    DLog(@"%@", keyID)
                    [blockSelf updataButtonClickde:mumbler[i]];
                }];
                
                break;
                }
                
            default:
                break;
        }
    }
    
    UIButton *supportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - KSNHeight - 40, kScreenWidth, 40)];
    supportButton.backgroundColor = [UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:0.8];
    supportButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [supportButton setTitle:@"在线客服" forState:UIControlStateNormal];
    [supportButton addTarget:self action:@selector(supportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:supportButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
}

- (IBAction)supportButtonClicked:(UIButton *)sender{
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.fromUser = @"test";
    [self.navigationController pushViewController:chatViewController animated:YES];

}

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)updataButtonClickde:(NSDictionary *)dic {
    
    VIPDetailPopView *vipDetailPopView = [[VIPDetailPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    vipDetailPopView.alpha = 0;
    [self.view.window addSubview:vipDetailPopView];
    
    vipDetailPopView.topLabel.text   = [NSString stringWithFormat:@"升级成为SkinLab%@会员", dic[@"mumbler"]];
    vipDetailPopView.priceLabel.text = [NSString stringWithFormat:@"￥%@/季度", dic[@"price"]];
    
    [UIView animateWithDuration:0.25 animations:^{
        vipDetailPopView.alpha = 1;
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text       = @"专属顾问";
    cell.textLabel.textColor  = BlackColor;
    cell.textLabel.font       = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = @"一对一的专业护肤指导";
    cell.detailTextLabel.textColor = TextGrayColor;
    
    switch (indexPath.row) {
        case 0:{
            cell.imageView.image = [UIImage imageNamed:@"礼包图标"];
            break;
        }
            
        case 1:{
            cell.imageView.image = [UIImage imageNamed:@"顾问图标"];
            break;
        }
            
        case 2:{
            cell.imageView.image = [UIImage imageNamed:@"积分图标"];
            break;
        }
            
        default:
            break;
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
