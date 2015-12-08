//
//  CPGameScoreView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/11/23.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMacro.h"

@interface CPGameScoreView : UIView

- (instancetype)initWithFrame:(CGRect)frame Mode:(CPGameMode)mode score:(NSInteger)score;

- (void)startAnimation;

@end
