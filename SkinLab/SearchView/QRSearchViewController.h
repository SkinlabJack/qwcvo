//
//  QRSearchViewController.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-9-10.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ZBarReaderViewController.h"
#import "SkinLab.h"

@interface QRSearchViewController : ZBarReaderViewController

@property (strong, nonatomic) UIView *upDateView;

- (void)showUpdateView:(BOOL)show;

@end
