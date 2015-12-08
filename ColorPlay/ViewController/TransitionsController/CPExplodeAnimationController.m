//
//  CPExplodeAnimationController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/4.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPExplodeAnimationController.h"

@implementation CPExplodeAnimationController

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
    
    /**
     *  在iOS9.1上，使用了AutoLayout后，这时的frame还没有布局，即为(600,600)
     *  必须使用下面方法，在iOS7、iOS8上没有这问题
     *  http://stackoverflow.com/questions/20312765/navigation-controller-top-layout-guide-not-honored-with-custom-transition
     */
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xWith = 20.0f;
    CGFloat yHeight = xWith;
    
    /**
     *  view 最多add 1500 subviews，建议此处不要切割最小，会影响效率
     */
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat x=0; x < size.width; x+= xWith)
    {
        for (CGFloat y=0; y < size.height; y+= yHeight)
        {
            CGRect snapshotRegion = CGRectMake(x, y, xWith, yHeight);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion
                                                            afterScreenUpdates:NO
                                                                 withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
        }
    }
    
    NSLog(@"count %lu", (unsigned long)[snapshots count]);
    [containerView sendSubviewToBack:fromView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         for (UIView *view in snapshots)
                         {
                             CGFloat xOffset = [self randomFloatBetween:-200.0 and:200.0];
                             CGFloat yOffset = [self randomFloatBetween:fromView.frame.size.height
                                                                    and:fromView.frame.size.height * 1.3];
                             view.frame = CGRectOffset(view.frame, xOffset, yOffset);
                             view.alpha = 0.0;
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         for (UIView *view in snapshots)
                         {
                             [view removeFromSuperview];
                         }
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         
                     }];

}

#pragma mark - private Methods

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    
    return fmodf(arc4random() / 100.0, diff) + smallNumber;
    
}

@end
