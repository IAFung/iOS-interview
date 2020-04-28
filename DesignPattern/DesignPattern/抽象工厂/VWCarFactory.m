//  VWCarFactory.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "VWCarFactory.h"

@implementation VWCarFactory
+ (VWTyre *)createTyre{
    return VWTyre.new;
}
+ (VWGlass *)createGlass{
    return VWGlass.new;
}
+ (VWEngine *)createEngine{
    return VWEngine.new;
}
@end
