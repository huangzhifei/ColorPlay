//
//  CPRippleView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/2.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPRippleView.h"

@interface CPRippleView()

@end

@implementation CPRippleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.layer.cornerRadius = MIN(self.frame.size.width/2, self.frame.size.height/2);
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    self.alpha=0;
}

- (void)setBgColor:(UIColor *)bgColor
{
    self.backgroundColor = bgColor;
}


@end
