//
//  CPGameScene.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMacro.h"
#import "CPQuestionFactory.h"

@interface CPGameScene : NSObject

@property (nonatomic, readonly) NSInteger score;

@property (nonatomic, strong) CPGameQuestion *gameQuestion;

- (instancetype) initWithGameMode:(CPGameMode)gameMode;

- (void) nextQuestion;

@end
