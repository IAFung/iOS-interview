//  SimpleFactory.h
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Milk.h"
NS_ASSUME_NONNULL_BEGIN

@interface SimpleFactory : NSObject
+ (Milk *)milkWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
