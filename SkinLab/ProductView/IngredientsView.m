//
//  IngredientsView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "IngredientsView.h"

#define IngreWidth 275

@implementation IngredientsView

- (void)dealloc
{
    DLog(@"IngredientsView dealloc");
    
    self.delegate = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (float)setIngredientsViewData:(NSArray *)array withProductDes:(NSString *)productDes{
    
    DLog(@"%@", self.ingredientsLightArray)
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    float x = 10;
    float y = 10;
    
    if (![DataCenter isNull:array] && array.count != 0) {
        if (productDes != nil) {
            CGSize labelsize = [productDes sizeWithFont:[UIFont systemFontOfSize:13]
                                      constrainedToSize:CGSizeMake(265, 400)
                                          lineBreakMode:UILineBreakModeWordWrap];
            
            
            UITextView *tempView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 265, labelsize.height + 30)];
            self.textView = tempView;
            self.textView.font = [UIFont boldSystemFontOfSize:13];
            self.textView.textColor = TextGrayColor;
            self.textView.scrollEnabled = NO;
            self.textView.editable  = NO;
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.text = productDes;
            [self addSubview:self.textView];
            
            y += labelsize.height + 50;
        }
        
        for (int i = 0; i < array.count; i++) {
            
            NSArray  *textArray   = [array[i][@"ingreName"] componentsSeparatedByString:@"（"];
            NSString *infoString  = [array[i][@"ingreLabel"] stringByReplacingOccurrencesOfString:@"@@" withString:@","];
            
            IngredientView *label = [[IngredientView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
            label.delegate        = self;
            label.ingredientID    = array[i][@"ingreID"];
            label.ingredientDes   = array[i][@"ingreDes"];
            [self addSubview:label];
            
            if ([self shouldHighLight:array[i][@"ingreID"]]) {
                [label setViewHighLight];
            }
            
            float labelWidth = [label setIngredientViewData:textArray[0] info:infoString];
            
            if (x + labelWidth > IngreWidth) {
                
                if (labelWidth < 60) {
                    label.frame = CGRectMake(10, y + 35, 60, 25);
                    x = 20 + 60;
                    y = y + 35;
                }else{
                    label.frame = CGRectMake(10, y + 35, labelWidth, 25);
                    x = 20 + labelWidth;
                    y = y + 35;
                }
                
            }else{
                
                if (labelWidth < 60) {
                    label.frame = CGRectMake(x, y , 60, 25);
                    x = x + 60 + 10;
                    y = y;
                }else{
                    label.frame = CGRectMake(x, y , labelWidth, 25);
                    x = x + labelWidth + 10;
                    y = y;
                }
                
            }
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(294, 10, 2, y + 15)];
        line.backgroundColor = GreenColor;
        [self addSubview:line];
        
        return y + 30;
    }else{
        return 0;
    }
    
}

- (BOOL)shouldHighLight:(NSString *)ingredientID{
    
    for (NSString *ID in self.ingredientsLightArray) {
        if ([ID isEqualToString:ingredientID]) {
            return YES;
        }
    }
    
    return  NO;
}

#pragma mark - IngredientsViewDelegate

- (void)ingredientViewDidTaped:(IngredientView *)ingredientView{
    [self.delegate ingredientsViewDidTaped:ingredientView];
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
