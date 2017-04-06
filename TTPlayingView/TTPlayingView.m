//
//  PlayingView.m
//  TTPlayingView
//
//  Created by jiang on 2017/4/5.
//  Copyright © 2017年 jiang. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "TTPlayingView.h"

static const int kColumnNumber = 4;

@interface TTPlayingView ()

@property (nonatomic, assign) BOOL shouldAnimate;

@end

@implementation TTPlayingView

- (CAShapeLayer *)columnShapeLayer:(NSInteger)index frame:(CGRect)frame {
    
    CGFloat increment = (frame.size.width - kColumnNumber * _columnWidth) / (CGFloat)(kColumnNumber + 1.f);
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.frame = CGRectMake(increment * (index + 1) + index * _columnWidth, 0, _columnWidth, frame.size.height);
    
    shapeLayer1.lineWidth = _columnWidth;
    shapeLayer1.fillColor = _columnColor.CGColor;
    shapeLayer1.strokeColor = _columnColor.CGColor;
    shapeLayer1.path = [self pathOfColumnWithHeight:frame.size.width];
    shapeLayer1.strokeStart = 0;
    shapeLayer1.strokeEnd = 1;
    return shapeLayer1;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame colWidth:4.0f playingInterval:0.75f colColor:[UIColor whiteColor]];
}

- (instancetype)initWithFrame:(CGRect)frame
                     colWidth:(float)columnWidth
              playingInterval:(NSTimeInterval)timeInterval
                     colColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        if (CGRectEqualToRect(frame, CGRectZero)) {
            frame = CGRectMake(0, 0, 40.0f, 40.0f);
        }
        _columnWidth = (columnWidth < 0.0000001 && columnWidth > -0.0000001) ? 4.0f : columnWidth;
        _playingTimeInterval = (timeInterval < 0.0000001 && timeInterval > -0.0000001) ? 0.75f : timeInterval;
        _columnColor = color;
        
        for (int i = 0; i < kColumnNumber; i++) {
            CAShapeLayer *shapeLayer = [self columnShapeLayer:i frame:frame];
            [self.layer addSublayer:shapeLayer];
        }
    }
    return self;
}

#pragma mark - UIView Method Overrides

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self updateShouldAnimate];
    if (self.shouldAnimate) {
        [self p_resumeLayer];
    } else {
        [self p_pauseLayer];
    }
}


- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self updateShouldAnimate];
    if (self.shouldAnimate) {
        [self p_resumeLayer];
    } else {
        [self p_pauseLayer];
    }
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    
    [self updateShouldAnimate];
    if (self.shouldAnimate) {
        [self p_resumeLayer];
    } else {
        [self p_pauseLayer];
    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [self updateShouldAnimate];
    if (self.shouldAnimate) {
        [self p_resumeLayer];
    } else {
        [self p_pauseLayer];
    }
}

/**
 *  user custom hover style
 **/
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
            
            if (highlighted) {
                shapeLayer.strokeColor = [_columnColor colorWithAlphaComponent:0.7f].CGColor;
            } else {
                shapeLayer.strokeColor = _columnColor.CGColor;
            }
        }
    }];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(40.0f, 40.0f);
}

- (void)dealloc {
    [self tt_stopPlaying];
}

#pragma mark - control animation

- (void)updateShouldAnimate
{
    //from https://github.com/Flipboard/FLAnimatedImage/blob/master/FLAnimatedImage/FLAnimatedImageView.m
    BOOL isVisible = self.window && self.superview && ![self isHidden] && self.alpha > 0.0;
    self.shouldAnimate = isVisible;
}

- (void)p_pauseLayer {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)p_resumeLayer {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

//reset animation interval
- (void)setPlayingTimeInterval:(NSTimeInterval)playingTimeInterval {
    _playingTimeInterval = playingTimeInterval;
    
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        CAKeyframeAnimation *animation = (CAKeyframeAnimation *)[layer animationForKey:@"layer"];
        
        CAKeyframeAnimation *copyAnimation = [animation mutableCopy];
        copyAnimation.duration = playingTimeInterval;
        
        [layer removeAnimationForKey:@"layer"];
        [layer addAnimation:copyAnimation forKey:@"layer"];
    }];
}

//rest column view's color
- (void)setColumnColor:(UIColor *)columnColor {
    _columnColor = columnColor;
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
            shapeLayer.strokeColor = columnColor.CGColor;
            shapeLayer.fillColor = columnColor.CGColor;
        }
    }];
}

//rest column view's width
- (void)setColumnWidth:(float)columnWidth {
    _columnWidth = columnWidth;
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
            shapeLayer.lineWidth = columnWidth;
        }
    }];
}

- (void)tt_startPlaying {
    [self tt_stopPlaying];
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    
    //random values, user custom data.
    NSDictionary<NSNumber *, NSArray *> *values = @{@0 : @[@(0.35f), @(0.6f)],
                                                    @1 : @[@(0.4f), @(0.7f)],
                                                    @2 : @[@(0.25f), @(0.55f)],
                                                    @3 : @[@(0.30f), @(0.75f)] };
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        [layer addAnimation:[self columnAnimation:values[@(idx)]] forKey:@"layer"];
    }];
}

- (void)tt_stopPlaying {
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    [sublayers makeObjectsPerformSelector:@selector(removeAnimationForKey:) withObject:@"layer"];
}

#pragma mark - path & animations
/**
 *  column view path
 */
- (CGPathRef)pathOfColumnWithHeight:(CGFloat)height {
    UIBezierPath *columnPath = [UIBezierPath bezierPath];
    columnPath.lineJoinStyle = kCGLineJoinRound;
    columnPath.lineCapStyle = kCGLineCapRound;
    columnPath.lineWidth = _columnWidth;
    [columnPath moveToPoint:CGPointMake(_columnWidth * 0.5f, height)];
    [columnPath addLineToPoint:CGPointMake(_columnWidth * 0.5f, 0)];
    
    return columnPath.CGPath;
}

/**
 *  strokeEnd animation
 **/
- (CAKeyframeAnimation *)columnAnimation:(NSArray *)values {
    CAKeyframeAnimation *frameAnimation = [CAKeyframeAnimation animation];
    frameAnimation.keyPath = @"strokeEnd";
    frameAnimation.repeatCount = MAXFLOAT;
    frameAnimation.removedOnCompletion = YES;
    frameAnimation.fillMode = kCAFillModeForwards;
    frameAnimation.duration = _playingTimeInterval;
    frameAnimation.autoreverses = YES;
    frameAnimation.values = values;
    frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return frameAnimation;
}

#pragma mark - layout sublayers
- (void)layoutSubviews {
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return;
    }
    NSArray<CALayer *> *sublayers = [self.layer sublayers];
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
            
            CGFloat width = CGRectGetWidth(self.frame);
            CGFloat height = CGRectGetHeight(self.frame);
            CGFloat increment = (width - kColumnNumber * _columnWidth) / (CGFloat)(kColumnNumber + 1.f);
            shapeLayer.frame = CGRectMake(increment * (idx + 1) + idx * _columnWidth, 0, _columnWidth, height);
            shapeLayer.path = [self pathOfColumnWithHeight:height];
        }
    }];
}

@end

