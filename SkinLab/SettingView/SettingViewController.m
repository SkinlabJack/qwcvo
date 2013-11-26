//
//  SettingViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-8.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)dealloc
{
    DLog(@"SettingViewController dealloc")
    
    
}

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
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight) style:UITableViewStyleGrouped];
    self.tableView = tempTableView;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.contentInset   = UIEdgeInsetsMake(120, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    UIView *tempTableVievBack = [[UIView alloc] initWithFrame:_tableView.frame];
    tempTableVievBack.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    _tableView.backgroundView = tempTableVievBack;
    
    UIImageView *tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.userImage = tempImage;
    self.userImage.center = CGPointMake(kScreenWidth/2, - 120/2);
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius  = 40;
    self.userImage.layer.borderColor   = GreenColor.CGColor;
    self.userImage.layer.borderWidth   = 2;
    [self.tableView addSubview:self.userImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboLogin)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.userImage addGestureRecognizer:tap];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.userName = tempLabel;
    self.userName.center = CGPointMake(kScreenWidth/2, - 120/2 + 55);
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.textAlignment   = UITextAlignmentCenter;
    self.userName.textColor       = GreenColor;
    self.userName.font            = [UIFont boldSystemFontOfSize:15];
    [self.tableView addSubview:self.userName];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WeiboLoginSuccess"]) {
        self.userImage.image  = [UIImage imageNamed:@"weibo"];
        self.userImage.userInteractionEnabled = YES;
        self.userName.text = @"微博登录";
    }else{
        NSString *imageURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserImage"];
        [self.userImage setImageWithURL:[NSURL URLWithString:imageURL]];
        self.userImage.userInteractionEnabled = NO;
        self.userName.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboLoginSuccess:) name:@"WeiboLoginSuccess" object:nil];
    
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

- (IBAction)leftBarButtonClicked:(UIButton *)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)weiboLogin{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];

}

- (IBAction)weiboLoginSuccess:(NSNotification *)notification {
    
    __weak typeof(self) blockSelf = self;
    
    [self.userImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:notification.userInfo[@"avatar_large"]]]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       [UIView animateWithDuration:0.5 animations:^{
                                           [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                                                  forView:blockSelf.userImage
                                                                    cache:YES];
                                           blockSelf.userImage.image = image;
                                       }];
                                       
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                   }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.userName
                                 cache:YES];
        self.userName.text = notification.userInfo[@"name"];
    }];
    
    DLog(@"%@", notification.userInfo)
    
    self.userImage.userInteractionEnabled = NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:notification.userInfo[@"avatar_large"] forKey:@"UserImage"];
    [[NSUserDefaults standardUserDefaults] setObject:notification.userInfo[@"name"] forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WeiboLoginSuccess"];
    
    NSString *user = [NSString stringWithFormat:@"%@sw", notification.userInfo[@"id"]];

    [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSystemRegister]
                                    parameters:@{@"username": user, @"password": [DataCenter shareData].deviceID, @"email": [NSString stringWithFormat:@"%@@gmail.com",user], @"Nickname": notification.userInfo[@"name"]}
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           DLog(@"%@", operation.responseString)
                                           
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                           DLog(@"%@", error)
                                           
                                       }];
    
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
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 4;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifierWithSwich   = @"Switch";
    static NSString *CellIdentifierWithoutLine = @"WithoutLine";
    static NSString *CellIdentifier            = @"Cell";
    SettingViewCell *cell;
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWithoutLine];
        if (cell == nil) {
            cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierWithoutLine];
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"收藏夹";
        }
    
    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWithSwich];
        if (cell == nil) {
            cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierWithSwich];
        }
        
        cell.titleLabel.text = @"推送消息";
        cell.switchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"PushOn"];
        
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
            cell.titleLabel.text = @"数据来源";
        }
        
        if (indexPath.row == 1) {
            cell.titleLabel.text = @"建议反馈";
        }
        
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"评价应用";
        }
        
        if (indexPath.row == 3) {
            cell.titleLabel.text = @"SkinLab";
        }

        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
    }
    
    cell.delegate = self;
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
        if (indexPath.row == 0) {
            
            SourceViewController *sourceViewController = [[SourceViewController alloc] initWithNibName:@"SourceViewController" bundle:nil];
            sourceViewController.showNav = YES;
            [self.navigationController pushViewController:sourceViewController animated:YES];
            
        }else if (indexPath.row == 1) {
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil) {
                MFMailComposeViewController * mailView = [[MFMailComposeViewController alloc] init];
                mailView.mailComposeDelegate = self;
                
                if ([AppHelper shareHelper].appCenter.isiOS7) {
                    [mailView.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav128"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
                }else{
                    [mailView.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
                }
                
                //Set the subject
                [mailView setSubject:[NSString stringWithFormat:@"问题反馈-SkinLab-V%@-%@", [DataCenter shareData].appVersion, [DataCenter shareData].appMarket]];
                [mailView setToRecipients:@[@"tryseason@gmail.com"]];
                //Set the mail body
                [mailView setMessageBody:[NSString stringWithFormat:@"From:%@", [DataCenter shareData].deviceID] isHTML:YES];
                //Display Email Composer
                if([mailClass canSendMail]) {
                    [self presentModalViewController:mailView animated:YES];
                }
            }
            
        }else if (indexPath.row == 2) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Commented"];
            NSString *appURL = @"itms-apps://itunes.apple.com/app/id663805293";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
            
        }else if (indexPath.row == 3){
            
            AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            [self.navigationController pushViewController:aboutViewController animated:YES];
            
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"我的";
            break;
            
        case 1:
            return @"推送";
            break;
            
        case 2:
            return @"关于";
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

#pragma mark - SettingViewCellDelegate

- (void)SettingViewCellSwitchChanged:(SettingViewCell *)cell {
    
    if ([cell.titleLabel.text isEqualToString:@"新浪"]) {
        
    }else if ([cell.titleLabel.text isEqualToString:@"人人"]){
        
    }else if ([cell.titleLabel.text isEqualToString:@"推送消息"]){
        
        DLog(@"Push %@", cell.switchButton.on?@"yes":@"no");
        [[NSUserDefaults standardUserDefaults] setBool:cell.switchButton.on forKey:@"PushOn"];
        
        if (cell.switchButton.on) {
            [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSystemUploadToken]
                                            parameters:@{@"UserID": [DataCenter shareData].deviceID, @"DeviceToken": [DataCenter shareData].deviceToken}
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   
                                                   DLog(@"%@", [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                               options:NSJSONReadingMutableLeaves
                                                                                                 error:nil]);
                                                   
                                               }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   DLog(@"%@",error);
                                               }];
        }else{
            [[SkinLabHttpClient sharedClient] postPath:[SkinLabHttpClient getSubPath:SkinLabRequertTypeSystemDeleteToken]
                                            parameters:@{@"UserID": [DataCenter shareData].deviceID}
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   
                                                   DLog(@"%@", [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                               options:NSJSONReadingMutableLeaves
                                                                                                 error:nil]);
                                                   
                                               }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   DLog(@"%@",error);
                                               }];
        }
    }
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //DLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            //DLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            //DLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            //DLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
