//
//  ProductImageView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-23.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ProductImageView.h"

@implementation ProductImageView

- (void)dealloc
{
    DLog(@"ProductImageView dealloc");
    
    self.delegate     = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _productImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _productImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_productImage];
        
        _productBrandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width + 5, frame.size.width, 15)];
        _productBrandLabel.backgroundColor = [UIColor clearColor];
        _productBrandLabel.textColor       = BlackColor;
        _productBrandLabel.font            = [UIFont boldSystemFontOfSize:10];
        [self addSubview:_productBrandLabel];
        
        _productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width + 20, frame.size.width, 15)];
        _productNameLabel.numberOfLines   = 2;
        _productNameLabel.backgroundColor = [UIColor clearColor];
        _productNameLabel.textColor       = TextGrayColor;
        _productNameLabel.font            = [UIFont systemFontOfSize:10];
        [self addSubview:_productNameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productImageClicked)];
        tap.numberOfTapsRequired    = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)productImageClicked{
    [self.delegate productImageDidClicked:self.productID];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
