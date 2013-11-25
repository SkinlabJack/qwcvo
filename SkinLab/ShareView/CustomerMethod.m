//
//  CustomerMethod.m
//  tryseason
//
//  Created by Dai Qinfu on 12-8-24.
//  Copyright (c) 2012年 Dai Qinfu. All rights reserved.
//

#import "CustomerMethod.h"

@implementation CustomerMethod

+ (NSString *)createName{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps     = [calendar components:unitFlags fromDate:now];
    int year  = [comps year];
    int month = [comps month];
    int day   = [comps day];
    int hour  = [comps hour];
    int min   = [comps minute];
    int sec   = [comps second];
    
    NSString *name = [NSString stringWithFormat:@"%d%d%d%d%d%d%@",year,month,day,hour,min,sec,[DataCenter shareData].deviceID];
    return name;
}

+ (NSString *)getNowDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps     = [calendar components:unitFlags fromDate:now];
    int year  = [comps year];
    int month = [comps month];
    int day   = [comps day];
    
    NSString *date = [NSString stringWithFormat:@"%d%d%d",year,month,day];
    return date;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (NSString *)createDatelabel:(NSString *)dataString mode:(DateMode)dateMode{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    int intyear  = [comps year];
    int intmonth = [comps month];
    int intday   = [comps day];
    
    NSString *newYear;
    NSString *newMonth;
    NSString *newDay;
    
    newYear = [NSString stringWithFormat:@"%d",intyear];
    
    if (intmonth < 10) {
        newMonth = [NSString stringWithFormat:@"0%d",intmonth];
    }else{
        newMonth = [NSString stringWithFormat:@"%d",intmonth];
    }
    
    if (intday < 10) {
        newDay = [NSString stringWithFormat:@"0%d",intday];
    }else{
        newDay = [NSString stringWithFormat:@"%d",intday];
    }
    
    NSString *year = [dataString substringWithRange:NSMakeRange(0,4)];
    NSString *month = [dataString substringWithRange:NSMakeRange(5,2)];
    NSString *day = [dataString substringWithRange:NSMakeRange(8,2)];
    NSString *hour = [dataString substringWithRange:NSMakeRange(11,2)];
    NSString *min = [dataString substringWithRange:NSMakeRange(14,2)];
    
    NSString *nowDate = [NSString stringWithFormat:@"%@%@%@",newYear,newMonth,newDay];
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    
    switch (dateMode) {
        case DateModeAuto:
            if ([nowDate intValue] > [finalString intValue]) {
                return [NSString stringWithFormat:@"%@月%@日",month,day];
            }else{
                return [NSString stringWithFormat:@"今天%@:%@",hour,min];
            }
            break;
            
        case DateModeDayAndMonth:
            return [NSString stringWithFormat:@"%@月%@日",month,day];
            break;
            
        case DateModeHourAndMin:
            return [NSString stringWithFormat:@"今天%@:%@",hour,min];
            break;
            
        default:
            break;
    }
    
}


+ (NSString *)createAlertlabel:(NSString *)dataString{
    NSString *hour = [dataString substringWithRange:NSMakeRange(11,2)];
    NSString *min = [dataString substringWithRange:NSMakeRange(14,2)];
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}


+ (UIImage *)rotateImage:(UIImage *)aImage
{
    
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    
    switch(orient)
    
    {
            
        case UIImageOrientationUp: //EXIF = 1
            
            transform = CGAffineTransformIdentity;
            
            break;
            
            
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            break;
            
            
            
        case UIImageOrientationDown: //EXIF = 3
            
            transform = CGAffineTransformMakeTranslation(width, height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            
            transform = CGAffineTransformMakeTranslation(0.0, height);
            
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, width);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationLeft: //EXIF = 6
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(0.0, width);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationRight: //EXIF = 8
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
        
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
    
}
@end
