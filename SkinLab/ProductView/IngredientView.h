//
//  IngredientView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-24.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@class IngredientView;

@protocol IngredientViewDelegate <NSObject>

- (void)ingredientViewDidTaped:(IngredientView *)ingredientView;

@end

@interface IngredientView : UIView{
    
}

@property (weak, nonatomic) id <IngredientViewDelegate> delegate;
@property (strong, nonatomic) UIView   *line;
@property (strong, nonatomic) UILabel  *nameLabel;
@property (strong, nonatomic) UILabel  *infoLabel;
@property (copy  , nonatomic) NSString *ingredientID;
@property (copy  , nonatomic) NSString *ingredientDes;

- (float)setIngredientViewData:(NSString *)name info:(NSString *)info;
- (void)setViewHighLight;

@end
