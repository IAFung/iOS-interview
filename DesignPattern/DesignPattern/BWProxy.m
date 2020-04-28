//  BWProxy.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/18.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "BWProxy.h"

@implementation BWProxy
+ (instancetype)proxyWithTarget:(id)target{
    BWProxy *proxy = [BWProxy alloc];
    proxy.target = target;
    return proxy;
}
- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

@end
