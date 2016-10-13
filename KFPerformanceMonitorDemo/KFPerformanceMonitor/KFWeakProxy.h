//
//  KFWeakProxy.h
//
//  Created by moLiang on 2016/8/10.
//  Copyright © 2016年 caijinchao. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 A proxy used to hold a weak object.
 It can be used to avoid retain cycles, such as the target in NSTimer or CADisplayLink.
 
 sample code:
 
     @implementation MyView {
        NSTimer *_timer;
     }
     
     - (void)initTimer {
        KFWeakProxy *proxy = [KFWeakProxy proxyWithTarget:self];
        _timer = [NSTimer timerWithTimeInterval:0.1 target:proxy selector:@selector(tick:) userInfo:nil repeats:YES];
     }
     
     - (void)tick:(NSTimer *)timer {...}
     @end
 */
@interface KFWeakProxy : NSProxy

/**
 The proxy target.
 */
@property (nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end
