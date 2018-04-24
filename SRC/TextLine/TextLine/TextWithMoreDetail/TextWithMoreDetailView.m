//
//  TextWithMoreDetailView.m
//  TextLine
//
//  Created by HanDong Wang on 2018/4/18.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

#import "TextWithMoreDetailView.h"
#import "TextWithMoreDetailViewModel.h"
#import <CoreText/CoreText.h>

@interface TextWithMoreDetailView ()
@property (nonatomic, strong) TextWithMoreDetailViewModel *model;
@end

@implementation TextWithMoreDetailView

- (instancetype)initWithFrame:(CGRect)frame andModel:(TextWithMoreDetailViewModel *)model {
    if (self = [super initWithFrame:frame]) {
        [self configWithModel:model];
    }
    return self;
}

- (void)configWithModel:(TextWithMoreDetailViewModel *)model {
    _model = model;
    if (model.canFold) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    [self invalidateIntrinsicContentSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self invalidateIntrinsicContentSize];
    // 重新绘制
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 步骤 1  生成当前的环境
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 步骤 2  转换坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 步骤 3  生成绘制文字的path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    // 创建frameSetter
    CTFramesetterRef frameSetter = self.model.isFold ? self.model.foldFrameSetterRef : self.model.openFrameSetterRef;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CTFrameDraw(frame, context);
    CFRelease(frame);
}

#pragma mark - 用户事件
- (void)setModel:(TextWithMoreDetailViewModel *)model {
    [self configWithModel:model];
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.model.canFold) {
        CGPoint point = [gesture locationInView:self];
        if (self.model.isFold) {
            if (point.x >= _model.moreDetailTextRect.origin.x
                && point.x <= _model.moreDetailTextRect.origin.x + _model.moreDetailTextRect.size.width
                && point.y >= _model.moreDetailTextRect.origin.y
                && point.y <= _model.moreDetailTextRect.origin.y + _model.moreDetailTextRect.size.height) {
                [self.model open];
                if (self.actionCallback) {
                    self.actionCallback(NO);
                }
            }
        }
        else {
            if (point.x >= _model.foldTextRect.origin.x
                && point.x <= _model.foldTextRect.origin.x + _model.foldTextRect.size.width
                && point.y >= _model.foldTextRect.origin.y
                && point.y <= _model.foldTextRect.origin.y + _model.foldTextRect.size.height) {
                [self.model fold];
                if (self.actionCallback) {
                    self.actionCallback(YES);
                }
            }
        }
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CGRectGetWidth(self.bounds), ceil(self.model.isFold ? self.model.foldDrawContextNeededHeight : self.model.openDrawContextNeededHeight));
}

@end
