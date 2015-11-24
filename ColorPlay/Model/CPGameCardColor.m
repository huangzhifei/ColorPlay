//
//  CPGameCardColor.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameCardColor.h"
#import "UIColor+Common.h"

@implementation CPGameCardColor

- (instancetype) initWithDict:(NSDictionary *)info
{
    self = [super init];
    
    if( self )
    {
        _colorName = [info objectForKey:@"Name"];
        
        _color = [UIColor colorWithHexString:[info objectForKey:@"Color"]];

    }
    
    return self;
}

@end
