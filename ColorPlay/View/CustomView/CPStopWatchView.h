//
//  CPStopWatchView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TimeOutBlock)();

@interface CPStopWatchView : UIView

@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) UIColor *outlineColor;

@property (assign, nonatomic) CGFloat outlineWidth;

@property (strong,nonatomic) UIFont *font;

@property (assign, nonatomic) NSInteger stopWatch;

- (instancetype) initWithFrame:(CGRect)frame stopWatch:(NSInteger)stopWatch;

- (void)fireStopWatch:(NSTimeInterval) delay timeOut:(TimeOutBlock)timeout;

@end
