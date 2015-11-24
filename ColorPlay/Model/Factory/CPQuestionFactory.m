//
//  CPQuestionFactory.m
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPQuestionFactory.h"
#import "CPCardFactory.h"

@implementation CPQuestionFactory

#pragma mark - init

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static CPQuestionFactory *question;
    dispatch_once(&once, ^{
        
        question = [[CPQuestionFactory alloc] init];
        
    });
    
    return question;
}

#pragma mark - Public Method

- (CPGameQuestion *)createGameQuestionWithCount:(NSInteger)cardCount
{
    NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:cardCount];
    
    for(int i = 0; i < cardCount; ++ i)
    {
        CPGameCard *card = [[CPCardFactory sharedInstance] createCardColorWithCount:3];
        [cards addObject:card];
    }
    
    return [[CPGameQuestion alloc] initWithCardList:cards];
}

@end
