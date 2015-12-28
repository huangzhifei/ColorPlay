//
//  CPGameCard.h
//  ColorPlay
//
//  Created by huangzhifei on 15/10/18.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameCardColor.h"

/**
 * order must same with init colors array
 */
typedef NS_ENUM(NSInteger, CPQuestionType) {

    CPBackgroundColor = 0,
    /**
     *  content mean color
     */
    CPTextMeaningColor,

    CPTextColor,
    
    CPQuestionTypeCount
};

@interface CPGameCard : NSObject

@property (strong, nonatomic, readonly) CPGameCardColor *bgColor;

@property (strong, nonatomic, readonly) CPGameCardColor *textMeaningColor;

@property (strong, nonatomic, readonly) CPGameCardColor *textColor;


- (instancetype) initWithColorArray:(NSArray *)colors;

- (NSArray *)confuseCards;

- (NSInteger)getAnswerByOptions:(NSArray *)options status:(CPQuestionType)status;

@end
