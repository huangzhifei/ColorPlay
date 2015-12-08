//
//  CPCircularAnimationController.h
//  ColorPlay
//
//  Created by huangzhifei on 15/12/6.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  学习于 raywenderlich 讲解的思路，由 swift 改成 objective-c
 http://www.raywenderlich.com/86521/how-to-make-a-view-controller-transition-animation-like-in-the-ping-app
 */

/**
 *  CAShapeLayer + UIBezierPath
 */
@interface CPCircularAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) CGFloat duration;

@property (nonatomic) BOOL presenting;

@property (nonatomic) CGRect startRect;

@end
