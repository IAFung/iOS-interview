//  BWProxy.h
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/18.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BWProxy : NSProxy
@property (nonatomic, weak) id target;
+ (instancetype)proxyWithTarget:(id)target;
@end
