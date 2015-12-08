//
//  CEFlipAnimationController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CPFlipAnimationController.h"

@implementation CPFlipAnimationController

- (instancetype)init
{
    self = [super init];
    
    if( self )
    {
        _duration = 1.0f;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 1.0f;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;

    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame =  initialFrame;
    toView.frame = initialFrame;
    
    NSArray* toViewSnapshots = [self createSnapshots:toView afterScreenUpdates:YES];
    UIView* flippedSectionOfToView = toViewSnapshots[self.presenting ? 0 : 1];
    
    NSArray* fromViewSnapshots = [self createSnapshots:fromView afterScreenUpdates:NO];
    UIView* flippedSectionOfFromView = fromViewSnapshots[self.presenting ? 1 : 0];
    
    flippedSectionOfFromView = [self addShadowToView:flippedSectionOfFromView reverse:!self.presenting];
    UIView* flippedSectionOfFromViewShadow = flippedSectionOfFromView.subviews[1];
    flippedSectionOfFromViewShadow.alpha = 0.0;
    
    flippedSectionOfToView = [self addShadowToView:flippedSectionOfToView reverse:self.presenting];
    UIView* flippedSectionOfToViewShadow = flippedSectionOfToView.subviews[1];
    flippedSectionOfToViewShadow.alpha = 1.0;
    
    [self updateAnchorPointAndOffset:CGPointMake(self.presenting ? 0.0 : 1.0, 0.5) view:flippedSectionOfFromView];
    [self updateAnchorPointAndOffset:CGPointMake(self.presenting ? 1.0 : 0.0, 0.5) view:flippedSectionOfToView];
    
    flippedSectionOfToView.layer.transform = [self rotate:self.presenting ? M_PI_2 : -M_PI_2];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    
                                                                    flippedSectionOfFromView.layer.transform = [self rotate:self.presenting ? -M_PI_2 : M_PI_2];
                                                                    flippedSectionOfFromViewShadow.alpha = 1.0;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    
                                                                    flippedSectionOfToView.layer.transform = [self rotate:self.presenting ? 0.001 : -0.001];
                                                                    flippedSectionOfToViewShadow.alpha = 0.0;
                                                                }];
                              } completion:^(BOOL finished) {
                                  
                                  
                                  if ([transitionContext transitionWasCancelled]) {
                                      [self removeOtherViews:fromView];
                                  } else {
                                      [self removeOtherViews:toView];
                                  }
                                  
                                  
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
    
}


- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView* containerView = viewToKeep.superview;
    for (UIView* view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}


- (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse {
    
    UIView* containerView = view.superview;
    
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    [containerView insertSubview:viewWithShadow aboveSubview:view];
    [view removeFromSuperview];
    
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, 0.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

- (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    UIView* containerView = view.superview;
    
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    [containerView sendSubviewToBack:view];
    
    return @[leftHandView, rightHandView];
}

- (void)updateAnchorPointAndOffset:(CGPoint)anchorPoint view:(UIView*)view {
    view.layer.anchorPoint = anchorPoint;
    float xOffset =  anchorPoint.x - 0.5;
    view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0);
}


- (CATransform3D) rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

@end
