//
//  KFPerformaceMonitorBar.m
//  kugou
//
//  Created by moLiang on 2016/8/12.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import "KFPerformaceMonitorBar.h"
#import "KFFPSLabel.h"
#import "KFMemoryLabel.h"
#import "KFCpuUsageLabel.h"
//#import "KFTemperatureLabel.h"
#import "KFNetWorkLabel.h"

#define PerformaceMonitorLeft           20
#define PerformaceMonitorHeight         22
#define PerformaceMonitorPadding        1
#define PerformaceMonitorWidth          24.5
#define PerformaceMonitorMaxWidth       57
#define PreformaceMonitorDefaultSize    CGSizeMake(10, 10)
#define PreformaceMonitorWidth          [[UIScreen mainScreen] bounds].size.width

@interface KFPerformaceMonitorBar()

@property (nonatomic, assign) BOOL  isExpand;

@property (nonatomic, strong) KFCpuUsageLabel *cpu;

@property (nonatomic, strong) KFFPSLabel *fbs;

@property (nonatomic, strong) KFMemoryLabel *memory;

//@property (nonatomic, strong) KFTemperatureLabel *temper;

@property (nonatomic, strong) KFNetWorkLabel *network;

@property (nonatomic, assign) CGFloat maxWidth;

@property (nonatomic, strong) UIView *firstBGView;

@property (nonatomic, strong) UIView *secondBGView;

@property (nonatomic, assign) CGFloat secondBGViewPadding;

@end

@implementation KFPerformaceMonitorBar

- (id)init {
    
    self = [super initWithFrame:CGRectMake(PreformaceMonitorWidth - PerformaceMonitorMaxWidth, 0, PerformaceMonitorMaxWidth, PerformaceMonitorHeight)];
    if(self){
        self.isExpand = NO;
        _maxWidth = PerformaceMonitorMaxWidth + 65 + 78 + 15;
        _secondBGViewPadding = 0;
        
        _firstBGView = [[UIView alloc]initWithFrame:self.bounds];
        _firstBGView.backgroundColor = [UIColor blackColor];
        [self addSubview:_firstBGView];
        
        
        _secondBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _maxWidth,PerformaceMonitorHeight)];
        _secondBGView.backgroundColor = [UIColor blackColor];
        _secondBGView.hidden = YES;
        [self addSubview:_secondBGView];
        
        [self congfigViewLayerWithView:_firstBGView];
        [self congfigViewLayerWithView:_secondBGView];
        
        [self setWindowLevel: UIWindowLevelStatusBar +1.0f];
        
        _cpu = [[KFCpuUsageLabel alloc]initWithFrame:CGRectMake(2, PerformaceMonitorPadding, PerformaceMonitorMaxWidth, PerformaceMonitorLeft)];
        [self addSubview:_cpu];
        
        CGFloat cpuRight = _cpu.frame.origin.x + _cpu.frame.size.width;
        _fbs = [[KFFPSLabel alloc]initWithFrame:CGRectMake(cpuRight + 5, PerformaceMonitorPadding, 65, PerformaceMonitorLeft)];
        _fbs.hidden = YES;
        [self addSubview:_fbs];
        
        CGFloat _fbsRight = _fbs.frame.origin.x + _fbs.frame.size.width;
        _memory = [[KFMemoryLabel alloc]initWithFrame:CGRectMake(_fbsRight + 5, PerformaceMonitorPadding, 78, PerformaceMonitorLeft)];
        _memory.hidden = YES;
        [self addSubview:_memory];
        
//        if (!([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)) {
//            _temper = [[KFTemperatureLabel alloc]initWithFrame:CGRectMake(_memory.right + 5, PerformaceMonitorPadding, 75, PerformaceMonitorLeft)];
//            _temper.hidden = YES;
//            [self addSubview:_temper];
//            _maxWidth += 80;
//            _network.width = _maxWidth;
//            _secondBGViewPadding = 80;
//            _network.origin = CGPointMake(_secondBGViewPadding , _network.origin.y);
//        }
        
        _network = [[KFNetWorkLabel alloc]initWithFrame:CGRectMake(_secondBGViewPadding, PerformaceMonitorPadding + PerformaceMonitorHeight, _maxWidth - _secondBGViewPadding , PerformaceMonitorLeft)];
        _network.hidden = YES;
        [self addSubview:_network];
        
        if (_maxWidth > PreformaceMonitorWidth) {
            _maxWidth = PreformaceMonitorWidth;
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionEvent:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

+ (KFPerformaceMonitorBar *)sharedInstance
{
    static KFPerformaceMonitorBar *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KFPerformaceMonitorBar alloc] init];
        if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
            _sharedInstance.rootViewController = [UIViewController new]; // iOS 9 requires rootViewController for any window
    });
    return _sharedInstance;
}

- (void)actionEvent:(UITapGestureRecognizer *)sender
{
    [self expandOrCloseDetailInfo];
}

// 展开用户排名
- (void)expandOrCloseDetailInfo
{
    if (self.isExpand) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(PreformaceMonitorWidth - PerformaceMonitorMaxWidth, 0, PerformaceMonitorMaxWidth , PerformaceMonitorHeight);
            self.firstBGView.frame = self.bounds;
            CGRect newFrame = self.secondBGView.frame;
            newFrame.origin = CGPointMake(_secondBGViewPadding, 0);
            self.secondBGView.frame = newFrame;
            self.fbs.hidden = YES;
            self.memory.hidden = YES;
            //self.temper.hidden = YES;
            self.network.hidden = YES;
            self.secondBGView.hidden = YES;
        } completion:^(BOOL finished) {
            self.isExpand = NO;
            [self congfigViewLayerWithView:self.firstBGView];
        }];
    } else {
        [UIView animateWithDuration:0.75 animations:^{
            self.frame = CGRectMake(PreformaceMonitorWidth - self.maxWidth, 0, self.maxWidth , PerformaceMonitorHeight * 2);
            self.firstBGView.frame = CGRectMake(0, 0, self.maxWidth , PerformaceMonitorHeight);
            self.secondBGView.hidden = NO;
            CGRect newFrame = self.secondBGView.frame;
            newFrame.origin = CGPointMake(_secondBGViewPadding, PerformaceMonitorHeight);
            self.secondBGView.frame = newFrame;
            [self congfigViewLayerWithView:self.firstBGView];
        } completion:^(BOOL finished) {
            self.isExpand = YES;
            self.fbs.hidden = NO;
            self.memory.hidden = NO;
            //self.temper.hidden = NO;
            self.network.hidden = NO;
            
        }];
    }
}

- (void)congfigViewLayerWithView:(UIView *)view;
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
                                                         cornerRadii:PreformaceMonitorDefaultSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

@end
