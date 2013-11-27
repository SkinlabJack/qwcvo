//
//  CustomerMethod.h
//  tryseason
//
//  Created by Dai Qinfu on 12-8-24.
//  Copyright (c) 2012年 Dai Qinfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppHelper.h"

typedef enum{
    DateModeDayAndMonth,
    DateModeHourAndMin,
    DateModeAuto
}DateMode;

@interface CustomerMethod : NSObject

+ (NSString *)createName;
+ (NSString *)getNowDate;
+ (UIImage  *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage  *)rotateImage:(UIImage *)aImage;
+ (NSString *)createDatelabel:(NSString *)dataString mode:(DateMode)dateMode;
+ (NSString *)createAlertlabel:(NSString *)dataString;
    

@end
