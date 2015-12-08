//
//  CPFireWorkView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/8.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPFireWorkView.h"
#import "GCDTimer.h"

@interface CPFireWorkView()
{
    CAEmitterLayer *emitterLayer;
}

@property (strong, nonatomic) blockAnimation completionBlock;
@property (assign, nonatomic) CGFloat duration;
@property CGPathRef path;

@end

@implementation CPFireWorkView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame movePath:(CGPathRef)path;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _path = path;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

#pragma mark - override

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}

#pragma mark - public Methods

- (void)startAnimation:(NSTimeInterval)duration block:(blockAnimation)block
{
    self.completionBlock = block;
    self.duration = duration;
    
    [self animationEmitter];
    [self animationMoveWithPath:self.path];

    [GCDTimer scheduledTimerWithTimeInterval:self.duration repeats:NO block:^{
        
        [self stopFireWork];
        
        if( self.completionBlock )
        {
            self.completionBlock();
        }
        
    }];
}

- (void)stopFireWork
{
    emitterLayer.lifetime = 0;
}

- (void)restartFireWork
{
    emitterLayer.lifetime = 1;
}

#pragma mark - private Methods

- (void)animationEmitter
{
    emitterLayer = (CAEmitterLayer *)self.layer;
    emitterLayer.emitterPosition = CGPointMake(-self.bounds.size.width/2, 0);
    emitterLayer.emitterSize = self.bounds.size;
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    emitterLayer.emitterMode = kCAEmitterLayerPoints;
    emitterLayer.emitterShape = kCAEmitterLayerSphere;
    
    CAEmitterCell *cell1 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"starred"] CGImage]];
    cell1.scale = 0.3;
    cell1.scaleRange = 0.3;
    
    CAEmitterCell *cell2 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"starredhalf"] CGImage]];
    cell2.scale = 0.2;
    cell2.scaleRange = 0.2;
    
    CAEmitterCell *cell3 = [self productEmitterCellWithContents:(id)[[UIImage imageNamed:@"starredept"] CGImage]];
    cell2.scale = 0.03;
    cell2.scaleRange = 0.03;
    
    emitterLayer.emitterCells = @[cell1, cell2, cell3];
}

- (CAEmitterCell *)productEmitterCellWithContents:(id)contents
{
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 100;
    cell.lifetime = 1.0;
    cell.lifetimeRange = 0.3;
    cell.contents = contents;
    cell.color = [[UIColor whiteColor] CGColor];
    cell.velocity = 50;
    cell.emissionLongitude = M_PI*2;
    cell.emissionRange = M_PI*2;
    cell.velocityRange = 10;
    cell.spin = 2;
    
    return cell;
}

- (void)animationMoveWithPath:(CGPathRef)path
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"emitterPosition"];
    animation.path = path;
    animation.duration = self.duration;
    animation.repeatCount = 1;
    [self.layer addAnimation:animation forKey:@"path"];
}

#pragma mark - animation delegate

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    
//}

@end
