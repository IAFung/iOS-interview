//  CarFactory.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "CarFactory.h"

@implementation CarFactory
+ (Tyre *)createTyre;{
    return Tyre.new;
}
+ (Glass *)createGlass;{
    return Glass.new;
}
+ (Engine *)createEngine;{
    return Engine.new;
}
@end
