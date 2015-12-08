//
//  CPCircularAnimationController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/6.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPCircularAnimationController.h"

@interface CPCircularAnimationController()

@property (strong, nonatomic) UIBezierPath *maskPath;
@property (strong, nonatomic) UIViewController *toVC;
@property (strong, nonatomic) UIViewController *fromVC;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CPCircularAnimationController

- (instancetype) init
{
    self = [super init];
    
    if( self )
    {
        _duration = 0.5f;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toVC.view.frame = [transitionContext finalFrameForViewController:self.toVC];
    
    CGFloat startX = self.toVC.view.frame.origin.x;
    CGFloat startY = self.toVC.view.frame.origin.y;
    CGFloat endX = startX + self.toVC.view.frame.size.width;
    CGFloat endY = startY + self.toVC.view.frame.size.height;
    CGFloat radius = sqrt((endX - startX)*(endX - startX) + (endY - startY)*(endY - startY));
    
    CGFloat startMin = MIN(self.startRect.size.width, self.startRect.size.height);
    CGFloat leftTopX = -(radius - (self.startRect.origin.x + startMin/2));
    CGFloat leftTopY = -(radius - (self.startRect.origin.y + startMin/2));
    
    // push
    if (self.presenting)
    {
        [transitionContext.containerView addSubview:self.fromVC.view];
        [transitionContext.containerView addSubview:self.toVC.view];
        
        self.maskPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.startRect.origin.x,
                                                                          self.startRect.origin.y,
                                                                          startMin,
                                                                          startMin)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        maskLayer.frame = self.toVC.view.frame;
        maskLayer.path = self.maskPath.CGPath;
        self.toVC.view.layer.mask = maskLayer;
        
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(leftTopX, leftTopY,
                                                                                    radius*2, radius*2)];

        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
        pathAnim.delegate = self;
        pathAnim.fromValue = (id)self.maskPath.CGPath;
        pathAnim.toValue = (id)finalPath.CGPath;
        pathAnim.duration = [self transitionDuration:transitionContext];
        maskLayer.path = finalPath.CGPath;
        [maskLayer addAnimation:pathAnim forKey:@"path"];
    }
    
    // pop
    else
    {
        [transitionContext.containerView addSubview:self.toVC.view];
        [transitionContext.containerView addSubview:self.fromVC.view];
        
        self.maskPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(leftTopX, leftTopY, radius*2, radius*2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.fromVC.view.frame;
        maskLayer.path = self.maskPath.CGPath;
        self.fromVC.view.layer.mask = maskLayer;
        
        UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.startRect.origin.x,
                                                                                    self.startRect.origin.y,
                                                                                    startMin,
                                                                                    startMin)];
        
        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
        pathAnim.delegate = self;
        pathAnim.fromValue = (id)self.maskPath.CGPath;
        pathAnim.toValue = (id)finalPath.CGPath;
        pathAnim.duration = [self transitionDuration:transitionContext];
        maskLayer.path = finalPath.CGPath;
        [maskLayer addAnimation:pathAnim forKey:@"path"];
    }
    
    //[self performSelector:@selector(finishTransition:) withObject:transitionContext afterDelay:[self transitionDuration:transitionContext]];

}

#pragma mark - CABasicAnimation - delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
}

//-(void)finishTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    [transitionContext completeTransition:YES];
//}

@end
