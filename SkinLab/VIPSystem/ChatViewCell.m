//
//  ChatViewCell.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ChatViewCell.h"

#define ImageViewHeight 160

@implementation ChatViewCell

- (void)dealloc
{
    DLog(@"ChatViewCell dealloc")
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _dateLabel.layer.masksToBounds = YES;
        _dateLabel.layer.cornerRadius  = 5;
        _dateLabel.numberOfLines       = 2;
        _dateLabel.backgroundColor     = GrayColor;
        _dateLabel.textColor           = BlackColor;
        _dateLabel.font                = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_dateLabel];
        
        _backGround = [[ZKIButton alloc] initWithFrame:CGRectMake(0, 30, 230, 60)];
        [self.contentView addSubview:_backGround];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _stateLabel.layer.masksToBounds = YES;
        _stateLabel.layer.cornerRadius  = 5;
        _stateLabel.numberOfLines       = 2;
        _stateLabel.backgroundColor     = GrayColor;
        _stateLabel.textColor           = BlackColor;
        _stateLabel.font                = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_stateLabel];
        
        if ([reuseIdentifier isEqualToString:@"TextLeft"]) {
            
            CGRect rect       = _backGround.frame;
            rect.origin.x     = 15;
            _backGround.frame = rect;
            
        }else if ([reuseIdentifier isEqualToString:@"TextRight"]) {
            
            CGRect rect       = _backGround.frame;
            rect.origin.x     = kScreenWidth - rect.size.width - 15;
            _backGround.frame = rect;
            
            _backGround.backgroundColor = GreenColor;
            
        }else if ([reuseIdentifier isEqualToString:@"ImageLeft"]) {
            
            CGRect rect       = _backGround.frame;
            rect.origin.x     = 15;
            rect.size.width   = ImageViewHeight;
            rect.size.height  = ImageViewHeight;
            _backGround.frame = rect;
            
            _imageMessage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ImageViewHeight - 10, ImageViewHeight - 10)];
            _imageMessage.layer.masksToBounds = YES;
            _imageMessage.layer.cornerRadius  = 5;
            _imageMessage.backgroundColor     = GrayColor;
            [self.backGround.contentView addSubview:_imageMessage];
            
        }else if ([reuseIdentifier isEqualToString:@"ImageRight"]) {
            
            CGRect rect       = _backGround.frame;
            rect.origin.x     = kScreenWidth - ImageViewHeight - 15;;
            rect.size.width   = ImageViewHeight;
            rect.size.height  = ImageViewHeight;
            _backGround.frame = rect;
            
            _imageMessage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ImageViewHeight - 10, ImageViewHeight - 10)];
            _imageMessage.layer.masksToBounds = YES;
            _imageMessage.layer.cornerRadius  = 5;
            _imageMessage.backgroundColor     = GrayColor;
            [self.backGround.contentView addSubview:_imageMessage];
            
            _backGround.backgroundColor = GreenColor;
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
