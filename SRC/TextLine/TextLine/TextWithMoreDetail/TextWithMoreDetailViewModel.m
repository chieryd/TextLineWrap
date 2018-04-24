//
//  TextWithMoreDetailViewModel.m
//  TextLine
//
//  Created by HanDong Wang on 2018/4/18.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

#import "TextWithMoreDetailViewModel.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+Line.h"

@interface TextWithMoreDetailViewModel ()
@property (nonatomic, readwrite) CTFramesetterRef foldFrameSetterRef;
@property (nonatomic, readwrite) CTFramesetterRef openFrameSetterRef;
@property (nonatomic, assign, readwrite) CGFloat foldDrawContextNeededHeight;
@property (nonatomic, assign, readwrite) CGFloat openDrawContextNeededHeight;
@property (nonatomic, assign, readwrite) CGRect moreDetailTextRect;
@property (nonatomic, assign, readwrite) CGRect foldTextRect;
@property (nonatomic, assign, readwrite) BOOL canFold;
@property (nonatomic, assign, readwrite) BOOL isFold;


@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSAttributedString *moreDetailAttributedString;
@property (nonatomic, strong) NSAttributedString *foldAttributedString;
@property (nonatomic, assign) NSInteger numberOfLine;
@property (nonatomic, assign) CGFloat drawContextWidth;
@property (nonatomic, assign) CGFloat stringParagraphHeight;
@property (nonatomic, strong) NSDictionary *attributedDictionary;

@end

@implementation TextWithMoreDetailViewModel

- (void)dealloc {
    CFRelease(_foldFrameSetterRef);
    CFRelease(_openFrameSetterRef);
}

- (instancetype)initWithString:(NSString *)string
                   stringColor:(UIColor *)stringColor
                    stringFont:(UIFont *)stringFont
         stringParagraphHeight:(CGFloat)stringParagraphHeight
                  numberOfLine:(NSInteger)numberOfLine
                         width:(CGFloat)width
                    moreString:(NSString *)moreString
               moreStringColor:(UIColor *)moreStringColor
                    foldString:(NSString *)foldString
               foldStringColor:(UIColor *)foldStringColor
                          fold:(BOOL)fold {
    if (self = [super init]) {
        [self configAttributedString:string
                         stringColor:stringColor
                          stringFont:stringFont
               stringParagraphHeight:stringParagraphHeight
                          moreString:moreString
                     moreStringColor:moreStringColor
                          foldString:foldString
                     foldStringColor:foldStringColor];
        
        _numberOfLine = numberOfLine;
        _drawContextWidth = width;
        _stringParagraphHeight = stringParagraphHeight;
        _isFold = fold;
        [self initConfig];
    }
    return self;
}

- (void)configAttributedString:(NSString *)string
                   stringColor:(UIColor *)stringColor
                    stringFont:(UIFont *)stringFont
         stringParagraphHeight:(CGFloat)stringParagraphHeight
                    moreString:(NSString *)moreString
               moreStringColor:(UIColor *)moreStringColor
                    foldString:(NSString *)foldString
               foldStringColor:(UIColor *)foldStringColor {
    NSMutableParagraphStyle *paragraph = [[ NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = stringParagraphHeight;
    _attributedDictionary = @{NSFontAttributeName : stringFont, NSParagraphStyleAttributeName : paragraph};
    
    NSMutableDictionary *dict1 = [_attributedDictionary mutableCopy];
    [dict1 setValue:stringColor forKey:NSForegroundColorAttributeName];
    
    NSMutableDictionary *dict2 = [_attributedDictionary mutableCopy];
    [dict2 setValue:moreStringColor forKey:NSForegroundColorAttributeName];
    
    NSMutableDictionary *dict3 = [_attributedDictionary mutableCopy];
    [dict3 setValue:foldStringColor forKey:NSForegroundColorAttributeName];
    
    _attributedString = [[NSAttributedString alloc] initWithString:string attributes:dict1];
    _moreDetailAttributedString = [[NSAttributedString alloc] initWithString:moreString attributes:dict2];
    _foldAttributedString = [[NSAttributedString alloc] initWithString:foldString attributes:dict3];
}

- (void)initConfig {
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,self.drawContextWidth,CGFLOAT_MAX));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    // 这里得到需要绘制的CTLine数组
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CFRelease(frame);
    
    if (_numberOfLine != 0) {
        [self startComputeWithLines:lines frameSetter:frameSetter];
    }
    else {
        [self realNumberOfLineLessThanCustomer:lines];
    }
}

#pragma mark - 行为函数
- (void)fold {
    if (_canFold && _isFold == NO) {
        _isFold = YES;
    }
}

- (void)open {
    if (_canFold && _isFold == YES) {
        _isFold = NO;
    }
}



#pragma mark - 计算函数
- (void)realNumberOfLineLessThanCustomer:(NSArray *)lines {
    _isFold = NO;
    _canFold = NO;
    _openFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(self.attributedString));
    
    
    CGFloat tempHeight = [self heightByLineCount:lines.count withLines:lines];
    if (lines.count > 0) {
        tempHeight += ((lines.count - 1) * self.stringParagraphHeight);
    }
    _openDrawContextNeededHeight = ceilf(tempHeight);
}

- (void)handleMoreDetailFrameSetter:(CTFramesetterRef)frameSetter lines:(NSArray *)lines {
    if (lines.count > 0) {
        // 拿出对应自定义行数的line对象，做相关操作
        CTLineRef lineRef = (__bridge CTLineRef)(lines[self.numberOfLine - 1]);
        CFRange range = CTLineGetStringRange(lineRef);
        
        // 计算出“点击记载更多需要的react”
        NSMutableAttributedString *tempMoreDetailString = [[[NSAttributedString alloc] initWithString:@" " attributes:self.attributedDictionary] mutableCopy];
        [tempMoreDetailString appendAttributedString:self.moreDetailAttributedString];
        
        // 当前range中的attributedString
        NSAttributedString *lineRangeAttributedString = [self.attributedString attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        
        // 在当前行中除去这个宽度之后能够显示的文字范围
        CGMutablePathRef pathTemp = CGPathCreateMutable();
        CGRect tempRect = CGRectMake(0, 0, self.drawContextWidth - ceilf(tempMoreDetailString.width), lineRangeAttributedString.height);
        CGPathAddRect(pathTemp, NULL, tempRect);
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(range.location, range.length), pathTemp, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        CFRelease(frame);
        CFRelease(pathTemp);
        
        // 这里得到需要绘制的frameRange,那么在折行时显示的文本就是
        NSAttributedString *lastLineAttributedString = [self.attributedString attributedSubstringFromRange:NSMakeRange(frameRange.location, frameRange.length)];
        NSMutableAttributedString *tempMutableAttributedString = [[self.attributedString attributedSubstringFromRange:NSMakeRange(0, range.location + frameRange.length)]  mutableCopy];
        [tempMutableAttributedString appendAttributedString:tempMoreDetailString];
        
        CGFloat tempHeight = [self heightByLineCount:self.numberOfLine withLines:lines];
        tempHeight += ((self.numberOfLine - 1) * self.stringParagraphHeight);
        
        _foldFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(tempMutableAttributedString));
        _foldDrawContextNeededHeight = ceilf(tempHeight);
        _moreDetailTextRect = CGRectMake(lastLineAttributedString.width, _foldDrawContextNeededHeight - ceilf(tempMoreDetailString.height), ceilf(tempMoreDetailString.width), ceilf(tempMoreDetailString.height));
    }
}

- (void)handleOpenFrameSetter:(CTFramesetterRef)frameSetter lines:(NSArray *)lines {
    if (lines.count > 0) {
        // 全部展开的文案也知道了,这里需要避开一个问题，当折叠的文案追加到当前显示的文案上时，只能显示折叠文案的部分文字，这个时候就需要换行显示了
        NSMutableAttributedString *tempMutableString = [[[NSAttributedString alloc] initWithString:@" " attributes:self.attributedDictionary] mutableCopy];
        [tempMutableString appendAttributedString:self.foldAttributedString];
        // 当前文字最后一行的宽度
        CTLineRef lineRefTemp = (__bridge CTLineRef)(lines.lastObject);
        CFRange LineRange = CTLineGetStringRange(lineRefTemp);
        NSAttributedString *lastLineRangeAttributedString = [self.attributedString attributedSubstringFromRange:NSMakeRange(LineRange.location, LineRange.length)];
        
        CGFloat lastLineAttributesStringWidth = ceilf(lastLineRangeAttributedString.width);
        NSMutableAttributedString *notFoldMutableAttributedString = [self.attributedString mutableCopy];
    
        CGFloat tempHeight = [self heightByLineCount:lines.count withLines:lines];
        
        BOOL foldLine = NO;
        if (lastLineAttributesStringWidth + ceilf(tempMutableString.width) > self.drawContextWidth) {
            [notFoldMutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            tempHeight += ((lines.count) * self.stringParagraphHeight);
            tempHeight += [self.foldAttributedString lineHeight];
            foldLine = YES;
        }
        else {
            [notFoldMutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:self.attributedDictionary]];
            tempHeight += ((lines.count - 1) * self.stringParagraphHeight);
        }
        [notFoldMutableAttributedString appendAttributedString:self.foldAttributedString];
        _openFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(notFoldMutableAttributedString));
        _openDrawContextNeededHeight = ceilf(tempHeight);
        _foldTextRect = CGRectMake(foldLine ? 0 : lastLineAttributesStringWidth, _openDrawContextNeededHeight - ceilf(self.foldAttributedString.height), ceilf(self.foldAttributedString.width), ceilf(self.foldAttributedString.height));
    }
}

- (void)handleNumberOfLineGreatThanCustomer:(NSArray *)lines frameSetter:(CTFramesetterRef)frameSetter {
    [self handleMoreDetailFrameSetter:frameSetter lines:lines];
    [self handleOpenFrameSetter:frameSetter lines:lines];
    CFRelease(frameSetter);
}

- (CGFloat)heightByLineCount:(NSInteger)count withLines:(NSArray *)lines {
    CGFloat tempHeight = 0;
    if (count > 0 && lines.count > 0) {
        for (NSInteger i = 0; i < count; i ++) {
            CGFloat ascent;
            CGFloat descent;
            CGFloat leading;
            // get bounds info
            CTLineRef lineRef = (__bridge CTLineRef)(lines[i]);
            CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
            tempHeight += (ascent + descent);
        }
    }
    return tempHeight;
}

- (void)startComputeWithLines:(NSArray *)lines frameSetter:(CTFramesetterRef)frameSetter {
    if (lines.count <= self.numberOfLine) {
        [self realNumberOfLineLessThanCustomer:lines];
        CFRelease(frameSetter);
    }
    else {
        _canFold = YES;
        [self handleNumberOfLineGreatThanCustomer:lines frameSetter:frameSetter];
    }
}

@end
