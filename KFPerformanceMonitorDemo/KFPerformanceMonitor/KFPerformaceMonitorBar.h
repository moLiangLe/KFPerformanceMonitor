//
//  KFPerformaceMonitorBar.h
//  kugou
//
//  Created by moLiang on 2016/8/12.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFPerformaceMonitorBar : UIWindow

@property (nonatomic, readwrite) BOOL showsAverage;

+ (KFPerformaceMonitorBar *)sharedInstance;

@end
