//
//  CPGameScene.m
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameScene.h"

#define MAXSTOPTIMER 7

@interface CPGameScene()

@property (assign, nonatomic) CPGameMode currentMode;
@property (strong, nonatomic) CPQuestionFactory *questionFactory;

@end

@implementation CPGameScene

#pragma mark - init

- (instancetype)initWithGameMode:(CPGameMode)gameMode
{
    self = [super init];
    
    if( self )
    {
        _currentMode = gameMode;
        _score = 0;
        self.questionFactory = [CPQuestionFactory shareInstance];
        self.gameQuestion = [_questionFactory createGameQuestionWithCount:1];
        self.gameQuestion.limitTime = [self limitTime];
    }
    
    return self;
}

- (NSInteger)limitTime
{
    NSInteger MAXTime = MAXSTOPTIMER;
    
    if( self.score >= 0 && self.score <= 10 )
    {
        return MAXTime;
    }
    
    else if( self.score > 10 && self.score <= 20 )
    {
        return MAXTime - 1;
    }
    
    else if( self.score > 20 && self.score <= 30 )
    {
        return MAXTime - 2;
    }
    
    else if( self.score > 30 && self.score <= 40 )
    {
        return MAXTime - 3;
    }
    
    else
    {
        return MAXTime - 4;
    }
    
}

#pragma mark - public method

- (void)nextQuestion
{
    _score ++;
    NSInteger cardCount = 1;
    if( self.score > 10 && self.currentMode == CPGameFantasyMode )
    {
        cardCount = 2;
    }
    
    CPGameQuestion *question = [self.questionFactory createGameQuestionWithCount:cardCount];
    question.limitTime = [self limitTime];
    self.gameQuestion = question;
}
@end
