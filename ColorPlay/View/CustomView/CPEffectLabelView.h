//
//  SPEffectLabel.h
//  StroopPlay
//
//  Created by huangzhifei on 15/11/7.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EffectLabelDirection)
{
    EffectLabelDirectionLeftToRight = 0,
    EffectLabelDirectionRightToLeft,
    EffectLabelDirectionTopLetfToBottomRight,
    EffectLabelDirectionBottomRightToTopLeft,
    EffectLabelDirectionCount
};

@interface CPEffectLabelView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

/**
 *  CGColor数组
 */
@property (nonatomic, strong) NSArray *effectColor;

@property (nonatomic, assign) EffectLabelDirection effectDirection;

@property (nonatomic, assign) NSTextAlignment textAlignment;

- (void)performEffectAnimation:(CFTimeInterval)seconds repeats:(BOOL)repeats;

@end
