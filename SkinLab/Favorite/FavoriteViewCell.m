//
//  FavoriteViewCell.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-3-19.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "FavoriteViewCell.h"

@implementation FavoriteViewCell

- (void)dealloc
{
    self.delegate     = nil;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = GrayColor;
        
        UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
        back.image = [UIImage imageNamed:@"分割线"];
        [self addSubview:back];
        
        _productImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _productImage.layer.borderWidth = 0.5;
        _productImage.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3] CGColor];
        [self addSubview:_productImage];
        
        _productName = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, 185, 15)];
        _productName.backgroundColor = [UIColor clearColor];
        _productName.textColor = BlackColor;
        _productName.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_productName];
        
        _productBrand = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 185, 15)];
        _productBrand.backgroundColor = [UIColor clearColor];
        _productBrand.textColor = BlackColor;
        _productBrand.font = [UIFont systemFontOfSize:14];
        [self addSubview:_productBrand];
        
        _productInfo = [[UILabel alloc] initWithFrame:CGRectMake(75, 55, 185, 15)];
        _productInfo.backgroundColor = [UIColor clearColor];
        _productInfo.textColor = TextGrayColor;
        _productInfo.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_productInfo];
        
        _menuBack = [[UIImageView alloc] initWithFrame:CGRectMake(260, 0, 180, 80)];
        _menuBack.image = [UIImage imageNamed:@"菜单背景"];
        _menuBack.userInteractionEnabled = YES;
        [self addSubview:_menuBack];
        
        _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
        [_menuButton setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menuBack addSubview:_menuButton];
        
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 80)];
        [_buyButton setImage:[UIImage imageNamed:@"购买"] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(taobaoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menuBack addSubview:_buyButton];
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 0, 60, 80)];
        [_deleteButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menuBack addSubview:_deleteButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (IBAction)taobaoButtonClicked:(id)sender{
    [self menuButtonClicked:self.menuButton];
    [self.delegate buyButtonDidClicked:self];
}

- (IBAction)deleteButtonClicked:(id)sender{
    [self.delegate deleteButtonDidClicked:self];
}

- (IBAction)menuButtonClicked:(UIButton *)sender{
    [self menuButtonClicked:sender animated:YES];
}

- (void)menuButtonClicked:(UIButton *)sender animated:(BOOL)animated{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        if (animated) {
            [self buttonsAnimation:YES animated:animated];
        }else{
            [self buttonsAnimation:YES animated:animated];
        }
        
    }else{
        
        if (animated) {
            [self buttonsAnimation:NO animated:animated];
        }else{
            [self buttonsAnimation:NO animated:animated];
        }
        
    }
}

- (double)radians:(double)degrees {
    return degrees * M_PI/180;
}

- (void)buttonsAnimation:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        if (animated) {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView animateWithDuration:0.2 animations:^{
                self.productName.alpha  = 0;
                self.productBrand.alpha = 0;
                self.productInfo.alpha  = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.menuBack.frame = CGRectMake(140, 0, 180, 80);
                }];
            }];
        }else{
            self.productName.alpha  = 0;
            self.productBrand.alpha = 0;
            self.productInfo.alpha  = 0;
            
            self.menuBack.frame = CGRectMake(140, 0, 180, 80);
        }
        
    }else{
        if (animated) {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView animateWithDuration:0.2 animations:^{
                self.menuBack.frame = CGRectMake(260, 0, 180, 80);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.productName.alpha  = 1;
                    self.productBrand.alpha = 1;
                    self.productInfo.alpha  = 1;
                    
                }];
            }];
            
        }else{
            self.menuBack.frame = CGRectMake(260, 0, 180, 80);
            
            self.productName.alpha  = 1;
            self.productBrand.alpha = 1;
            self.productInfo.alpha  = 1;
        }
        
    }
    
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
