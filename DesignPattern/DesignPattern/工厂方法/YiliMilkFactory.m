//  YiliMilkFactory.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "YiliMilkFactory.h"
#import "YiliMilk.h"
@implementation YiliMilkFactory
+ (Milk *)createMilk{
    return [YiliMilk new];
}
@end
