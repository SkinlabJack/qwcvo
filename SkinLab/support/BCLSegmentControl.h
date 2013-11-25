//
//  BCLSegmentControl.h
//  OSGHCinemas
//使用说明：
//初始化initwithFrame
//设置Button数量
//设置button背景图（含选中背景图）
//设置标题（含选中背景图）
//设置默认索引
//设置代理，实现委托函数
//  Created by XUGANG on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BCLSegmentControlDelegate;

@interface BCLSegmentControl : UIView{
    BOOL _Changeable;
}

@property (nonatomic,     weak) id <BCLSegmentControlDelegate> delegate;
@property (nonatomic, readonly) NSInteger index;
@property (nonatomic,   strong) NSMutableArray *buttonArray;
@property (assign) BOOL Changeable;

-(BOOL)setButtonNumbers:(NSInteger)number;
-(BOOL)setImage:(UIImage*)image atIndex:(NSInteger)index seleted:(BOOL)isSelected;
-(BOOL)setTitle:(NSString*)title atIndex:(NSInteger)index seleted:(BOOL)isSelected;
-(void)setSegmentDefaultIndex:(NSInteger)index;

@end

@protocol BCLSegmentControlDelegate <NSObject>
-(void)segmentValueChanged:(NSInteger)index;
@end