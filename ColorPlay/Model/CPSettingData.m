//
//  CPSettingData.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/27.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPSettingData.h"

#define kFirstSetting @"firstSetting"

@interface CPSettingData()

@property (nonatomic) BOOL firstSetting;

@end

@implementation CPSettingData

#pragma mark - init

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static CPSettingData *settingData;
    dispatch_once(&once, ^{
        
        settingData = [[CPSettingData alloc]init];
        [settingData commonInit];
    });
    
    return settingData;
}

- (void)commonInit
{
    _musicSelected = YES;
    _effectSelected = YES;
    _bgEffectSelected = YES;
    _notificationSelected = YES;
    
    _musicVolumn = 50;
    _effectVolumn = 50;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _firstSetting = [userDefault boolForKey:kFirstSetting];
    
    if(!_firstSetting)
    {
        [userDefault setBool:YES forKey:kFirstSetting];
        
        [self defaultSetting];
        
        return;
    }
}

#pragma mark - getter

- (BOOL)musicSelected
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _musicSelected = [userDefault boolForKey:kMusicSelected];
    
    return _musicSelected;
}

- (CGFloat)musicVolumn
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _musicVolumn = [userDefault floatForKey:kMusicVolumn];
    
    return _musicVolumn;
}

- (BOOL)effectSelected
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _effectSelected = [userDefault boolForKey:kEffectSelected];
    
    return _effectSelected;
}

- (CGFloat)effectVolumn
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _effectVolumn = [userDefault floatForKey:kEffectVolumn];
    
    return _effectVolumn;
}

- (BOOL)bgEffectSelected
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _bgEffectSelected = [userDefault floatForKey:kBgEffectSeleted];
    
    return _bgEffectSelected;
}

- (BOOL)notificationSelected
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    _notificationSelected = [userDefault floatForKey:kNotificationSeleted];
    
    return _notificationSelected;
}

#pragma mark - public method

- (void)defaultSetting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:YES forKey:kMusicSelected];
    [userDefault setFloat:50 forKey:kMusicVolumn];
    
    [userDefault setBool:YES forKey:kEffectSelected];
    [userDefault setFloat:50 forKey:kEffectVolumn];
    
    [userDefault setBool:YES forKey:kBgEffectSeleted];
    [userDefault setBool:YES forKey:kNotificationSeleted];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)saveSetting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:_musicSelected forKey:kMusicSelected];
    [userDefault setFloat:_musicVolumn forKey:kMusicVolumn];
    
    [userDefault setBool:_effectSelected forKey:kEffectSelected];
    [userDefault setFloat:_effectVolumn forKey:kEffectVolumn];
    
    [userDefault setBool:_bgEffectSelected forKey:kBgEffectSeleted];
    [userDefault setBool:_notificationSelected forKey:kNotificationSeleted];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
