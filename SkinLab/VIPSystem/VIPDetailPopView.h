//
//  VIPDetailPopView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-28.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@interface VIPDetailPopView : UIView

@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *priceLabel;

- (void)setupPopViewData:(NSDictionary *)dic;

@end
