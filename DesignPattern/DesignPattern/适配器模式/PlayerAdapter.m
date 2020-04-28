//  PlayerAdapter.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "PlayerAdapter.h"
@implementation PlayerAdapter {
    IJKPlayer *_player;
}

- (instancetype)initWithPlayer:(IJKPlayer *)player {
    if (self = [super init]) {
        _player = player;
    }
    return self;
}

- (void)av_resume {
    [_player ijk_resume];
}

- (void)av_start {
    [_player ijk_start];
}

- (void)av_stop {
    [_player ijk_stop];
}

@end
