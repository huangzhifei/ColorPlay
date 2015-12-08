//
//  StarsOverlayView.m
//  Test
//
//  Created by huangzhifei on 15/12/3.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPStarsOverlayView.h"
#import "GCDTimer.h"
#define LIFTTIME 10

@interface CPStarsOverlayView()

@property (strong, nonatomic) CAEmitterLayer    *emitter;
@property (strong, nonatomic) CAEmitterCell     *particle;
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
    _emitter = (CAEmitterLayer *)self.layer;
    _emitter.emitterMode = kCAEmitterLayerOutline;
    _emitter.emitterShape = kCAEmitterLayerCircle;
    //_emitter.renderMode = kCAEmitterLayerOldestFirst;
    _emitter.preservesDepth = true;
    
    _particle = [CAEmitterCell emitterCell];
    _particle.name = @"spark";
    
    _particle.contents = (id)[_emitterImage CGImage];
    _particle.birthRate = 10;
    
    _particle.lifetime = LIFTTIME;
    _particle.lifetimeRange = 1;
    
    _particle.velocity = 20;
    _particle.velocityRange = 10;
    
    _particle.scale = 0.02;
    _particle.scaleRange = 0.1;
    _particle.scaleSpeed = 0.02;
    
    _emitter.emitterCells = [NSArray arrayWithObject:_particle];
    
}

- (void)setEmitterImage:(UIImage *)emitterImage
{
    _emitterImage = emitterImage;
    _particle.contents = (id)[_emitterImage CGImage];
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
    NSInteger sizeWidth = MAX(self.bounds.size.width, self.bounds.size.height);
    CGFloat radius = arc4random() % sizeWidth;
    _emitter.emitterSize = CGSizeMake(radius, radius);
    _particle.birthRate = 15;
}

#pragma mark - public Methods

- (void)stopFireWork
{
    _emitter.lifetime = 0;
    [_emitter setValue:[NSNumber numberWithInteger:0] forKeyPath:@"emitterCells.spark.birthRate"];
    [_gcdTimer invalidate];
    
}

- (void)restartFireWork
{
    _emitter.lifetime = LIFTTIME;
    [_emitter setValue:[NSNumber numberWithInteger:10] forKeyPath:@"emitterCells.spark.birthRate"];
}

@end
