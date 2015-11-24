//
//  CPQuestionFactory.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPGameQuestion.h"

@interface CPQuestionFactory : NSObject

+ (instancetype) shareInstance;

- (CPGameQuestion *)createGameQuestionWithCount:(NSInteger)cardCount;

@end
