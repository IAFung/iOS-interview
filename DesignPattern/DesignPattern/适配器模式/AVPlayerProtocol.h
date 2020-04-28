//  AVPlayerProtocol.h
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AVPlayerProtocol <NSObject>
- (void)av_start;
- (void)av_stop;
- (void)av_resume;
@end

NS_ASSUME_NONNULL_END
