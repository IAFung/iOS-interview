//  Director.h
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Builder.h"
NS_ASSUME_NONNULL_BEGIN

@interface Director : NSObject
- (void)constructCarWithBuilder:(Builder *)builder;
- (Car *)getCar;
@end

NS_ASSUME_NONNULL_END
