//
//  ChatViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "ChatViewCell.h"
#import "ChatTextView.h"
#import "Message.h"
#import "XMPPJID.h"

#import "SkinLab.h"

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InputViewDelegate> {
    float _keyboardHeight;
}

@property (strong) NSMutableArray *messagesArray;

@property (strong, nonatomic) InputView   *inputView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView      *touchView;

@property (copy, nonatomic) NSString *fromUser;
@property (copy, nonatomic) NSString *selfUser;

@end
