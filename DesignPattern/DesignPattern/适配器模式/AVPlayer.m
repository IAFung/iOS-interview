//  AVPlayer.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "AVPlayer.h"

@interface AVPlayer () 

@end

@implementation AVPlayer
- (void)av_start{
    NSLog(@"%s",__func__);
}

- (void)av_resume {
    NSLog(@"%s",__func__);
}


- (void)av_stop {
    NSLog(@"%s",__func__);
}

@end
