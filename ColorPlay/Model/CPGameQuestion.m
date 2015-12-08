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
        
        //NSLog(@"_targetIndex: %ld", (long)self.targetIndex);
        
        CPGameCard *targetCard = cardList[self.targetIndex];
        
//        NSLog(@"targetCard: bg->%@ color->%@ meaning->%@", targetCard.bgColor.colorName
//              , targetCard.textColor.colorName, targetCard.textMeaningColor.colorName);
        
        self.questionOptions = [targetCard confuseCards];
        
        //NSLog(@"array{");
        for(int i = 0; i < self.questionOptions.count; ++ i)
        {
            NSLog(@"name: %@", [self.questionOptions[i] colorName]);
        }
        //NSLog(@"}");
        self.targetStatus = arc4random() % 3;
        
        //NSLog(@"targetStatus: %ld", (long)self.targetStatus);
        
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
