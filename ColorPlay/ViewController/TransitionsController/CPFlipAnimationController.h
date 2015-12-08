//
//  CEFlipAnimationController.h
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPFlipAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) CGFloat duration;

@property (nonatomic) BOOL presenting;

@end
