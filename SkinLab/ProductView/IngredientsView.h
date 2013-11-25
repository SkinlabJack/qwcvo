//
//  IngredientsView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientView.h"
#import "SkinLab.h"


@protocol IngredientsViewDelegate <NSObject>

- (void)ingredientsViewDidTaped:(IngredientView *)ingredientView;

@end

@interface IngredientsView : UIView <IngredientViewDelegate>{
    
}

@property (weak, nonatomic) id <IngredientsViewDelegate> delegate;
@property (strong, nonatomic) NSArray    *ingredientsDataArray;
@property (strong, nonatomic) NSArray    *ingredientsLightArray;
@property (strong, nonatomic) UITextView *textView;

- (float)setIngredientsViewData:(NSArray *)array withProductDes:(NSString *)productDes;

@end
