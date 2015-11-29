//
//  CPSettingData.h
//  ColorPlay
//
//  Created by huangzhifei on 15/11/27.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kMusicSelected          @"musicSelected"
#define kEffectSelected         @"effectSelected"
#define kBgEffectSeleted        @"bgEffectSelected"
#define kNotificationSeleted    @"notificationSelected"
#define kMusicVolumn            @"musicVolumn"
#define kEffectVolumn           @"effectVolumn"

@interface CPSettingData : NSObject

@property (nonatomic) BOOL musicSelected;
@property (nonatomic) BOOL effectSelected;
@property (nonatomic) CGFloat musicVolumn;
@property (nonatomic) CGFloat effectVolumn;
@property (nonatomic) BOOL bgEffectSelected;
@property (nonatomic) BOOL notificationSelected;

+ (instancetype)sharedInstance;

- (void)defaultSetting;

- (void)saveSetting;

@end
