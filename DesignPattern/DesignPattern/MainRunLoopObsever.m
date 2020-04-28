//  MainRunLoopObsever.m
//  DesignPattern
//
//  Created by 冯铁军 on 2019/6/3.
//  Copyright © 2019年 冯铁军. All rights reserved.
//

#import "MainRunLoopObsever.h"

@implementation MainRunLoopObsever
+ (void)load{
//    CFRunLoopObserverRef obseverRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        NSString *str = nil;
//        switch (activity) {
//            case kCFRunLoopEntry:
//                str = @"kCFRunLoopEntry";
//                break;
//            case kCFRunLoopBeforeTimers:
//                str = @"kCFRunLoopBeforeTimers";
//                break;
//            case kCFRunLoopBeforeSources:
//                str = @"kCFRunLoopBeforeSources";
//                break;
//            case kCFRunLoopBeforeWaiting:
//                str = @"kCFRunLoopBeforeWaiting";
//                break;
//            case kCFRunLoopExit:
//                str = @"kCFRunLoopExit";
//                break;
//            case kCFRunLoopAllActivities:
//                str = @"kCFRunLoopAllActivities";
//                break;
//            case kCFRunLoopAfterWaiting:
//                str = @"kCFRunLoopAfterWaiting";
//                break;
//                
//            default:
//                break;
//        }
//        if (str == nil) {
//            NSLog(@"%ld",activity);
//        }else{
//            NSLog(@"%@",str);
//        }
//    });
//    
//    CFRunLoopAddObserver(CFRunLoopGetMain(), obseverRef, kCFRunLoopCommonModes);
}

@end
