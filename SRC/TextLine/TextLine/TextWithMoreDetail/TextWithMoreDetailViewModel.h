//
//  TextWithMoreDetailViewModel.h
//  TextLine
//
//  Created by HanDong Wang on 2018/4/18.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface TextWithMoreDetailViewModel : NSObject

/**
 折叠时的排版信息
 */
@property (nonatomic, readonly) CTFramesetterRef foldFrameSetterRef;

/**
 展开时的排版信息
 */
@property (nonatomic, readonly) CTFramesetterRef openFrameSetterRef;

/**
 点击加载更多在view中的位置
 */
@property (nonatomic, assign, readonly) CGRect moreDetailTextRect;

/**
 折叠在View中的位置
 */
@property (nonatomic, assign, readonly) CGRect foldTextRect;

/**
 当前折叠文本完成绘制时需要的高度
 */
@property (nonatomic, assign, readonly) CGFloat foldDrawContextNeededHeight;

/**
 当前折叠文本完成绘制时需要的高度
 */
@property (nonatomic, assign, readonly) CGFloat openDrawContextNeededHeight;

/**
 是否处于折叠状态，默认折叠
 */
@property (nonatomic, assign, readonly) BOOL isFold;

/**
 当前文案是否能够折叠，numberOfLine ！= 0， 文案足够多到行数超过指定的行数才能够折叠
 */
@property (nonatomic, assign, readonly) BOOL canFold;

/**
 折叠行为
 */
- (void)fold;

/**
 打开行为
 */
- (void)open;

/**
 便捷初始化方法

 @param string 主体信息文本
 @param stringColor 文本信息的颜色
 @param stringFont 文本信息的文字信息
 @param stringParagraphHeight 文本段落信息
 @param numberOfLine 最多展示的行数
 @param width 文本展示给定的宽度
 @param moreString 加载更多自定义文案
 @param moreStringColor 加载更多自定义文案的颜色
 @param foldString 折叠自定义文案
 @param foldStringColor 折叠自定义文案的颜色
 @param fold 当前文本是否被展开
 @return 当前实例对象
 */
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
                          fold:(BOOL)fold;

@end
