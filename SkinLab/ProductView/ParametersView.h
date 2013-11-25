//
//  ParametersView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-18.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterView.h"
#import "IngredientsView.h"


@protocol ParametersViewDelegate <NSObject>

- (void)heightOfParametersView:(float)Height;
- (void)ingredientLabelDidTouched:(IngredientView *)ingredientView;

@end

@interface ParametersView : UIView <ParameterViewDelegate, IngredientsViewDelegate>{
    int _ParameterViewCount;
}

@property (weak, nonatomic) id <ParametersViewDelegate> delegate;

@property (strong, nonatomic) NSArray         *ingredientsArray;
@property (strong, nonatomic) NSArray         *ingredientsLightArray;
@property (strong, nonatomic) NSDictionary    *productDesDic;
@property (strong, nonatomic) IngredientsView *ingredientsView;

@property (assign, nonatomic) float ingredientsViewHeight;

- (void)setupParametersoily:(NSString *)oilyIndex
                  pigmented:(NSString *)pigmentedIndex
                  wensitive:(NSString *)sensitiveIndex
                   wrinkled:(NSString *)wrinkledIndex
       withIngredientsArray:(NSArray *)array
             withproductDes:(NSDictionary *)desDic
             withLightArray:(NSArray*)lightArray;

@end
