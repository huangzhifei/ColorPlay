//
//  SPEmitterView.m
//  StroopPlay
//
//  Created by huangzhifei on 15/11/5.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPEmitterView.h"


@implementation CPEmitterView
{
    CAEmitterLayer *_fireEmitter;
    
    NSString *_fireName;
    
    UIColor *_fireColor;
}


- (id)initWithFrame:(CGRect)frame color:(UIColor *)color name:(NSString *)name
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _fireEmitter = (CAEmitterLayer *)(self.layer);
        //_fireEmitter.emitterPosition = CGPointMake(0, 0);
        //_fireEmitter.emitterSize = CGSizeMake(5, 5);
        // 递增渲染模式
        _fireEmitter.renderMode = kCAEmitterLayerAdditive;
        _fireEmitter.emitterShape = kCAEmitterLayerCircle;
        
        CAEmitterCell *fireCell = [CAEmitterCell emitterCell];
        fireCell.birthRate = 5;
        fireCell.lifetime = 1;
        fireCell.lifetimeRange = 0;
        // 粒子颜色
        fireCell.color = color.CGColor;
        // 粒子内容
        fireCell.contents = (id)[[UIImage imageNamed:@"snow.png"] CGImage];
        // 粒子速度
        fireCell.velocity = 30;
        // 粒子速度范围
        fireCell.velocityRange = 1;
        // 粒子发射角度
        fireCell.emissionRange = 2;
        // 粒子变大速度
        fireCell.scaleSpeed = 0.3;
        // 旋转
        fireCell.spin = 3;
        
        [fireCell setName:name];
        
        _fireEmitter.emitterCells = [NSArray arrayWithObject:fireCell];
    }
    
    return self;
}

+(Class)layerClass
{
    return [CAEmitterLayer class];
}

@end
