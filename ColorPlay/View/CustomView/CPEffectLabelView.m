//
//  SPEffectLabel.m
//  StroopPlay
//
//  Created by huangzhifei on 15/11/7.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPEffectLabelView.h"
#import <QuartzCore/QuartzCore.h>
#import "GCDTimer.h"

#define kAnimationNum 8

@interface UIImage (LEffectLabelAdditions)

+ (UIImage *)imageWithView:(UIView *)view;

@end


@implementation CPEffectLabelView
{
    UILabel *_effectLabel;
    
    CALayer *_textLayer;
    
    CGImageRef _alphaImage;
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self initialize];
    }
    
    return self;

}

- (void)initialize
{
    _textColor = [UIColor whiteColor];
    _effectColor = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor];
    _textAlignment = NSTextAlignmentCenter;
    _effectDirection = EffectLabelDirectionLeftToRight;
    
    _effectLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _effectLabel.textAlignment = _textAlignment;
    _effectLabel.numberOfLines = 1;
    _effectLabel.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor = [[UIColor clearColor] CGColor];
    gradientLayer.colors = _effectColor;
}

/**
 *  如果不重载，默认返回是CALayer，也就是UIView中的layer属性，当我们想使用layer的子类时，就可以重载此方法来返回我们要使
 *  用的类。
 *
 *  @return 返回我们使用的layer子类
 */
+ (Class)layerClass
{
    return [CAGradientLayer class];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    _textLayer.frame = self.bounds;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat superWidth = frame.size.width;
    CGFloat superHeight = frame.size.height;
    CGFloat labelWidth = _effectLabel.frame.size.width;
    CGFloat labelHeight = _effectLabel.frame.size.height;
    
    CGFloat labelX = (superWidth - labelWidth)*0.5;
    CGFloat labelY = (superHeight - labelHeight)*0.5;
    
    _effectLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _effectLabel.font = _font;
    
    [self updateLabel];
}

- (void)setText:(NSString *)text
{
    _text = text;
    _effectLabel.text = _text;
    
    [self updateLabel];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _effectLabel.textColor = _textColor;
    
    [self updateLabel];
}

- (void)setEffectColor:(NSArray *)effectColor
{
    _effectColor = effectColor;
    
    [self updateLabel];
}

#pragma mark - public method

- (void)performEffectAnimation:(CFTimeInterval)seconds repeats:(BOOL)repeats
{
    [self moveEffectView];
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    
    switch (self.effectDirection)
    {
        case EffectLabelDirectionLeftToRight:
            gradientLayer.startPoint = CGPointMake(0.0, 0.5);
            gradientLayer.endPoint = CGPointMake(1.0, 0.5);
            break;
            
        case EffectLabelDirectionRightToLeft:
            gradientLayer.startPoint = CGPointMake(1.0, 0.5);
            gradientLayer.endPoint = CGPointMake(0.0, 0.5);
            break;
            
        case EffectLabelDirectionTopLetfToBottomRight:
            gradientLayer.startPoint = CGPointMake(1.0, 1.0);
            gradientLayer.endPoint = CGPointMake(0.0, 0.0);
            break;
            
        case EffectLabelDirectionBottomRightToTopLeft:
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            gradientLayer.endPoint = CGPointMake(1.0, 1.0);
            break;
        
        default:
            break;
    }
    
    NSMutableArray *animationArray = [[NSMutableArray alloc]init];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CGFloat duration = seconds / (kAnimationNum+1);
    for(int i = 0; i < kAnimationNum+1; ++ i)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
        animation.fromValue = [self colorsForStage:i effectColorIndex:i%(_effectColor.count)];
        animation.toValue = [self colorsForStage:i+1 effectColorIndex:(i+1)%(_effectColor.count)];
        animation.beginTime = (duration-0.1) * i;
        animation.duration = duration;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [animationArray addObject:animation];
    }
    group.removedOnCompletion = NO;
    if( repeats )
    {
        group.repeatCount = HUGE_VALF;
    }
    else
    {
        group.repeatCount = 1;
    }
    group.fillMode = kCAFillModeForwards;
    /**
        组动画的时长  >  组中所有动画的最长时间的时候, 动画的时间以组中最长的时间为准
        组动画的时间  <  组中所有动画的最长时间, 动画的时间以group的时长为准
        最完美: group的时长 = 组中所有动画的最长时间
     */
    group.duration = [(CABasicAnimation*)animationArray[8] beginTime] + [(CABasicAnimation*)animationArray[8] duration];
    [group setAnimations:animationArray];
    
    [gradientLayer addAnimation:group forKey:@"animationOpacity"];
    
    self.alpha = 0;
    
    [GCDTimer scheduledTimerWithTimeInterval:0.05 repeats:NO block:^{
        
        [self showAnimation];
        
    }];
    
}

#pragma mark - private method

- (void)updateLabel
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = [self colorsForStage:0 effectColorIndex:0];
    
    [_effectLabel sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _effectLabel.frame.size.width,
                            _effectLabel.frame.size.height);
    
    //[gradientLayer.mask setMask:_effectLabel.layer];
    
    //如果不用下面的写法，连文字都不显示
    _alphaImage = [[UIImage imageWithView:_effectLabel] CGImage];
    
    _textLayer = [CALayer layer];
    _textLayer.contents = (__bridge id)_alphaImage;
    
    [self.layer setMask:_textLayer];
    
    [self setNeedsLayout];
}

/**
 *  让其动起来
 *
 *  @param 阶段数
 *
 *  @return 阶段颜色数组
 */
- (NSArray *)colorsForStage:(NSUInteger)stage effectColorIndex:(NSUInteger)index
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:kAnimationNum];
    
    for (int i = 0; i < kAnimationNum+1; ++i)
    {
        [array addObject:stage != 0 && stage == i ? (id)_effectColor[index] : (id)[_textColor CGColor]];
    }
    
    return [NSArray arrayWithArray:array];
}

#pragma mark - view animation methods

- (void)moveEffectView
{
    CATransform3D move = CATransform3DIdentity;
    CGFloat initAlertViewYPosition = self.frame.size.height*4;
    
    move = CATransform3DMakeTranslation(0, -initAlertViewYPosition, 0);
    move = CATransform3DRotate(move, 40 * M_PI/180, 0, 0, 1.0f);
    
    self.layer.transform = move;
}

- (void)showAnimation
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        
                         self.alpha = 1.0f;

                     } completion:^(BOOL finished) {
        
                     }];
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         self.layer.transform = init;
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

@end

@implementation UIImage (LEffectLabelAdditions)

+ (UIImage *)imageWithView:(UIView *)view
{
    /**
     *  http://stackoverflow.com/questions/19377299/cgcontextsavegstate-invalid-context
     */
    if( view.bounds.size.width == 0 )
    {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
