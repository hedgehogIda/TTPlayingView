//
//  PlayingView.h
//  testdemo
//
//  Created by jiang on 2017/4/5.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPlayingView : UIView

/**
 *  动画间隔
 **/
@property (nonatomic, assign) NSTimeInterval playingTimeInterval;

/**
 *  柱状图宽度
 **/
@property (nonatomic, assign) float columnWidth;

/**
 *  柱状图颜色
 **/
@property (nonatomic, strong) UIColor *columnColor;

- (instancetype)initWithFrame:(CGRect)frame
                     colWidth:(float)columnWidth
              playingInterval:(NSTimeInterval)timeInterval
                     colColor:(UIColor *)color;

/**
 *  开始动画
 **/
- (void)tt_startPlaying;
- (void)tt_stopPlaying;

@end

NS_ASSUME_NONNULL_END
