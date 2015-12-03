//
//  CPAnimation3DMenuView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/21.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^touchAnimation)(void);

@interface CPAnimation3DItem : UIButton

- (void)touchUpInsideAnimation:(touchAnimation)block;

@end


@interface CPAnimation3DMenuView : UIView

/**
 *  init 3D menu view
 *
 *  @param frame    menu view frame
 *  @param array    3D item array
 *  @param radius   menu view circle radius
 *  @param duration rotate once time
 *
 *  @return self
 */
- (instancetype) initWithFrame:(CGRect)frame
                    itemsArray:(NSArray *)array
                        radius:(CGFloat)radius
                      duration:(CGFloat)duration;

@end
