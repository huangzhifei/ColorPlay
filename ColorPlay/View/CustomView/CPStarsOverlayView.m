//
//  StarsOverlayView.m
//  Test
//
//  Created by huangzhifei on 15/12/3.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPStarsOverlayView.h"
#import "GCDTimer.h"
#define LIFTTIME 15

@interface CPStarsOverlayView()

@property (strong, nonatomic) CAEmitterLayer    *emitter;
//@property (strong, nonatomic) CAEmitterCell     *particle;
@property (strong, nonatomic) GCDTimer          *gcdTimer;
@property (strong, nonatomic) UIImage           *emitterImage;

@end

@implementation CPStarsOverlayView

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if( self )
    {
        _emitterImage = [UIImage imageNamed:@"spark"];
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        _emitterImage = [UIImage imageNamed:@"spark"];
        _effectRunning = YES;
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor blackColor];
    
    [self setup];
}

- (void)setup
{
    //_emitter = (CAEmitterLayer *)self.layer;
    _emitter = [CAEmitterLayer layer];
    _emitter.emitterPosition = self.center;
    _emitter.emitterSize = self.bounds.size;
    _emitter.emitterMode = kCAEmitterLayerOutline;
    _emitter.emitterShape = kCAEmitterLayerCircle;
    //_emitter.renderMode = kCAEmitterLayerOldestFirst;
    _emitter.preservesDepth = true;
    
    CAEmitterCell *particle = [CAEmitterCell emitterCell];
    particle.name = @"spark";
    
    particle.contents = (id)[_emitterImage CGImage];
    particle.birthRate = 8;
    
    particle.lifetime = LIFTTIME;
    particle.lifetimeRange = 1;
    
    particle.velocity = 20;
    particle.velocityRange = 10;
    
    particle.scale = 0.03;
    particle.scaleRange = 0.05;
    particle.scaleSpeed = 0.02;
    
    _emitter.emitterCells = [NSArray arrayWithObject:particle];
    
    [self.layer addSublayer:_emitter];
}

- (void)setEmitterImage:(UIImage *)emitterImage
{
    _emitterImage = emitterImage;
    [[_emitter emitterCells] firstObject].contents = (id)[_emitterImage CGImage];
}

#pragma mark - override super

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _emitter.emitterPosition = self.center;
    _emitter.emitterSize = self.bounds.size;
}

/**
 *  不是显示当前窗口时，暂停粒子，优化性能
 */
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if( self.window )
    {
        if( !_gcdTimer )
        {
            _gcdTimer = [GCDTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^{
                
                [self produceParticles];
                
            }];
        }
    }
    else if(_gcdTimer)
    {
        [_gcdTimer invalidate];
        _gcdTimer = nil;
    }
}

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

- (void)dealloc
{
    [_gcdTimer invalidate];
}

#pragma mark - private Methods

- (void)produceParticles
{
    if( !self.emitter ) return;
    
    NSInteger sizeWidth = MAX(self.bounds.size.width, self.bounds.size.height);
    CGFloat radius = arc4random() % sizeWidth;
    self.emitter.emitterSize = CGSizeMake(radius, radius);
    [[self.emitter emitterCells] firstObject].birthRate = 15;
}

#pragma mark - public Methods

- (void)stopFireWork
{
    _effectRunning = NO;
    self.emitter.lifetime = 0;
    [self.emitter setValue:[NSNumber numberWithInteger:0] forKeyPath:@"emitterCells.spark.birthRate"];
    [self.emitter removeFromSuperlayer];
    self.emitter = nil;
}

- (void)restartFireWork
{
    _effectRunning = YES;
    self.emitter.lifetime = LIFTTIME;
    [self.emitter setValue:[NSNumber numberWithInteger:8] forKeyPath:@"emitterCells.spark.birthRate"];
    [self setup];
}

@end
