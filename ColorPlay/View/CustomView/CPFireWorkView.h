//
//  CPFireWorkView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/12/8.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockAnimation)(void);

@interface CPFireWorkView : UIView

- (id)initWithFrame:(CGRect)frame movePath:(CGPathRef)path;

- (void)startAnimation:(NSTimeInterval)duration block:(blockAnimation)block;

- (void)stopFireWork;

- (void)restartFireWork;

@end
