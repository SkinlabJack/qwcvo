//
//  LeftViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-11-1.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)dealloc
{
    DLog(@"LeftViewController dealloc")
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor      = GrayColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset    = UIEdgeInsetsMake(130, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    if (![DataCenter isiOS7]) {
        self.tableView.backgroundView = [[UIView alloc] init];
    }
    
    ZKIButton *testButton = [[ZKIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.userImage = testButton;
    self.userImage.center             = CGPointMake(260/2, - 130/2);
    self.userImage.layer.cornerRadius = 40;
    self.userImage.layer.borderColor  = GreenColor.CGColor;
    self.userImage.layer.borderWidth  = 2;
    self.userImage.imageView.image    = [UIImage imageNamed:@"关于logo"];
    [self.tableView addSubview:self.userImage];
    
    __weak typeof(self) blockSelf = self;
    
    [self.userImage addTapBlock:^(NSString *keyID) {
        NSDictionary *dic = @{@"ViewName": @"UserCenterView"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:blockSelf userInfo:dic];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self setupNavigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationController{
    
    if ([DataCenter isLogin]) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [leftButton setTitleColor:GreenColor forState:UIControlStateNormal];
        [leftButton setTitle:@"登录" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }

}

- (IBAction)leftBarButtonClicked:(UIButton *)sender {
    NSDictionary *dic = @{@"ViewName": @"UserCenterView"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
}


#pragma mark - Table view data source

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
            return 3;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = GreenColor;
    cell.backgroundColor     = [UIColor whiteColor];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"主页";
                cell.imageView.image = [UIImage imageNamed:@"主页图标"];
                break;
                
            case 1:
                cell.textLabel.text = @"积分商城";
                cell.imageView.image = [UIImage imageNamed:@"商城图标"];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"成为高级会员";
                cell.imageView.image = [UIImage imageNamed:@"VIP图标"];
                break;
                
            case 1:
                cell.textLabel.text = @"专业护肤咨询";
                cell.imageView.image = [UIImage imageNamed:@"咨询图标"];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"个人中心";
                cell.imageView.image = [UIImage imageNamed:@"个人图标"];
                break;
                
            case 1:
                cell.textLabel.text = @"邀请好友";
                cell.imageView.image = [UIImage imageNamed:@"邀请图标"];
                break;
                
            case 2:
                cell.textLabel.text = @"应用设置";
                cell.imageView.image = [UIImage imageNamed:@"设置图标"];
                break;
                
            default:
                break;
        }
    }

    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([DataCenter isiOS7]){
        return 50;
    }
    else {
        return 25;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.0;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"SkinLab";
            break;
            
        case 1:
            return @"会员专享";
            break;
            
        case 2:
            return @"个人中心";
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                NSDictionary *dic = @{@"ViewName": @"MainView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                break;
            }
                
            case 1:{
                NSDictionary *dic = @{@"ViewName": @"ShopView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                break;
            }
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                NSDictionary *dic = @{@"ViewName": @"VIPMainView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                break;
            }
                
            case 1:{
                NSDictionary *dic = @{@"ViewName": @"ConsultView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                break;
            }
                
            default:
                break;
        }

        
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                NSDictionary *dic = @{@"ViewName": @"UserCenterView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                
                break;
            }
                
            case 1:{
                NSDictionary *dic = @{@"ViewName": @"InviteView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                break;
            }
                
            case 2:{
                NSDictionary *dic = @{@"ViewName": @"SettingView"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeView" object:self userInfo:dic];
                
                break;
            }
                
            default:
                break;
        }
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
