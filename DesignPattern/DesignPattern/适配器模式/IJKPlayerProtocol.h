//  IJKPlayerProtocol.h
//  DesignPattern
//
//  Created by 冯铁军 on 2020/4/24.
//  Copyright © 2020 冯铁军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IJKPlayerProtocol <NSObject>
- (void)ijk_start;
- (void)ijk_stop;
- (void)ijk_resume;
@end

NS_ASSUME_NONNULL_END
