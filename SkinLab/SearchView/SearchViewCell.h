//
//  SearchViewCell.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-4-25.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@class SearchViewCell;

@interface SearchViewCell : UITableViewCell{
    
}

@property (strong, nonatomic) UIImageView *productImage;
@property (strong, nonatomic) UILabel     *productName;
@property (strong, nonatomic) UILabel     *productBrand;
@property (strong, nonatomic) UILabel     *productInfo;

@property (copy  , nonatomic) NSString  *taobaoURL;
@property (assign, nonatomic) NSInteger index;


@end
