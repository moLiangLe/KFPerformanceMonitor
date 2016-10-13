////
////  KFWaveLoadingIndicator.m
////  kugou
////
////  Created by moLiang on 2016/9/14.
////  Copyright © 2016年 caijinchao. All rights reserved.
////
//
//#import "KFWaveLoadingIndicator.h"
//
//@interface KFWaveLoadingIndicator()
//
//@property (nonatomic, assign) KFWaveLoadingIndicatorShapeModel shapeModel;
//
//@property (nonatomic, assign) BOOL isShowProgressText;
//
//@property (nonatomic, assign) CGFloat originX;
//
//@property (nonatomic, assign) CGFloat position;
//@property (nonatomic, assign) CGFloat cycle;
//@property (nonatomic, assign) CGFloat term;
//@property (nonatomic, assign) CGFloat phase;
//@property (nonatomic, assign) CGFloat waveMoveSpan;
//@property (nonatomic, assign) CGFloat animationUnitTime;
//@property (nonatomic, assign) CGFloat amplitude;
//@property (nonatomic, assign) CGFloat progressTextFontSize;
//@property (nonatomic, assign) BOOL waving;
//@property (nonatomic, assign) CGFloat phasePosition;
//@property (nonatomic, assign) CGFloat clipCircleLineWidth;
//
//@property (nonatomic, strong) UIColor *heavyColor;
//@property (nonatomic, strong) UIColor *lightColor;
//@property (nonatomic, strong) UIColor *clipCircleColor;
//
//
//@end
//
//
//@implementation KFWaveLoadingIndicator
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _originX = 0.0 ;                    //X坐标起点, the x origin of wave
//        _amplitudeMin = 16.0;               //波幅最小值
//        _amplitudeSpan = 26.0;              //波幅可调节幅度
//        
//        _cycle = 1.0;                       //循环次数, num of circulation
//        _term = 60.0;                       //周期（在代码中重新计算）, recalculate in layoutSubviews
//        _phase = 0.0;                       //相位必须为0(画曲线机制局限), phase Must be 0
//        _amplitude = 29.0;                  //波幅
//        _position = 40.0;                   //X轴所在的Y坐标（在代码中重新计算）, where the x axis of wave position
//        _phasePosition = 0.0;               //相位必须为0(画曲线机制局限), phase Must be 0
//        
//        _waveMoveSpan = 5.0;                //波浪移动单位跨度, the span wave move in a unit time
//        _animationUnitTime = 0.08;          //重画单位时间, redraw unit time
//        
//        _heavyColor = [UIColor colorWithRed:38/255.0 green:227/255.0 blue:198/255.0 alpha:1];
//        _lightColor = [UIColor colorWithRed:121/255.0 green:248/255.0 blue:221/255.0 alpha:1];
//        _clipCircleColor = [UIColor colorWithRed:38/255.0 green:227/255.0 blue:198/255.0 alpha:1];
//        
//        _borderWidth = 1;
//        
//        _clipCircleLineWidth = 1;
//        
//        _progressTextFontSize = 15.0;
//        
//        _isShowProgressText = YES;
//        
//        _shapeModel = KFWaveLoadingIndicatorShapeModelCircle;
//        
//        _waving = YES;
//        
//        [self animationWave];
//    }
//    return self;
//}
//
//- (void)setProgress:(CGFloat)progress
//{
//    _progress = progress;
//    [self setNeedsDisplay];
//}
//
//- (void)setWaveAmplitude:(CGFloat)waveAmplitude
//{
//    _waveAmplitude = waveAmplitude;
//    [self setNeedsDisplay];
//}
//
//- (void)setBorderWidth:(CGFloat)borderWidth
//{
//    _borderWidth = borderWidth;
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    _position =  (1 - _progress) * rect.size.height;
//    
//    //circle clip
//    [self clipWithCircle];
//    
//    //draw wave
//    [self drawWaveWaterWithOriginX:_originX - _term / 5 fillColor:_lightColor];
//    [self drawWaveWaterWithOriginX:_originX fillColor:_heavyColor];
//    
//    //Let clipCircle above the waves
//    [self clipWithCircle];
//    
//    //draw the tip text of progress
//    if (_isShowProgressText) {
//        [self drawProgressText];
//    }
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    //计算周期calculate the term
//    _term = self.bounds.size.width / _cycle;
//}
//
//- (void)removeFromSuperview
//{
//    [super removeFromSuperview];
//    _waving = NO;
//}
//
//- (void)clipWithCircle
//{
//    CGFloat circleRectWidth = MIN(self.bounds.size.width, self.bounds.size.height) - 2 * _clipCircleLineWidth;
//    CGFloat circleRectOriginX = (self.bounds.size.width - circleRectWidth) / 2;
//    CGFloat circleRectOriginY = (self.bounds.size.height - circleRectWidth) / 2;
//    CGRect circleRect = CGRectMake(circleRectOriginX, circleRectOriginY, circleRectWidth, circleRectWidth);
//    
//    UIBezierPath *clipPath = nil;
//    if (_shapeModel == KFWaveLoadingIndicatorShapeModelCircle) {
//        clipPath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
//    } else {
//        clipPath = [UIBezierPath bezierPathWithRect:circleRect];
//    }
//    
//    [_clipCircleColor setStroke];
//    clipPath.lineWidth = _clipCircleLineWidth;
//    [clipPath stroke];
//    [clipPath addClip];
//}
//
//- (void)drawWaveWaterWithOriginX:(CGFloat)originX fillColor:(UIColor *)fillColor
//{
//    UIBezierPath *curvePath = [[UIBezierPath alloc]init];
//    [curvePath moveToPoint:CGPointMake(originX, _position)];
//    
//    //循环，画波浪wave path
//    CGFloat tempPoint = originX;
//    for (int i = 1; i < roundf(4 * _cycle); i++) {
//        //(2 * cycle)即可充满屏幕，即一个循环,为了移动画布使波浪移动，我们要画两个循环
//        [curvePath addQuadCurveToPoint:[self keyPointWithX:tempPoint + _term / 2 originX:originX] controlPoint:[self keyPointWithX:tempPoint + _term / 4 originX:originX]];
//        tempPoint += _term / 2;
//    }
//
//    //close the water path
//    [curvePath addLineToPoint:CGPointMake(curvePath.currentPoint.x, self.bounds.size.height)];
//    [curvePath addLineToPoint:CGPointMake(originX, self.bounds.size.height)];
//    [curvePath closePath];
//    
//    [fillColor setFill];
//    curvePath.lineWidth = 10;
//    [curvePath fill];
//}
//
//- (void)drawProgressText
//{
//    //Avoid negative
////    CGFloat validProgress = _progress * 100;
////    validProgress = validProgress < 1 ? 0 : validProgress;
////    
////    NSString *progressText = (NSString(format: "%.0f", validProgress) as String) + "%"
////    
////    var attribute: [String : AnyObject]!
////    if progress > 0.45 {
////        attribute = [NSFontAttributeName : UIFont.systemFontOfSize(progressTextFontSize), NSForegroundColorAttributeName : UIColor.whiteColor()]
////    } else {
////        attribute = [NSFontAttributeName : UIFont.systemFontOfSize(progressTextFontSize), NSForegroundColorAttributeName : heavyColor]
////    }
////    
////    let textSize = progressText.sizeWithAttributes(attribute)
////    let textRect = CGRectMake(self.bounds.width/2 - textSize.width/2, self.bounds.height/2 - textSize.height/2, textSize.width, textSize.height)
////    
////    progressText.drawInRect(textRect, withAttributes: attribute)
//}
//
//- (void)animationWave
//{
//    @neeWeakSelfOnly(self)
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if(weakSelf){
//            CGFloat tempOriginX = weakSelf.originX;
//            while (weakSelf && !weakSelf.waving){
//                
//                if(weakSelf.originX <= tempOriginX - weakSelf.term){
//                    weakSelf.originX = tempOriginX - weakSelf.waveMoveSpan;
//                } else {
//                    weakSelf.originX -= self.waveMoveSpan;
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf setNeedsDisplay];
//                });
//                
//                [NSThread sleepForTimeInterval:_animationUnitTime];
//            }
//        }
//    });
//}
//
//- (CGPoint)keyPointWithX:(CGFloat)x originX:(CGFloat)originX
//{
//    return CGPointMake(x, [self columnYPoint:x - originX]);
//}
//
//- (CGFloat)columnYPoint:(CGFloat)x
//{
//    //三角正弦函数
//    CGFloat result = _amplitude * sin((2 * M_PI / _term) * x + _phasePosition);
//    return result + _position;
//}
//
//@end
