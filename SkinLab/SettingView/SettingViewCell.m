//
//  SettingViewCell.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-2-25.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell

- (void)dealloc
{
    DLog(@"SettingViewCell dealloc")
    self.delegate = nil;
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isNormal = NO;
                
        UIView *backView         = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        self.backgroundView      = backView;
        
        if ([reuseIdentifier isEqualToString:@"SegmentWithFoot"]) {
            
            UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
            back.image = [UIImage imageNamed:@"淘宝背景"];
            [self.contentView addSubview:back];
            
            _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 35)];
            _footLabel.numberOfLines = 2;
            _footLabel.backgroundColor = [UIColor clearColor];
            _footLabel.textColor = [UIColor grayColor];
            _footLabel.font = [UIFont systemFontOfSize:11];
            _footLabel.text = @"绑定后可以方便的使用淘宝账号选购中意的护肤品，无需再次登录";
            [self.contentView addSubview:_footLabel];
                        
            _switchButton.on = NO;
            
        }else if ([reuseIdentifier isEqualToString:@"Segment"]) {
            
            UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            backImage.image = [UIImage imageNamed:@"普通背景"];
            [self.contentView addSubview:backImage];
            
        }else if ([reuseIdentifier isEqualToString:@"Switch"]) {
            
            _switchButton = [[MBSwitch alloc] initWithFrame:CGRectMake(240, 8, 51, 28)];
            [_switchButton setTintColor:RedColor];
            [_switchButton setOnTintColor:GreenColor];
            [_switchButton addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            [self.contentView addSubview:_switchButton];
            
            _switchButton.on = NO;

        }else if ([reuseIdentifier isEqualToString:@"WithoutLine"]) {
            
            _isNormal = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 43, 280, 1)];
            line.image = [UIImage imageNamed:@"分割线"];
            [self addSubview:line];
            
            _isNormal = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 100, 28)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchChanged:(UISwitch *)sender{
    [self.delegate SettingViewCellSwitchChanged:self];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    
}


@end
