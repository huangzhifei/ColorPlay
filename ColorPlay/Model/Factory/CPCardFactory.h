//
//  CPCardFactory.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPGameCard.h"

@interface CPCardFactory : NSObject

+(instancetype) sharedInstance;

- (CPGameCard *)createCardColorWithCount:(NSInteger)CardColorCount;

@end
