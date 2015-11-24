//
//  CPGameQuestion.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/22.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPGameQuestion : NSObject

/**
 *  cards object array
 */
@property (strong, nonatomic) NSArray *questionCards;

/**
 *  cardColor object array
 */
@property (strong, nonatomic) NSArray *questionOptions;

/**
 *  target color object index
 */
@property (nonatomic, readonly) NSInteger targetIndex;

/**
 *  stopwatch
 */
@property (nonatomic) NSInteger limitTime;

/**
 *  init with cards
 *
 *  @param cardList cards object array
 *
 *  @return self
 */
- (instancetype) initWithCardList:(NSArray *)cardList;

/**
 *  check match
 *
 *  @param answerIndex click tag
 *
 *  @return YES/NO
 */
- (BOOL)checkAnswer:(NSInteger)answerIndex;

/**
 *  get question, for example: background、color or meaning
 *
 *  @return question
 */
- (NSString *)getQuestion;

@end
