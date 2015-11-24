//
//  CPColorFactory.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPGameCardColor.h"

@interface CPColorFactory : NSObject

+ (instancetype)shareInstance;

- (CPGameCardColor *)createRandomColor;

@end
