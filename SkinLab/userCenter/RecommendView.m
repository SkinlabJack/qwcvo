//
//  RecommendView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-8-6.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView

- (void)dealloc
{
    DLog(@"RecommendView dealloc")
    
    self.delegate = nil;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GrayColor;
        
        UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        [self addSubview:touchView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productClicked)];
        tap.numberOfTapsRequired    = 1;
        tap.numberOfTouchesRequired = 1;
        [touchView addGestureRecognizer:tap];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        _imageView.backgroundColor = [UIColor whiteColor];
        [touchView addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 205, 20)];
        _nameLabel.numberOfLines   = 2;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor       = BlackColor;
        _nameLabel.font            = [UIFont boldSystemFontOfSize:15];
        [touchView addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 205, 20)];
        _infoLabel.numberOfLines   = 2;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor       = TextGrayColor;
        _infoLabel.font            = [UIFont boldSystemFontOfSize:15];
        [touchView addSubview:_infoLabel];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 205, 20)];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.numberOfLines   = 2;
        _descriptionLabel.textColor       = GreenColor;
        _descriptionLabel.font            = [UIFont boldSystemFontOfSize:15];
        [touchView addSubview:_descriptionLabel];
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 200)];
        tempView.backgroundColor= [UIColor whiteColor];
        [self addSubview:tempView];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        line.image = [UIImage imageNamed:@"三角分割"];
        [tempView addSubview:line];
        
        UITextView *tempTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 170)];
        self.textView = tempTextView;
        self.textView.textColor = GreenColor;
        self.textView.font      = [UIFont systemFontOfSize:13];
        self.textView.scrollEnabled = YES;
        self.textView.editable      = NO;
        [tempView addSubview:self.textView];
        
    }
    return self;
}

- (void)productClicked{
    [self.delegate recommendViewDidClicked:self.productID];
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
