//
//  CPResultViewController.h
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMacro.h"

@interface CPResultViewController : UIViewController

@property (assign, nonatomic) CPGameMode gameMode;
@property (assign, nonatomic) NSInteger score;

+ (instancetype)initWithNib;

@end
