//
//  SettingViewCell.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-2-25.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSwitch.h"
#import "SkinLab.h"

@class SettingViewCell;

@protocol SettingViewCellDelegate <NSObject>

@optional
- (void)SettingViewCellSwitchChanged:(SettingViewCell *)cell;

@end

@interface SettingViewCell : UITableViewCell{
    BOOL _isNormal;
}

@property (weak, nonatomic) id <SettingViewCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *backGroundImage;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *footLabel;

@property (strong, nonatomic) MBSwitch  *switchButton;
@property (strong, nonatomic) UIImageView *image;

@end
