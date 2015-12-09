//
//  CPColorFactory.m
//  ColorPlay
//
//  Created by huangzhifei on 15/10/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPColorFactory.h"
#define kName @"ColorList.plist"

@interface CPColorFactory()

@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation CPColorFactory

#pragma mark - init

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static CPColorFactory *colorFactory;
    dispatch_once(&once, ^{
        colorFactory = [[CPColorFactory alloc] init];
        [colorFactory initColorPlist];
    });
    
    return colorFactory;
}

#pragma mark - Public Method

- (CPGameCardColor *)createRandomColor
{
    NSInteger index = arc4random() % self.colorArray.count;
    
    return [self.colorArray objectAtIndex:index];
}

#pragma mark - Private Method

- (void)initColorPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kName ofType:nil];
    
    _colorArray = ({
        
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in array)
        {
            [mutableArray addObject:[[CPGameCardColor alloc] initWithDict:dic]];
        }
        
        mutableArray;
    });

}

@end
