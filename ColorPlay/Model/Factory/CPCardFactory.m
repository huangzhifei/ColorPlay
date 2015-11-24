//
//  CPCardFactory.m
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPCardFactory.h"
#import "CPColorFactory.h"

@implementation CPCardFactory

#pragma mark - init

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static CPCardFactory *card;
    dispatch_once(&once, ^{
        card = [[CPCardFactory alloc] init];
    });
    
    return card;
}

#pragma mark - Public Method

- (CPGameCard *)createCardColorWithCount:(NSInteger)CardColorCount
{
    NSMutableArray *CardColorArray = [[NSMutableArray alloc] initWithCapacity:CardColorCount];
    
    while( CardColorArray.count < CardColorCount )
    {
        CPGameCardColor *cardColor = [[CPColorFactory shareInstance] createRandomColor];
        
        __block BOOL isExist = NO;
        [CardColorArray enumerateObjectsUsingBlock:^(CPGameCardColor *obj, NSUInteger idx, BOOL *stop) {
            
            if( [obj.colorName isEqualToString:cardColor.colorName] )
            {
                isExist = YES;
                *stop = YES;
            }
        }];
        
        if( !isExist )
        {
            [CardColorArray addObject:cardColor];
        }
    }
    
    return [[CPGameCard alloc] initWithColorArray:CardColorArray];
}

@end
