//
//  KFNetWorkLabel.m
//  kugou
//
//  Created by moLiang on 2016/9/20.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import "KFNetWorkLabel.h"
#import "KFWeakProxy.h"
#import "KFNetWorkUtils.h"

#define KFPerformanceSize           CGSizeMake(65, 20)
#define kNetworkUpdateFrequency     1
@interface KFNetWorkLabel()

@property (nonatomic, strong) NSTimer   *networkBandwidthUpdateTimer;

@property (nonatomic, strong) UIFont    *textfont;

@property (nonatomic, assign) uint64_t  preTotalWiFiSent;

@property (nonatomic, assign) uint64_t  preTotalWiFiReceived;

@property (nonatomic, assign) uint64_t  preTotalWWANSent;

@property (nonatomic, assign) uint64_t  preTotalWWANReceived;

@property (nonatomic, strong) KFNetWorkUtils *networkUtil;

@end

@implementation KFNetWorkLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = KFPerformanceSize;
    }
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor blackColor];
        
        _textfont = [UIFont fontWithName:@"Menlo" size:14];
        
        _preTotalWWANReceived = 0;
        _preTotalWWANSent = 0;
        _preTotalWiFiSent = 0;
        _preTotalWiFiReceived = 0;
        
        [self configTextString:@"⬆︎ 0 B/s ⬇︎ 0 B/s"];
        [self startNetworkBandwidthUpdates];
    }
    return self;
}

- (void)startNetworkBandwidthUpdates
{
    [self stopNetworkBandwidthUpdates];
    self.networkBandwidthUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                        target:self
                                                                      selector:@selector(networkBandwidthUpdate)
                                                                      userInfo:nil
                                                                       repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.networkBandwidthUpdateTimer forMode:NSRunLoopCommonModes];
    [self.networkBandwidthUpdateTimer fire];
}

- (void)stopNetworkBandwidthUpdates
{
    [self.networkBandwidthUpdateTimer invalidate];
    self.networkBandwidthUpdateTimer = nil;
}

- (void)dealloc {
    [self stopNetworkBandwidthUpdates];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return KFPerformanceSize;
}

- (void)networkBandwidthUpdate {
    NetworkBandwidth *bandwidth = [KFNetWorkUtils getNetworkBandwidth];
    uint64_t wifiSend = bandwidth.totalWiFiSent - _preTotalWiFiSent;
    uint64_t wifiReceived = bandwidth.totalWiFiReceived - _preTotalWiFiReceived;
    uint64_t wwanSend = bandwidth.totalWWANSent - _preTotalWWANSent;
    uint64_t wwanReceived = bandwidth.totalWWANReceived - _preTotalWWANReceived;
    
    uint64_t send  = wifiSend > 0 ? wifiSend : wwanSend > 0 ? wwanSend : 0;
    uint64_t received  = wifiReceived > 0 ? wifiReceived : wwanReceived > 0 ? wwanReceived : 0;
    
    NSString *menoryString = [NSString stringWithFormat:@"⬆︎ %@/s ⬇︎ %@/s ", [KFNetWorkUtils toNearestMetric:send desiredFraction:1], [KFNetWorkUtils toNearestMetric:received desiredFraction:1]];
    _preTotalWiFiSent = bandwidth.totalWiFiSent;
    _preTotalWiFiReceived = bandwidth.totalWiFiReceived;
    _preTotalWWANSent = bandwidth.totalWWANSent;
    _preTotalWWANReceived = bandwidth.totalWWANReceived;
    [self configTextString:menoryString];
}

- (void)configTextString:(NSString *)menoryString
{
    UIColor *color = [UIColor colorWithHue:0.27 saturation:1 brightness:0.9 alpha:1];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:menoryString];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, menoryString.length - 1)];
    
    NSRange upRange = [menoryString rangeOfString:@"⬆︎ "];
    NSRange downRange = [menoryString rangeOfString:@"⬇︎ "];
    NSInteger upIndex = upRange.location + upRange.length;
    NSInteger downIndex = downRange.location + downRange.length;
    
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(upIndex , downRange.location - upIndex)];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(downIndex , menoryString.length - 1 - downIndex)];
    [text addAttribute:NSFontAttributeName value:_textfont range:NSMakeRange(text.length - 3, 1)];
    self.attributedText = text;
}

@end
