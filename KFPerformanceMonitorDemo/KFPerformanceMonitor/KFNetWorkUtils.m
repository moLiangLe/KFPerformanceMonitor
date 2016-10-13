//
//  KFNetWorkUtils.m
//  kugou
//
//  Created by moLiang on 2016/9/21.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import "KFNetWorkUtils.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>

@implementation KFNetWorkUtils

static NSString *kInterfaceWiFi = @"en0";
static NSString *kInterfaceWWAN = @"pdp_ip0";
static NSString *kInterfaceNone = @"";

+ (NetworkBandwidth*)getNetworkBandwidth
{
    NetworkBandwidth *bandwidth = [[NetworkBandwidth alloc] init];
    bandwidth.timestamp = [NSDate date];
    
    int mib[] = {
        CTL_NET,
        PF_ROUTE,
        0,
        0,
        NET_RT_IFLIST2,
        0
    };
    
    size_t len;
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        //sysctl failed (1);
        return bandwidth;
    }
    
    char *buf = malloc(len);
    if (!buf)
    {
        //malloc() for buf has failed.;
        return bandwidth;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        //sysctl failed (2);
        free(buf);
        return bandwidth;
    }
    char *lim = buf + len;
    char *next = NULL;
    for (next = buf; next < lim; )
    {
        struct if_msghdr *ifm = (struct if_msghdr *)next;
        next += ifm->ifm_msglen;
        
        /* iOS does't include <net/route.h>, so we define our own macros. */
#define RTM_IFINFO2 0x12
        if (ifm->ifm_type == RTM_IFINFO2)
#undef RTM_IFINFO2
        {
            struct if_msghdr2 *if2m = (struct if_msghdr2 *)ifm;
            
            char ifnameBuf[IF_NAMESIZE];
            if (!if_indextoname(ifm->ifm_index, ifnameBuf))
            {
                //if_indextoname() has failed.;
                continue;
            }
            NSString *ifname = [NSString stringWithCString:ifnameBuf encoding:NSASCIIStringEncoding];
            
            if ([ifname isEqualToString:kInterfaceWiFi])
            {
                bandwidth.totalWiFiSent += if2m->ifm_data.ifi_obytes;
                bandwidth.totalWiFiReceived += if2m->ifm_data.ifi_ibytes;
            }
            else if ([ifname isEqualToString:kInterfaceWWAN])
            {
                bandwidth.totalWWANSent += if2m->ifm_data.ifi_obytes;
                bandwidth.totalWWANReceived += if2m->ifm_data.ifi_ibytes;
            }
        }
    }
    
    free(buf);
    return bandwidth;
}

#pragma mark - static public

+ (NSString*)toNearestMetric:(uint64_t)value desiredFraction:(NSUInteger)fraction
{
    static const uint64_t  B  = 0;
    static const uint64_t KB  = 1024;
    static const uint64_t MB  = KB * 1024;
    static const uint64_t GB  = MB * 1024;
    static const uint64_t TB  = GB * 1024;
    
    uint64_t absValue = llabs((long long)value);
    double metricValue;
    NSString *specifier = [NSString stringWithFormat:@"%%0.%ldf", (long)fraction];
    NSString *format;
    
    if (absValue >= B && absValue < KB)
    {
        metricValue = value;
        format = [NSString stringWithFormat:@"%@ B", specifier];
    }
    else if (absValue >= KB && absValue < MB)
    {
        metricValue = B_TO_KB(value);
        format = [NSString stringWithFormat:@"%@ KB", specifier];
    }
    else if (absValue >= MB && absValue < GB)
    {
        metricValue = B_TO_MB(value);
        format = [NSString stringWithFormat:@"%@ MB", specifier];
    }
    else if (absValue >= GB && absValue < TB)
    {
        metricValue = B_TO_GB(value);
        format = [NSString stringWithFormat:@"%@ GB", specifier];
    }
    else
    {
        metricValue = B_TO_TB(value);
        format = [NSString stringWithFormat:@"%@ TB", specifier];
    }
    
    return [NSString stringWithFormat:format, metricValue];
}

+ (BOOL)dateDidTimeout:(NSDate*)date seconds:(double)sec
{
    if (date == nil)
        return YES;
    
    return [date timeIntervalSinceNow] < -sec;
}

@end

@implementation NetworkBandwidth

@end
