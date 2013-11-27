//
//  IngredientsDetailView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-14.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "IngredientsDetailView.h"

@implementation IngredientsDetailView

- (void)dealloc
{
    DLog(@"IngredientsDetailView dealloc");
    
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _backImage.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        _backImage.image = [UIImage imageNamed:@"成分详情背景"];
        _backImage.userInteractionEnabled = YES;
        [self addSubview:_backImage];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 6, 50, 30)];
        [backButton setTitle:@"关闭" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backImage addSubview:backButton];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 44, 300, 260)];
        _scrollView.showsVerticalScrollIndicator = NO;
        [_backImage addSubview:_scrollView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth - 50, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor       = BlackColor;
        _nameLabel.font            = [UIFont boldSystemFontOfSize:20];
        [_scrollView addSubview:_nameLabel];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, kScreenWidth - 50, 20)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = TextGrayColor;
        _textLabel.font = [UIFont systemFontOfSize:14];
        [_scrollView addSubview:_textLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClicked:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setIngredientView:(NSDictionary *)dic{
    
    [self cleanView];
    
    if (![IOHelper isNull:dic[@"ingreName"]]) {
        self.nameLabel.text = dic[@"ingreName"];
    }
    
    if (![IOHelper isNull:dic[@"ingreCategory"]]) {
        self.textLabel.text = dic[@"ingreCategory"];
    }
    
    if (self.ingreDes != nil && ![self.ingreDes isEqualToString:@""]) {
        
        NSArray *array = [self.ingreDes componentsSeparatedByString:@"@@"];
        
        float height = 80;
        
        for (int i = 0; i < array.count; i++) {
//            NSString *tempString = [NSString stringWithFormat:@"%d.%@", i + 1, array[i]];
//            
//            CGSize labelsize = [tempString sizeWithFont:[UIFont systemFontOfSize:14]
//                                      constrainedToSize:CGSizeMake(280, 400)
//                                          lineBreakMode:UILineBreakModeWordWrap];
            
//            RCLabel *label  = [[RCLabel alloc] initWithFrame:CGRectMake(0, height, 280, labelsize.height + 10)];
//            label.font      = [UIFont systemFontOfSize:14];
//            label.textColor = BlackColor;
//            [self.scrollView addSubview:label];
//            [label release];
//            
//            height = height + labelsize.height + 20;
//            
//            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:tempString];
//            label.componentsAndPlainText = componentsDS;
            
            self.scrollView.contentSize = CGSizeMake(kScreenWidth - 50, height);
            
        }
        
    }else{
        if (![IOHelper isNull:dic[@"ingreDes"]]) {
            
            NSString *ingreString = [dic[@"ingreDes"] stringByReplacingOccurrencesOfString:@"'fontsize'" withString:@"15"];
            ingreString = [ingreString stringByReplacingOccurrencesOfString:@"$$" withString:@"@@"];
            NSArray *array = [ingreString componentsSeparatedByString:@"@@"];
            
            float height = 80;
            
            for (int i = 0; i < array.count; i++) {
//                NSString *tempString = [NSString stringWithFormat:@"%d.%@", i + 1, array[i]];
//                tempString = [tempString stringByReplacingOccurrencesOfString:@"<font size=15 color='#2bb8d1'>" withString:@""];
//                tempString = [tempString stringByReplacingOccurrencesOfString:@"</font size=15 color='#2bb8d1'>" withString:@""];
//                
//                CGSize labelsize = [tempString sizeWithFont:[UIFont systemFontOfSize:14]
//                                          constrainedToSize:CGSizeMake(280, 400)
//                                              lineBreakMode:UILineBreakModeWordWrap];
                
//                RCLabel *label  = [[RCLabel alloc] initWithFrame:CGRectMake(0, height, 280, labelsize.height)];
//                label.font      = [UIFont systemFontOfSize:14];
//                label.textColor = BlackColor;
//                [self.scrollView addSubview:label];
//                [label release];
//                
//                height = height + labelsize.height + 10;
//                
//                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:tempString];
//                label.componentsAndPlainText = componentsDS;
                
                self.scrollView.contentSize = CGSizeMake(kScreenWidth - 50, height);
            }
        }

    }
    
}

- (void)cleanView{
    self.nameLabel.text = @"";
    self.textLabel.text = @"";
    self.ingreDes = @"";
    
    for (UIView *view in [self.scrollView subviews]) {
//        if ([view isKindOfClass:[RCLabel class]]) {
//            [view removeFromSuperview];
//        }
    }
}

- (IBAction)backButtonClicked:(id)sender{
    [self cleanView];
    [self removeFromSuperview];
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
