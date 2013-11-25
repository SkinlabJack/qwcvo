//
//  SearchViewCell.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-25.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SearchViewCell.h"

@implementation SearchViewCell

- (void)dealloc
{
    DLog(@"SearchViewCell dealloc")
    

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = GrayColor;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 260, 1)];
        line.backgroundColor = GreenColor;
        [self addSubview:line];
        
        _productImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 100, 100)];
        _productImage.layer.borderWidth = 1;
        _productImage.layer.borderColor = GreenColor.CGColor;
        [self.contentView addSubview:_productImage];
        
        _productName = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 145, 36)];
        _productName.numberOfLines   = 2;
        _productName.backgroundColor = GrayColor;
        _productName.textColor       = BlackColor;
        _productName.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_productName];
        
        _productBrand = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 145, 20)];
        _productBrand.backgroundColor = GrayColor;
        _productBrand.textColor = BlackColor;
        _productBrand.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_productBrand];
        
        _productInfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 145, 30)];
        _productInfo.numberOfLines   = 2;
        _productInfo.backgroundColor = GrayColor;
        _productInfo.textColor       = TextGrayColor;
        _productInfo.font            = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_productInfo];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
