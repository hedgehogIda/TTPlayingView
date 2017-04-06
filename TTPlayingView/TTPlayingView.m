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

- (void)dealloc {
    [self tt_stopPlaying];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(40.0f, 40.0f);
}

//重新设置动画时间
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

//重新设置column颜色
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

//重新柱状图宽度
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

- (CGPathRef)pathOfColumnWithHeight:(CGFloat)height {
    UIBezierPath *columnPath = [UIBezierPath bezierPath];
    columnPath.lineJoinStyle = kCGLineJoinRound;
    columnPath.lineCapStyle = kCGLineCapRound;
    columnPath.lineWidth = _columnWidth;
    [columnPath moveToPoint:CGPointMake(_columnWidth * 0.5f, height)];
    [columnPath addLineToPoint:CGPointMake(_columnWidth * 0.5f, 0)];
    
    return columnPath.CGPath;
}

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

