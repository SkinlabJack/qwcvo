//
//  SimilarProductView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-7-19.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductImageView.h"
#import "SkinLab.h"

@protocol SimilarProductViewDelegate <NSObject>

- (void)productImageDidClicked:(NSString *)productID;

@end

@interface SimilarProductView : UIView <ProductImageViewDealegate>{
    
}

@property (weak, nonatomic) id <SimilarProductViewDelegate> delegate;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel      *textLabel;

- (void)setSimilarProduct:(NSArray *)productArray;

@end
