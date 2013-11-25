//
//  SimilarProductView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-19.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "SimilarProductView.h"

@implementation SimilarProductView

- (void)dealloc
{
    DLog(@"SimilarProductView dealloc");
    
    self.delegate   = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.image = [UIImage imageNamed:@"分割线"];
        [self addSubview:line];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = TextGrayColor;
        _textLabel.text      = @"相关产品";
        _textLabel.font      = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_textLabel];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 40, 300, 130)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
        [self addSubview:_scrollView];
        
        UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 30, 30)];
        left.image = [UIImage imageNamed:@"左"];
        [self addSubview:left];
        
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(290, 70, 30, 30)];
        right.image = [UIImage imageNamed:@"右"];
        [self addSubview:right];
    }
    return self;
}

- (void)setSimilarProduct:(NSArray *)productArray{
    
    self.scrollView.contentSize = CGSizeMake(5 + 105 * productArray.count, 100);
    for (int i = 0; i < productArray.count; i++) {
        NSDictionary *dic = productArray[i];
        
        ProductImageView *imageView = [[ProductImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 130)];
        imageView.frame = CGRectMake(105 * i, 0, 90, 130);
        imageView.delegate = self;
        [self.scrollView addSubview:imageView];
        
        
        NSURL *imageURL = nil;
        if (![DataCenter isNull:dic[@"productImage"]]) {
            NSString *imageURLString = [dic[@"productImage"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
            imageURL = [SkinLabHttpClient getImageURL:imageURLString];
        }
        
        imageView.productBrandLabel.text = dic[@"productBrand"];
        imageView.productNameLabel.text  = dic[@"productName"];
        imageView.productID              = dic[@"productID"];
        [imageView.productImage setImageWithURL:imageURL];
    }
}

- (void)productImageDidClicked:(NSString *)productID{
    DLog(@"%@", productID)
    [self.delegate productImageDidClicked:productID];
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
