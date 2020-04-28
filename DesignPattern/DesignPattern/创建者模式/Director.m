//  Director.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "Director.h"

@implementation Director{
    Builder *_builder;
}
- (void)constructCarWithBuilder:(Builder *)builder{
    _builder = builder;
    [builder buildTire];
    [builder buildGlass];
    [builder buildEngine];
}
- (Car *)getCar{
    return [_builder getCar];
}
@end
