//
//  CPOutlineLabel.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPOutlineLabel.h"

@implementation CPOutlineLabel

#pragma mark - initlize

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [self initlize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self initlize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self initlize];
    }
    
    return self;
}

- (void)initlize
{
    _outlineColor = [UIColor whiteColor];
    _outlineWith  = 2.0f;
}

#pragma mark - draw

- (void) setOutlineColor:(UIColor *)outlineColor
{
    _outlineColor = outlineColor;
    
    [self setNeedsDisplay];
}

- (void) setOutlineWith:(CGFloat)outlineWith
{
    _outlineWith = outlineWith;
    
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef cct = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cct, self.outlineWith);
    CGContextSetLineJoin(cct, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(cct, kCGTextStroke);
    self.textColor = self.outlineColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(cct, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;

}

@end
