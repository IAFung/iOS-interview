//  VinegarSauceDecorator.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "VinegarSauceDecorator.h"

@implementation VinegarSauceDecorator
- (NSString *)getDescription{
    return [NSString stringWithFormat:@"%@ + vinegar sauce",[self.salad getDescription]];
}

- (double)price{
    return [self.salad price] + 2.0;
}

@end
