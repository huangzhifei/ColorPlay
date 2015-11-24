//
//  CPStopWatchView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPStopWatchView.h"
#import "CPOutlineLabel.h"
#import "GCDTimer.h"

@interface CPStopWatchView()

@property (strong, nonatomic) CPOutlineLabel *outlineLabel;

@property (strong) TimeOutBlock timeOut;

@end

@implementation CPStopWatchView

#pragma mark - initlize

- (instancetype)init
{
    self = [super init];
    
    if( self )
    {
        [self initlize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self initlize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self initlize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame stopWatch:(NSInteger)stopWatch
{
    self = [self initWithFrame:frame];
    
    if(self)
    {
        self.stopWatch = stopWatch;
    }
    
    return self;
}

- (void)initlize
{
    _stopWatch = 0;
    
    _textColor = [UIColor blackColor];
    
    _outlineColor = [UIColor whiteColor];
    
    _outlineWidth = 2.0f;
    
    _font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:50];
    
    _outlineLabel = ({
        CPOutlineLabel *label = [[CPOutlineLabel alloc] initWithFrame:self.bounds];
        label.textColor = _textColor;
        label.outlineColor = _outlineColor;
        label.outlineWith = _outlineWidth;
        label.font = _font;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self addSubview:_outlineLabel];
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _outlineLabel.frame = self.bounds;
}

- (void) setFont:(UIFont *)font
{
    _font = font;
    
    _outlineLabel.font = font;
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    _outlineLabel.textColor = textColor;
}

- (void) setOutlineColor:(UIColor *)outlineColor
{
    _outlineColor = outlineColor;
    
    _outlineLabel.outlineColor = outlineColor;
}

- (void) setOutlineWidth:(CGFloat)outlineWidth
{
    _outlineWidth = outlineWidth;
    
    _outlineLabel.outlineWith = outlineWidth;
}

- (void)setStopWatch:(NSInteger)stopWatch
{
    _stopWatch = stopWatch;
    
    [_outlineLabel setText:[NSString stringWithFormat:@"%ld",(long)self.stopWatch]];
}

#pragma mark - public Method

- (void)fireStopWatch:(NSTimeInterval)delay timeOut:(TimeOutBlock)timeOut
{
    self.timeOut = timeOut;
    
    [GCDTimer scheduledTimerWithTimeInterval:delay repeats:NO block:^{
        
        [self fire];
        
    }];
}

#pragma mark - private method

- (void)fire
{
    if( self.stopWatch < 1 )
    {
        if( self.timeOut )
        {
            self.timeOut();
        }
        return;
    }
    
    _outlineLabel.alpha = 1;
    
    [_outlineLabel setText:[NSString stringWithFormat:@"%ld",(long)self.stopWatch]];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _outlineLabel.alpha = 0;
        
        _outlineLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
    } completion:^(BOOL finished) {
        
        self.stopWatch -= 1;
        
        _outlineLabel.transform = CGAffineTransformMakeScale(1.25, 1.25);
        
        [self fire];
    }];

}

@end
