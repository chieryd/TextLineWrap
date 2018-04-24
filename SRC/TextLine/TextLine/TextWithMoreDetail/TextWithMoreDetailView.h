//
//  TextWithMoreDetailView.h
//  TextLine
//
//  Created by HanDong Wang on 2018/4/18.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextWithMoreDetailViewModel;

typedef void(^actionCallback) (BOOL isFold);

@interface TextWithMoreDetailView : UIView


/**
 点击加载更多/收起的调用
 */
@property (nonatomic, copy) actionCallback actionCallback;


/**
 编辑初始化方法

 @param frame 边框
 @param model 初始数据源
 @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                     andModel:(TextWithMoreDetailViewModel *)model;


/**
 设置数据源

 @param model 数据对象
 */
- (void)setModel:(TextWithMoreDetailViewModel *)model;

@end
