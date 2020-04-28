//  Builder.h
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"
NS_ASSUME_NONNULL_BEGIN

@interface Builder : NSObject {
    @protected Car *_car;
}
- (void)createCar;
- (void)buildTire;
- (void)buildGlass;
- (void)buildEngine;
- (Car *)getCar;
@end

NS_ASSUME_NONNULL_END
