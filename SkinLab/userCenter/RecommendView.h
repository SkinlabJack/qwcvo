//
//  RecommendView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-8-6.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@protocol RecommendViewDelegate <NSObject>

- (void)recommendViewDidClicked:(NSString *)productID;

@end

@interface RecommendView : UIView

@property (weak, nonatomic) id <RecommendViewDelegate> delegate;
@property (strong, nonatomic) UILabel     *descriptionLabel;
@property (strong, nonatomic) UILabel     *suggestionLabel;
@property (strong, nonatomic) UILabel     *nameLabel;
@property (strong, nonatomic) UILabel     *infoLabel;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) UIImageView *imageView;
@property (copy  , nonatomic) NSString    *productID;

@end
