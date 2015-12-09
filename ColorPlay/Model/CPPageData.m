//
//  CPPageData.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPPageData.h"
#define kName @"Tutorial.plist"

@interface CPPageData()

@end

@implementation CPPageData

-(instancetype)init
{
    self = [super init];
    
    if( self )
    {
        _photos= ({
            
            NSString *path = [[NSBundle mainBundle] pathForResource:kName ofType:nil];
            
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            
            array;
        });

    }
    
    return self;
}

@end
