//
//  NSMutableAttributedString+Line.m
//  CTTest
//
//  Created by chiery on 2016/8/15.
//  Copyright © 2016年 My-Zone. All rights reserved.
//

#import "NSAttributedString+Line.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Line)

- (CGFloat)lineHeight {
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    // get bounds info
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CFRelease(line);
    return ceilf(ascent + descent);
}

- (CGFloat)height {
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CGFloat height = CTLineGetBoundsWithOptions(line,kCTLineBoundsIncludeLanguageExtents).size.height;
    CFRelease(line);
    return ceilf(height);
}

- (CGFloat)width {
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CGFloat width = CTLineGetBoundsWithOptions(line,kCTLineBoundsExcludeTypographicLeading).size.width;
    CFRelease(line);
    return ceilf(width);
}

/* 切记这里不能广泛使用，只适用于当前场景
 * 这里只拿到第一个font就结束，这里不会存在更多当前对象
 */
- (UIFont *)font {
    __block UIFont *font = nil;
    [self enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, self.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        font = (UIFont *)value;
        *stop = YES;
    }];
    return font;
}


@end
