//  SimpleFactory.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "SimpleFactory.h"
#import "YiliMilk.h"
#import "GuangmingMilk.h"
@implementation SimpleFactory
+ (Milk *)milkWithType:(NSInteger)type{
    switch (type) {
        case 0:
            return [GuangmingMilk createMilk];
        case 1:
            return [YiliMilk createMilk];
    }
    return nil;
}
@end
