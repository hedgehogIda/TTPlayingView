//
//  ViewController.m
//  TTPlayingViewDemo
//
//  Created by jiang on 2017/4/5.
//  Copyright © 2017年 jiang. All rights reserved.
//

#import "ViewController.h"
#import "TTPlayingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TTPlayingView *playingView = [[TTPlayingView alloc] initWithFrame:CGRectZero];
    playingView.backgroundColor = [UIColor redColor];
    playingView.frame = CGRectMake(100, 300, 40, 40);
    [self.view addSubview:playingView];
    [playingView tt_startPlaying];
    
//    playingView.playingTimeInterval = 3;
//    playingView.columnWidth = 7;
//    playingView.columnColor = [UIColor blueColor];
    [playingView addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tap {
    NSLog(@"tap");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
