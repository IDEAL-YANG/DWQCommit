//
//  DWQRatingView.m
//  Five-star-rating
//
//  Created by 杜文全 on 15/2/13.
//  Copyright © 2015年 com.sdsj.duwenquan. All rights reserved.
//

#import "DWQRatingView.h"
#import "DWQStarView.h"

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#define intToLong long
#define StringFormat(x) [NSString stringWithFormat:@"%ld",(long)x]
#else
#define intToLong int
#define StringFormat(x) [NSString stringWithFormat:@"%d",x]
#endif

#define WeakSelf(_self_)\
__weak typeof(_self_) weakself = _self_;\

#define StrongSelf(_self_)\
__strong typeof(weak##_self_) self = weak##_self_;

static NSString *scoreFormat = @"0.00";//分数格式化样式 依据四舍五入

//格式化小数 四舍五入类型
extern float decimalwithFormat(NSString * format, float floatV) {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [[numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]] floatValue];
}

@interface DWQRatingView() {
    UIView *_yelloView; //金色星星视图
    UIView *_grayView;  //灰色星星
    UIColor *_normalColor;
    UIColor *_highlightColor;
    CGFloat _yellowWidthPercent;
    NSInteger _totalStart;
}

@end


@implementation DWQRatingView

#pragma mark --- 方法调用

+ (instancetype)initWithPoint:(CGPoint)point withSize:(float)size
{
    return [[self alloc] initWithPoint:point withSize:size];
}

+ (instancetype)initWithPoint:(CGPoint)point withSize:(float)size totalStart:(NSInteger)totalStart {
    return [[self alloc] initWithPoint:point withSize:size totalStart:totalStart];
}

- (instancetype)initWithPoint:(CGPoint)point withSize:(float)size
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, size*5, size)];
    if (self) {
        _totalStart = 5;
        [self _initViews];
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point withSize:(float)size totalStart:(NSInteger)totalStart
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, size*totalStart, size)];
    if (self) {
        _totalStart = totalStart;
        [self _initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _totalStart = 5;
        [self _initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _initViews];
}

- (void)_initViews
{
    /* 显示五个星星设计原理
     图片只提供了一个星星，要显示五个星星：
     首先，压缩一个星星图片为固定大小。使用colorWithPatternImage把一个星星当成color传进去，然后再设置图片的仿射变换，缩放比率用固定的大小除以图片原来的大小，这样不管一个星星图片有多大，始终显示为固定的大小。
     其次，使用colorWithPatternImage方法的时候，当图片的大小 小于等于 要设置的视图的大小的时候，图片会平铺，这样就达到了显示五个星星的目的。
     这样设计更精炼，无需太多代码和复杂的逻辑
     */
    
    //1.初始化灰色星星
    _grayView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_grayView];
    
    //2.初始化金色星星
    _yelloView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_yelloView];
    self.userInteractionEnabled = YES;
    
    _normalColor = [UIColor grayColor];
    
    _highlightColor = [UIColor yellowColor];
    
    _yellowWidthPercent = 1;
    
    _canTouch = YES;
    
    _scoreNum = [NSNumber numberWithInteger:_totalStart];
    
    _needIntValue = NO;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setScoreNum:(NSNumber *)scoreNum
{
    if (_scoreNum != scoreNum) {
        if ([scoreNum floatValue] > _totalStart) {
            _scoreNum = [NSNumber numberWithInteger:_totalStart];
        }else if (scoreNum < 0){
            _scoreNum = @0;
        }
        _scoreNum = scoreNum;
    }
    [self setNeedsLayout];
}

- (void)setNormalColor:(UIColor *)normalColor {
    if (_normalColor) {
        _normalColor = nil;
    }
    _normalColor = normalColor;
    [self setNeedsLayout];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    if (_highlightColor) {
        _highlightColor = nil;
    }
    _highlightColor = highlightColor;
    [self setNeedsLayout];
}

- (void)setCanTouch:(BOOL)canTouch
{
    _canTouch = canTouch;
    self.userInteractionEnabled = canTouch;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //5个星星铺满后的宽度
    CGFloat grayWidth = self.frame.size.height * _totalStart;
    
    CGFloat grayHight = self.frame.size.height;
    
    //压缩星星
    UIImage *grayImg = [DWQStarView getStarWithRadius:grayHight withFillColor:_normalColor];
    
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    _grayView.transform = CGAffineTransformMakeScale(grayHight/grayImg.size.width, grayHight/grayImg.size.height);
    
    UIImage *yelloImg = [DWQStarView getStarWithRadius:grayHight withFillColor:_highlightColor];
    
    _yelloView.backgroundColor = [UIColor colorWithPatternImage:yelloImg];
    _yelloView.transform = CGAffineTransformMakeScale(grayHight/yelloImg.size.width, grayHight/yelloImg.size.height);
    
    NSLog(@"begin: %.2f",_yellowWidthPercent);
    
    _grayView.frame = CGRectMake(0, 0, grayWidth, grayHight);
    _yelloView.frame = CGRectMake(0, 0, _yellowWidthPercent * grayWidth, grayHight);
    
    float score = [_scoreNum floatValue];
    
    //分数的百分比
    float percent = score/_totalStart;
    
    //根据分数的百分比调整_yelloView视图的宽度
    CGRect rect = _yelloView.frame;
    
    rect.size.width = percent * grayWidth;
    
    _yellowWidthPercent = percent;
    
    [UIView animateWithDuration:0.15 animations:^{
        _yelloView.frame = rect;
    }];
}

#pragma mark -- touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setUpScoreWithTouch:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setUpScoreWithTouch:touches];
}

#pragma mark -- 处理touch事件
- (void)setUpScoreWithTouch:(NSSet<UITouch *> *)touches
{
    if (!self.canTouch) {
        return;
    }
    
    float weight = self.frame.size.width;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    touchPoint.x = touchPoint.x > weight ? weight : (touchPoint.x < 0 ? 0 : touchPoint.x);
    
    float stringFloat = touchPoint.x;
    
    float a = decimalwithFormat(scoreFormat, _totalStart*stringFloat/weight);
    
    if (_needIntValue) {
        if (a >_totalStart) {
            a = _totalStart;
        }else if (a == 0) {
            a = 1;
        }else {
            a = ceil(a);
        }
    }
    
    self.scoreNum = [NSNumber numberWithFloat:a];
    
    [self setNeedsLayout];
    
    if (_scroreBlock) {
        _scroreBlock(_scoreNum);
    }
}
@end
