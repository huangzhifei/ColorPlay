//
//  CPGameCardColor.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/15.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPGameCardColor : NSObject

@property (strong, nonatomic, readonly) UIColor *color;

@property (strong, nonatomic, readonly) NSString *colorName;

- (instancetype) initWithDict:(NSDictionary *)info;

@end
