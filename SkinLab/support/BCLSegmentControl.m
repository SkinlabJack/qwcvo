//
//  BCLSegmentControl.m
//  OSGHCinemas
//
//  Created by XUGANG on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BCLSegmentControl.h"

#define BADGEVIEWTAG 10

@interface BCLSegmentControl()

@end


@implementation BCLSegmentControl


-(void)dealloc
{
    self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.Changeable = YES;
    }
    return self;
}

//设置button数量
- (BOOL)setButtonNumbers:(NSInteger)number
{
    if (number<2) {
        return NO;
    }
    _buttonArray = [[NSMutableArray alloc] init];

    CGFloat x=0;
    CGFloat y=0;
    
    CGFloat height=self.frame.size.height;
    CGFloat width=self.frame.size.width;
    for (int i=0; i<number; i++) {
        CGRect buttonFrame = CGRectMake(x+i*width/number, y, width/number, height);
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        button.tag = i;
        [button setTitleColor:[UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
        [self addSubview:button];
        
    }
    return YES;
}

//设置button背景图
-(BOOL)setImage:(UIImage*)image atIndex:(NSInteger)index seleted:(BOOL)isSelected
{
    if (index<0||index>[_buttonArray count]-1) {
        return NO;
    }
    UIButton *button=[_buttonArray objectAtIndex:index];
    if (isSelected) {
        [button setBackgroundImage:image forState:UIControlStateSelected];
    }
    else
    {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    return YES;
}

//设置Title
-(BOOL)setTitle:(NSString*)title atIndex:(NSInteger)index seleted:(BOOL)isSelected
{
    if (index<0||index>[_buttonArray count]-1) {
        return NO;
    }
    UIButton *button=[_buttonArray objectAtIndex:index];
    if (isSelected) {
        [button setTitle:title forState:UIControlStateSelected ];
    }
    else
    {
        [button setTitle:title forState:UIControlStateNormal ];
    }
    return YES;
}

-(void)setSegmentDefaultIndex:(NSInteger)index
{
    for (int i = 0; i < [self.buttonArray count]; i++) {
        
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        if (button.tag == index) {
            _index = index;
            button.backgroundColor = [UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
    }
    [self.delegate segmentValueChanged:_index];
}

- (void)buttonPressed:(UIButton *)sender {
    
    if (self.Changeable) {
        if (sender.tag != _index) {
            for (UIButton *segmentButton in self.buttonArray) {
                if (segmentButton.tag == sender.tag) {
                    segmentButton.backgroundColor = [UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1];
                    [segmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    segmentButton.backgroundColor = [UIColor whiteColor];
                    [segmentButton setTitleColor:[UIColor colorWithRed:133/255.0 green:205/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
                }
            }
            _index = sender.tag;
            [self.delegate segmentValueChanged:_index];
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
