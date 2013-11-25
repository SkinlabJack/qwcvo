//
//  ParametersView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-18.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ParametersView.h"

@implementation ParametersView

- (void)dealloc
{
    DLog(@"ParametersView dealloc");
    
    self.delegate = nil;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ParameterViewCount = 0;
    }
    return self;
}

- (void)setupParametersoily:(NSString *)oilyIndex
                  pigmented:(NSString *)pigmentedIndex
                  wensitive:(NSString *)sensitiveIndex
                   wrinkled:(NSString *)wrinkledIndex
       withIngredientsArray:(NSArray *)array
             withproductDes:(NSDictionary *)desDic
             withLightArray:(NSArray *)lightArray{
    
    self.ingredientsArray      = array;
    self.productDesDic         = desDic;
    self.ingredientsLightArray = lightArray;
    float y = 5;
    
    ParameterView *para1 = [[ParameterView alloc] initWithFrame:CGRectMake(0, y, 320, 30)];
    [self addSubview:para1];
    para1.delegate  = self;
    para1.indexName = @"OilyIndex";
    
    if (oilyIndex.floatValue > 0) {
        para1.nameLabel.text = @" 控油指数";
        [para1 setPercent:[oilyIndex isEqualToString:@""]?0:oilyIndex.intValue animated:YES];
    }else{
        para1.nameLabel.text = @" 保湿指数";
        [para1 setPercent:[oilyIndex isEqualToString:@""]?0:-oilyIndex.intValue animated:YES];
    }
    [self setupIndexViewClickEnabel:para1];
    
    y += 35;
    
    if (pigmentedIndex.floatValue > 0) {
        ParameterView *para2 = [[ParameterView alloc] initWithFrame:CGRectMake(0, y, 320, 30)];
        [self addSubview:para2];
        para2.delegate  = self;
        para2.indexName = @"PigmentedIndex";
        para2.nameLabel.text = @" 美白指数";
        [para2 setPercent:[pigmentedIndex isEqualToString:@""]?0:pigmentedIndex.intValue animated:YES];
        [self setupIndexViewClickEnabel:para2];
        
        y += 35;
    }
    
    ParameterView *para3 = [[ParameterView alloc] initWithFrame:CGRectMake(0, y, 320, 30)];
    [self addSubview:para3];
    para3.delegate  = self;
    para3.indexName = @"SensitiveIndex";
    
    if (sensitiveIndex.floatValue > 0) {
        [para3 setPercent:[sensitiveIndex isEqualToString:@""]?0:sensitiveIndex.intValue  animated:YES];
        para3.nameLabel.text = @" 抗敏指数";
    }else{
        para3.percentImage.backgroundColor = RedColor;
        para3.nameLabel.backgroundColor    = RedColor;
        [para3 setPercent:[sensitiveIndex isEqualToString:@""]?0:-sensitiveIndex.intValue  animated:YES];
        para3.nameLabel.text = @" 致敏指数";
    }
    [self setupIndexViewClickEnabel:para3];
    
    y += 35;
    
    if (wrinkledIndex.floatValue > 0) {
        ParameterView *para4 = [[ParameterView alloc] initWithFrame:CGRectMake(0, y, 320, 30)];
        [self addSubview:para4];
        para4.delegate  = self;
        para4.indexName = @"WrinkledIndex";
        para4.nameLabel.text = @" 祛皱指数";
        [para4 setPercent:[wrinkledIndex isEqualToString:@""]?0:wrinkledIndex.intValue animated:YES];
        [self setupIndexViewClickEnabel:para4];
        
        y += 35;
    }
    
    int viewTag = 100;
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[ParameterView class]]) {
            view.tag = viewTag++;
            _ParameterViewCount++;
        }
    }
    
    [self.delegate heightOfParametersView:y];
    
    if (para1.clickEnable) {
        
        if (!para1.isSelected) {
            [para1.indexButton setImage:[UIImage imageNamed:@"指数按钮展开"] forState:UIControlStateNormal];
        }else{
            [para1.indexButton setImage:[UIImage imageNamed:@"指数按钮"] forState:UIControlStateNormal];
        }
        
        [self performSelector:@selector(parameterViewDidClicked:) withObject:para1 afterDelay:0.5];
    }
    
}

- (void)setupIndexViewClickEnabel:(ParameterView *)parameterView{
    if ([self ingredientsArrayWithIndexName:parameterView.indexName].count == 0) {
        [parameterView setClickEnableNo];
    }
}

- (void)setupIngredientsViewWithData:(NSArray *)array withproductDes:(NSString *)productDes{
    if (self.ingredientsView == nil) {
        IngredientsView *tempIngredientsView = [[IngredientsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        self.ingredientsView = tempIngredientsView;
        self.ingredientsView.ingredientsLightArray = self.ingredientsLightArray;
        self.ingredientsView.alpha    = 0;
        self.ingredientsView.delegate = self;
        [self addSubview:tempIngredientsView];
    }
    
    self.ingredientsViewHeight = [self.ingredientsView setIngredientsViewData:array withProductDes:productDes];
    
}

- (void)parameterViewAnimationClose{
    for (UIView *view in [self subviews]) {
        
        self.ingredientsView.alpha = 0;
        
        if ([view isKindOfClass:[ParameterView class]]) {
            
            [UIView animateWithDuration:0.25 animations:^{
                view.frame = CGRectMake(0, 5 + 35 * (view.tag - 100), kScreenWidth, 30);
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
    
}

- (void)parameterViewAnimation:(int)tag{
    
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[ParameterView class]]) {
            if (view.tag <= tag ) {
                [UIView animateWithDuration:0.25 animations:^{
                    view.frame = CGRectMake(0, 5 + 35 * (view.tag - 100), kScreenWidth, 30);
                } completion:^(BOOL finished) {
                    
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    view.frame = CGRectMake(0, 5 + 35 * (view.tag - 100) + self.ingredientsViewHeight, kScreenWidth, 30);
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if (view.tag != tag) {
                ParameterView *subView = (ParameterView *)view;
                subView.isSelected = NO;
                if (subView.clickEnable) {
                    [subView.indexButton setImage:[UIImage imageNamed:@"指数按钮"] forState:UIControlStateNormal];
                }
            }
            
        }
    }
    
    self.ingredientsView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        
    } completion:^(BOOL finished) {
        self.ingredientsView.frame = CGRectMake(0, 35 * (tag - 100) + 35, kScreenWidth, self.ingredientsViewHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.ingredientsView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

- (NSArray *)ingredientsArrayWithIndexName:(NSString *)indexName{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in self.ingredientsArray) {
        if ([dic[@"ingreIndex"] isEqualToString:indexName]) {
            [array addObject:dic];
        }
    }
    
    return array;
}

#pragma mark - ParameterViewDelegate

- (void)parameterViewDidClicked:(ParameterView *)parameterView{
    if (!parameterView.isSelected) {
        NSArray *ingredientsArray = [self ingredientsArrayWithIndexName:parameterView.indexName];
        
        if (self.productDesDic == nil) {
            [self setupIngredientsViewWithData:ingredientsArray withproductDes:nil];
        }else{
            [self setupIngredientsViewWithData:ingredientsArray withproductDes:self.productDesDic[parameterView.indexName]];
        }
        
        [self parameterViewAnimation:parameterView.tag];
        
        self.frame = CGRectMake(0, self.frame.origin.y, kScreenWidth, 5 + 35 * _ParameterViewCount + self.ingredientsViewHeight);
    }else{
        [self parameterViewAnimationClose];
        
        self.frame = CGRectMake(0, self.frame.origin.y, kScreenWidth, 5 + 35 * _ParameterViewCount);
    }
    
    if (!parameterView.isSelected) {
        [parameterView.indexButton setImage:[UIImage imageNamed:@"指数按钮展开"] forState:UIControlStateNormal];
    }else{
        [parameterView.indexButton setImage:[UIImage imageNamed:@"指数按钮"] forState:UIControlStateNormal];
    }
    
    parameterView.isSelected = !parameterView.isSelected;
    
    [self.delegate heightOfParametersView:self.frame.size.height];
}

#pragma mark - IngredientsViewDelegate

- (void)ingredientsViewDidTaped:(IngredientView *)ingredientView{
    [self.delegate ingredientLabelDidTouched:ingredientView];
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
