//
//  CPGameCard.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameCard.h"

@interface CPGameCard()

@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation CPGameCard

- (instancetype)initWithColorArray:(NSArray *)colors
{
    self = [super init];
    
    if( self )
    {
        NSAssert( colors.count==3, @"NSArray count should equal or greater than 3");
        
        _bgColor = [colors objectAtIndex:CPBackgroundColor];
        
        _textMeaningColor = [colors objectAtIndex:CPTextMeaningColor];
        
        _textColor = [colors objectAtIndex:CPTextColor];
        
        self.colorArray = colors;
        
    }
    
    return self;
}

- (NSArray *)confuseCards
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:self.colorArray];
    for(NSInteger i = 0; i < self.colorArray.count; ++ i)
    {
        NSInteger j = self.colorArray.count - i;
        NSInteger k = (arc4random() % j) + i;
        [result exchangeObjectAtIndex:i withObjectAtIndex:k];
    }
    
    return result;
}

- (NSInteger)getAnswerByOptions:(NSArray *)options status:(CPQuestionType)status
{
    CPGameCardColor *targetColor = self.colorArray[status];

    for(NSInteger index = 0; index < options.count; index++)
    {
        CPGameCardColor *color = options[index];
        if ([targetColor.colorName isEqualToString:color.colorName])
        {
            return index;
        }
    }
    
    return options.count;
}

@end
