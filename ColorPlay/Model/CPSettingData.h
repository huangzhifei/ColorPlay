//
//  CPSettingData.h
//  ColorPlay
//
//  Created by huangzhifei on 15/11/27.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#define kMusicSelected          @"musicSelected"
#define kEffectSelected         @"effectSelected"
#define kBgEffectSeleted        @"bgEffectSelected"
#define kNotificationSeleted    @"notificationSelected"
#define kMusicVolumn            @"musicVolumn"
#define kEffectVolumn           @"effectVolumn"

@interface CPSettingData : NSObject

@property (assign, nonatomic) BOOL musicSelected;
@property (assign, nonatomic) BOOL effectSelected;
@property (assign, nonatomic) CGFloat musicVolumn;
@property (assign, nonatomic) CGFloat effectVolumn;
@property (assign, nonatomic) BOOL bgEffectSelected;
@property (assign, nonatomic) BOOL notificationSelected;

+ (instancetype)sharedInstance;

- (void)defaultSetting;

- (void)saveSetting;

@end
