//
//  ChatViewController.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"

#define InputViewHeight 50

#define MessageTypeText  @"[txt]"
#define MessageTypeImage @"[img]"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)dealloc
{
    DLog(@"ChatViewController dealloc")
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _messagesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    [self setupNavigationController];
    self.selfUser = @"wing";
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KSNHeight - InputViewHeight)];
    self.tableView = tempTableView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.alpha      = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
	InputView *tempInputView = [[InputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - KSNHeight - 50, 320, 50)];
    self.inputView = tempInputView;
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.touchView = tempView;
    self.touchView.alpha = 0;
    [self.view addSubview:self.touchView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewClicked)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.touchView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendNewMessage:)
                                                 name:@"SendNewMessage"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewMessage:)
                                                 name:@"ReceiveNewMessage"
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.messagesArray.count == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *array = [appDelegate.xmppServer getMessageData:self.fromUser selfName:self.selfUser];
        
        int messagesCount = 0;
        
        if (array.count >= 10) {
            messagesCount = 10;
        }else{
            messagesCount = array.count;
        }
        
        for (int i = array.count; i > array.count - messagesCount; i--) {
            [self.messagesArray insertObject:[self createMessage:array[i - 1]] atIndex:0];
        }
        
        [self.tableView reloadData];
        
        if(self.messagesArray.count > 0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.alpha = 1;
        }];
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
    
}

- (Message *)createMessage:(NSDictionary *)dic {
    
    NSString *messageSting = dic[@"Message"];
    NSString *from         = dic[@"From"];
    NSString *type         = @"";
    
    DLog(@"from = %@", from)
    
    Message *messageObject = [[Message alloc] init];
    
    if ([messageSting hasPrefix:MessageTypeText]) {
        type               = MessageTypeText;
        messageObject.text = [messageSting stringByReplacingOccurrencesOfString:MessageTypeText withString:@""];
    }else if ([messageSting hasPrefix:MessageTypeImage]) {
        type               = MessageTypeImage;
        messageObject.text = [messageSting stringByReplacingOccurrencesOfString:MessageTypeImage withString:@""];
    }else{
        type               = MessageTypeText;
        messageObject.text = messageSting;
    }
    
    
    
    if ([from isEqualToString:self.fromUser]) {
        if ([type isEqualToString:MessageTypeText]) {
            messageObject.cellMode = @"TextLeft";
        }else if ([type isEqualToString:MessageTypeImage]) {
            messageObject.cellMode = @"ImageLeft";
            messageObject.height = 200;
        }else{
            messageObject.cellMode = @"TextLeft";
        }
        
    }else {
        if ([type isEqualToString:MessageTypeText]) {
            messageObject.cellMode = @"TextRight";
        }else if ([type isEqualToString:MessageTypeImage]) {
            messageObject.cellMode = @"ImageRight";
            messageObject.height = 200;
        }else{
            messageObject.cellMode = @"TextRight";
        }
    }
    
    return messageObject;
}

- (void)showNewMessage:(NSDictionary *)dic{
    
    [self.tableView beginUpdates];
    [self.messagesArray addObject:[self createMessage:dic]];
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self scrollToBottom];
    
}

- (void)scrollToBottom {
    if(self.messagesArray.count > 0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - ButtonClicked

- (IBAction)leftBarButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchViewClicked {
    self.touchView.alpha = 0;
    [self.inputView.growingTextView resignFirstResponder];
}

#pragma mark - InputViewDelegate

- (void)inputViewDidTouched:(InputView *)inputView {
    
}

- (void)inputViewHeightDidChanged:(float)height {
    CGRect rect   = self.inputView.frame;
    rect.origin.y = kScreenHeight - KSNHeight - _keyboardHeight - height;
    self.inputView.frame = rect;
}

- (void)inputViewSendMessage:(NSString *)message {
    if (message != nil && ![message isEqualToString:@""]) {
        NSDictionary *dic = @{@"Type": @"txt", @"Message": message, @"To": @"wing"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendNewMessage" object:self userInfo:dic];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        XMPPMessage *mmessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@uhz002778", self.fromUser]]];
        [mmessage addBody:[NSString stringWithFormat:@"%@%@", MessageTypeText, message]];
        [appDelegate.xmppServer.xmppStream sendElement:mmessage];
    }
}

#pragma mark - MessageNotification

- (void)sendNewMessage:(NSNotification *)notification {
    [self showNewMessage:notification.userInfo];
    DLog(@"sendMessage = %@", notification.userInfo)
}

- (void)receiveNewMessage:(NSNotification *)notification {
    
    if (![notification.userInfo[@"From"] isEqualToString:self.fromUser]) {
        return;
    }
    
    [self showNewMessage:notification.userInfo];
    DLog(@"receiveMessage = %@", notification.userInfo)
}

#pragma mark - KeyboardNotification

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.inputView.frame;
        rect.origin.y = kScreenHeight - KSNHeight - self.inputView.frame.size.height - keyboardRect.size.height;
        self.inputView.frame = rect;
        
        rect = self.tableView.frame;
        rect.size.height = kScreenHeight - KSNHeight - self.inputView.frame.size.height - keyboardRect.size.height;
        self.tableView.frame = rect;
    }];
    
    CGRect rect = self.touchView.frame;
    rect.size.height = kScreenHeight - KSNHeight - self.inputView.frame.size.height - keyboardRect.size.height;
    self.touchView.frame = rect;
    self.touchView.alpha = 1;
    
    [self scrollToBottom];
    
    _keyboardHeight = keyboardRect.size.height;
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.inputView.frame;
        rect.origin.y = kScreenHeight - KSNHeight - self.inputView.frame.size.height;
        self.inputView.frame = rect;
    }];
    
    CGRect rect = self.tableView.frame;
    rect.size.height = kScreenHeight - KSNHeight - self.inputView.frame.size.height;
    self.tableView.frame = rect;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TextLeft   = @"TextLeft";
    static NSString *TextRight  = @"TextRight";
    static NSString *ImageLeft  = @"ImageLeft";
    static NSString *ImageRight = @"ImageRight";
    
    Message *message = self.messagesArray[indexPath.row];
    ChatViewCell *cell = nil;
    
    if ([message.cellMode isEqualToString:TextLeft]) {
        cell = [tableView dequeueReusableCellWithIdentifier:TextLeft];
        if (cell == nil) {
            cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextLeft];
        }
        
        for (UIView *view in [cell.backGround.contentView subviews]) {
            [view removeFromSuperview];
        }
        
        Message *message = self.messagesArray[indexPath.row];
        [cell.backGround.contentView addSubview:message.textView];
        
        CGRect rect = cell.backGround.frame;
        if (message.height < 85) {
            CGSize stringSize = [message.text sizeWithFont:[UIFont systemFontOfSize:16]];
            rect.size.width = stringSize.width + 20;
        }else {
            rect.size.width = 230;
        }
        rect.size.height = message.textView.frame.size.height + 15;
        cell.backGround.frame = rect;
        
    }else if ([message.cellMode isEqualToString:TextRight]) {
        cell = [tableView dequeueReusableCellWithIdentifier:TextRight];
        if (cell == nil) {
            cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextRight];
        }
        
        for (UIView *view in [cell.backGround.contentView subviews]) {
            [view removeFromSuperview];
        }
        
        Message *message = self.messagesArray[indexPath.row];
        [cell.backGround.contentView addSubview:message.textView];
        
        CGRect rect = cell.backGround.frame;
        if (message.height < 85) {
            CGSize stringSize = [message.text sizeWithFont:[UIFont systemFontOfSize:16]];
            rect.size.width = stringSize.width + 20;
            rect.origin.x   = kScreenWidth - rect.size.width - 15;
        }else {
            rect.size.width = 230;
            rect.origin.x   = kScreenWidth - 230 - 15;
        }
        rect.size.height = message.textView.frame.size.height + 15;
        cell.backGround.frame = rect;
        
    }else if ([message.cellMode isEqualToString:ImageLeft]) {
        cell = [tableView dequeueReusableCellWithIdentifier:ImageLeft];
        if (cell == nil) {
            cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageLeft];
        }
        
        cell.imageMessage.image = [UIImage imageNamed:@"关于logo"];
        
    }else if ([message.cellMode isEqualToString:ImageRight]) {
        cell = [tableView dequeueReusableCellWithIdentifier:ImageRight];
        if (cell == nil) {
            cell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageRight];
        }
        
        cell.imageMessage.image = [UIImage imageNamed:@"关于logo"];
        
    }else{
        return nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messagesArray[indexPath.row];
    return message.height;
}


@end
