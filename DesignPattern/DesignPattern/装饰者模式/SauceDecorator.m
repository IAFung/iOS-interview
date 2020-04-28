//  SauceDecorator.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "SauceDecorator.h"

@implementation SauceDecorator
- (instancetype)initWithSalad:(Salad *)salad{
    
    self = [super init];
    
    if (self) {
        _salad = salad;
    }
    return self;
}

@end
