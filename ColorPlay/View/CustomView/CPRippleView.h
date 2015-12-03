//
//  CPRippleView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/12/2.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^touchAnimation)(void);

@interface CPRippleView : UIView

@property (strong, nonatomic) UIColor *bgColor;

- (void)animationWithTouch:(touchAnimation)animation;

@end
