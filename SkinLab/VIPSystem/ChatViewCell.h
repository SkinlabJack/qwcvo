//
//  ChatViewCell.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKIButton.h"
#import "SkinLab.h"

@interface ChatViewCell : UITableViewCell

@property (strong, nonatomic) UILabel     *dateLabel;
@property (strong, nonatomic) ZKIButton   *backGround;
@property (strong, nonatomic) UILabel     *stateLabel;
@property (strong, nonatomic) UIImageView *imageMessage;
@property (copy  , nonatomic) NSString    *textMessage;

@end
