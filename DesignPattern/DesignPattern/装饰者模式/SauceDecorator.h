//  SauceDecorator.h
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Salad.h"
NS_ASSUME_NONNULL_BEGIN
//装饰者基类需要继承于抽象构件
@interface SauceDecorator : Salad
@property (strong, nonatomic) Salad *salad;
- (instancetype)initWithSalad:(Salad *)salad;
@end

NS_ASSUME_NONNULL_END
