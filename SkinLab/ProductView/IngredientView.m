//
//  IngredientView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-24.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "IngredientView.h"

@implementation IngredientView

- (void)dealloc
{
    DLog(@"IngredientView dealloc");
    
    self.delegate  = nil;
    self.IngredientID = nil;
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, frame.size.height)];
        _line.backgroundColor = GreenColor;
        [self addSubview:_line];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width - 10, frame.size.height)];
        _nameLabel.textAlignment = UITextAlignmentCenter;
        _nameLabel.textColor = GreenColor;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width - 10, frame.size.height)];
        _infoLabel.textAlignment = UITextAlignmentCenter;
        _infoLabel.textColor = GreenColor;
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_infoLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (float)setIngredientViewData:(NSString *)name info:(NSString *)info{
    
    float width = 5;
    
    CGSize infoSize = [info sizeWithFont:[UIFont systemFontOfSize:13]];
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:13]];
    
    CGRect nameFrame = self.nameLabel.frame;
    nameFrame.origin.x = width;
    nameFrame.size.width  = nameSize.width;
    self.nameLabel.frame = nameFrame;
    self.nameLabel.text  = name;
    
    width += nameSize.width + 5;
    
    CGRect infoFrame = self.nameLabel.frame;
    infoFrame.origin.x = width;
    infoFrame.size.width  = infoSize.width;
    self.infoLabel.frame = infoFrame;
    self.infoLabel.text  = info;

    width += infoSize.width + 5;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    
    return width;
}

- (void)tapHandle{
    [self.delegate ingredientViewDidTaped:self];
}

- (void)setViewHighLight{
    self.backgroundColor      = GreenColor;
    self.nameLabel.textColor  = [UIColor whiteColor];
    self.infoLabel.textColor  = [UIColor whiteColor];
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
