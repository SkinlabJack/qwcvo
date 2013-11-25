//
//  NoteView.h
//  SkinLab
//
//  Created by Dai Qinfu on 13-5-30.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinLab.h"

@interface NoteView : UIView{
    UILabel  *_txtLabel;
    UIButton *_closeButton;
}

- (void)setNoteText:(NSString *)text;

@end
