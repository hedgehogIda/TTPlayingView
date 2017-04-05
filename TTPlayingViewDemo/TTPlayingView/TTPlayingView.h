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

@property (nonatomic, assign) NSTimeInterval playingTimeInterval;
@property (nonatomic, assign) float columnWidth;
@property (nonatomic, strong) UIColor *columnColor;

- (instancetype)initWithFrame:(CGRect)frame
                     colWidth:(float)columnWidth
              playingInterval:(NSTimeInterval)timeInterval
                     colColor:(UIColor *)color;

- (void)startPlaying;
- (void)stopPlaying;

@end

NS_ASSUME_NONNULL_END
