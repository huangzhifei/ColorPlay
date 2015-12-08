//
//  AppDelegate.h
//  StroopPlay
//
//  Created by huangzhifei on 15/11/4.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPExplodeAnimationController.h"

#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

