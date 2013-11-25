//
//  ProductImageView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-23.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@class ProductImageView;

@protocol ProductImageViewDealegate <NSObject>

- (void)productImageDidClicked:(NSString *)productID;

@end

@interface ProductImageView : UIView{
    
}

@property (weak, nonatomic) id <ProductImageViewDealegate> delegate;
@property (strong, nonatomic) UIImageView *productImage;
@property (strong, nonatomic) UILabel     *productBrandLabel;
@property (strong, nonatomic) UILabel     *productNameLabel;
@property (copy  , nonatomic) NSString    *productID;

@end
