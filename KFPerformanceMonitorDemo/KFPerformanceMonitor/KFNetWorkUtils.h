//
//  KFNetWorkUtils.h
//  kugou
//
//  Created by moLiang on 2016/9/21.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define B_TO_KB(a)      ((a) / 1024.0)
#define B_TO_MB(a)      (B_TO_KB(a) / 1024.0)
#define B_TO_GB(a)      (B_TO_MB(a) / 1024.0)
#define B_TO_TB(a)      (B_TO_GB(a) / 1024.0)
#define KB_TO_B(a)      ((a) * 1024.0)
#define MB_TO_B(a)      (KB_TO_B(a) * 1024.0)
#define GB_TO_B(a)      (MB_TO_B(a) * 1024.0)
#define TB_TO_B(a)      (GB_TO_B(a) * 1024.0)

@interface NetworkBandwidth : NSObject

@property (nonatomic, strong) NSDate    *timestamp;
@property (nonatomic, assign) float     sent;
@property (nonatomic, assign) uint64_t  totalWiFiSent;
@property (nonatomic, assign) uint64_t  totalWWANSent;
@property (nonatomic, assign) float     received;
@property (nonatomic, assign) uint64_t  totalWiFiReceived;
@property (nonatomic, assign) uint64_t  totalWWANReceived;

@end

@interface KFNetWorkUtils : NSObject

+ (NetworkBandwidth*)getNetworkBandwidth;

+ (NSString*)toNearestMetric:(uint64_t)value desiredFraction:(NSUInteger)fraction;

+ (BOOL)dateDidTimeout:(NSDate*)date seconds:(double)sec;

@end


