//
//  WeeklyTableViewCell.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-8-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "WeeklyTableViewCell.h"

@implementation WeeklyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *backView = [[UIView alloc] init];
        self.backgroundView  = backView;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 260, 20)];
        _nameLabel.numberOfLines   = 2;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = BlackColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, 260, 30)];
        _infoLabel.numberOfLines   = 2;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = TextGrayColor;
        _infoLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_infoLabel];
        
        UIImageView *dateImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 75, 15, 15)];
        dateImage.image = [UIImage imageNamed:@"周刊时间"];
        [self.contentView addSubview:dateImage];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 80, 15)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = TextGrayColor;
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_dateLabel];
        
        UIImageView *countImage = [[UIImageView alloc] initWithFrame:CGRectMake(130, 75, 15, 15)];
        countImage.image = [UIImage imageNamed:@"浏览数"];
        [self.contentView addSubview:countImage];

        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 75, 80, 15)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = TextGrayColor;
        _countLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_countLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
