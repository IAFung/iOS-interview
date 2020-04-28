//  BMWCarBuilder.m
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import "BMWCarBuilder.h"

@implementation BMWCarBuilder
- (void)createCar {
    _car = Car.new;
}
- (void)buildTire {
    [_car setTire:@"tire1"];
}
- (void)buildGlass {
    [_car setGlass:@"car1"];
}
- (void)buildEngine {
    [_car setEngine:@"engine1"];
}
- (Car *)getCar {
    return _car;
}
@end
