//
//  ChatTextView.m
//  SkinLab
//
//  Created by Dai Qinfu on 13-10-31.
//  Copyright (c) 2013年 北京思然加互联网科技有限公司. All rights reserved.
//

#import "ChatTextView.h"

@implementation ChatTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textFont    = [UIFont systemFontOfSize:15];
        self.textColor   = [UIColor blackColor];
        self.lineSpacing = 5.0;
        self.text        = @"";
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showTextView:(NSString *)string {
    
    
}

- (float)getHeightOfTextView {
    return [self getRechTextViewHeightWithText:self.text viewWidth:self.frame.size.width font:self.textFont lineSpacing:self.lineSpacing];
}


- (void)drawRect:(CGRect)rect
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    //创建字体以及字体大小
    CTFontRef helvetica = CTFontCreateWithName((CFStringRef)self.textFont.fontName, self.textFont.pointSize, NULL);
    
    //添加字体目标字符串从下标0开始到字符串结尾
    [attributedString addAttribute:(id)kCTFontAttributeName
                             value:(__bridge id)helvetica
                             range:NSMakeRange(0, [self.text length])];
    
    //设置颜色
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0,self.text.length)];
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTJustifiedTextAlignment;//这种对齐方式会自动调整，使左右始终对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    
    //创建文本行间距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize = sizeof(self.lineSpacing);
    lineSpaceStyle.value = &_lineSpacing;
    
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        alignmentStyle,lineSpaceStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    
    //给字符串添加样式attribute
    [attributedString addAttribute:(id)kCTParagraphStyleAttributeName
                             value:(__bridge id)paragraphStyle
                             range:NSMakeRange(0, [self.text length])];
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //修正坐标系
    CGAffineTransform textTran = CGAffineTransformIdentity;
    textTran = CGAffineTransformMakeTranslation(0.0, self.bounds.size.height);
    textTran = CGAffineTransformScale(textTran, 1.0, -1.0);
    CGContextConcatCTM(context, textTran);
    
    CTFrameDraw(leftFrame,context);

}

- (CGFloat)getRechTextViewHeightWithText:(NSString *)text
                               viewWidth:(CGFloat)width
                                    font:(UIFont *)font
                             lineSpacing:(CGFloat)lineSpacing;
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字体
    CTFontRef aFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0, attString.length)];
    CFRelease(aFont);
    
    int lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    float drawLineX = 0;
    float drawLineY = 0;
    BOOL drawFlag = YES;
    
    while(drawFlag)
    {
        CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,width);
    check:  lineRange = CFRangeMake(lineRange.location,testLineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        //边界检查
        CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
        CGFloat lastRunAscent;
        CGFloat laseRunDescent;
        CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
        CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
        
        if ((lastRunWidth + lastRunPointX) > width)
        {
            testLineLength--;
            CFRelease(line);
            goto check;
        }
        
        CFRelease(line);
        
        if(lineRange.location + lineRange.length >= attString.length)
        {
            drawFlag = NO;
        }
        
        lineCount++;
        drawLineY += font.ascender + (- font.descender) + lineSpacing;
        lineRange.location += lineRange.length;
    }
    CFRelease(typeSetter);
    return drawLineY;
}


@end
