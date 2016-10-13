//
//  KFCpuUsageLabel.m
//  kugou
//
//  Created by moLiang on 2016/8/11.
//  Copyright © 2016年 caijinchao. All rights reserved.
//

#import "KFCpuUsageLabel.h"
#import "KFWeakProxy.h"
#import "KFMemoryProfilerResidentMemoryInBytes.h"

@implementation KFCpuUsageLabel
{
    CADisplayLink *_link;
    UIFont *_font;
    UIFont *_subFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = CGSizeMake(65, 20);
    }
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor blackColor];
        
        _font = [UIFont fontWithName:@"Menlo" size:14];
        if (_font) {
            _subFont = [UIFont fontWithName:@"Menlo" size:4];
        } else {
            _font = [UIFont fontWithName:@"Courier" size:14];
            _subFont = [UIFont fontWithName:@"Courier" size:4];
        }
        _link = [CADisplayLink displayLinkWithTarget:[KFWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (void)tick:(CADisplayLink *)link {
    
    uint64_t memory = KFCpuUsage();
    CGFloat progress = 0;
    if (memory <= 0) {
        progress =  1;
        memory = 0;
    } else if (memory < 30) {
        progress =  1;
    } else {
        progress = (memory - 10) / 10;
    }
    
    UIColor *color = [UIColor colorWithHue:0.27 * progress saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d %%",(int)round(memory)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length - 1)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 1, 1)];
    [text addAttribute:NSFontAttributeName value:_font range:NSMakeRange(text.length - 2, 1)];
    
    self.attributedText = text;
}

@end
