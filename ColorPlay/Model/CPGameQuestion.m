//
//  CPGameQuestion.m
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameQuestion.h"
#import "CPGameCard.h"

@interface CPGameQuestion()

@property (nonatomic) CPQuestionType targetStatus;
@property (nonatomic) NSInteger answerIndex;

@end

@implementation CPGameQuestion

#pragma  mark - init

- (instancetype)initWithCardList:(NSArray *)cardList
{
    self = [super init];
    
    if(self)
    {
        self.questionCards = cardList;
        
        _targetIndex = arc4random() % cardList.count;
        
        CPGameCard *targetCard = cardList[self.targetIndex];
        
        self.questionOptions = [targetCard confuseCards];
        
        _targetStatus = arc4random() % 3;
        
        _answerIndex = [targetCard getAnswerByOptions:self.questionOptions status:self.targetStatus];
        
        //NSLog(@"answerIndex: %ld", self.answerIndex);
    }
    
    return self;
}

#pragma  public Method

- (BOOL)checkAnswer:(NSInteger)answerIndex
{
    NSLog(@"checkAnswer: %ld",(long)answerIndex);
    return answerIndex == self.answerIndex;
}

- (NSString *)getQuestion
{
    switch (self.targetStatus)
    {
        case CPBackgroundColor:
            return @"Background";
            
        case CPTextMeaningColor:
            return @"Meaning";
            
        case CPTextColor:
            return @"Color";
            
        default:
            break;
    }
    return nil;
}

@end
