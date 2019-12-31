//
//  DWQRatingView.h
//  Five-star-rating
//
//  Created by 杜文全 on 15/2/13.
//  Copyright © 2015年 com.sdsj.duwenquan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DWQScoreBlock)(NSNumber *scoreNumber);

@class DWQRatingView;

@interface DWQRatingView : UIView

#pragma mark -- 方法调用

/**
 *  initMethod
 *
 *  @param point x y坐标
 *  @param size  单个星星大小
 *
 *  @return GQRatingView
 */
+ (instancetype)initWithPoint:(CGPoint)point withSize:(float)size;

+ (instancetype)initWithPoint:(CGPoint)point withSize:(float)size totalStart:(NSInteger)totalStart;

/**
 *  分数是否显示为整数 如果为yes星星都是整个整个显示
 */
@property (nonatomic, assign) BOOL needIntValue;

/**
 *  默认为NO  星星是否可以点击
 */
@property (nonatomic, assign) BOOL canTouch;

/**
 *  如果touch为YES 这个也可以一起实现
 */
@property (nonatomic, copy) DWQScoreBlock scroreBlock;

/**
 *  初始分数    默认满分为5分 0 - 5
 */
@property (nonatomic,strong) NSNumber *scoreNum;

/**
 设置底色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 设置高亮颜色
 */
@property (nonatomic, strong) UIColor *highlightColor;
@end
