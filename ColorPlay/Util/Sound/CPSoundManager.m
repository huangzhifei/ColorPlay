//
//  CPSoundManager.m
//  Test
//
//  Created by huangzhifei on 15/12/1.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPSoundManager.h"
#import <AVFoundation/AVFoundation.h>

@interface CPSoundManager()<AVAudioPlayerDelegate>
{
    NSString *_lastMusic;
    NSString *_lastEffect;
}

@property (strong, nonatomic) AVAudioPlayer *soundMusic;
@property (strong, nonatomic) AVAudioPlayer *soundEffect;

@end


@implementation CPSoundManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static CPSoundManager *instance;
    
    dispatch_once(&once, ^{
        
        instance = [[CPSoundManager alloc] init];
        
        [instance commonInit];
    });
    
    return instance;
}

- (void)commonInit
{
    _effectVolume = 0.5f;
    _musicVolume = 0.5f;
}

- (void)preloadBackgroundMusic:(NSString*)fileName
{
    if( [_lastMusic isEqualToString:fileName] ) return;
    
    _lastMusic = fileName;
    
    NSURL *filePath = ({
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *strPath = [path stringByAppendingPathComponent:_lastMusic];
        NSURL *url = [NSURL fileURLWithPath:strPath];
        url;
        
    });
    
    [self.soundMusic stop];
    
    NSError *error = nil;
    
    self.soundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:&error];
    
    NSLog(@"sound %@", self.soundMusic);
    
    if(error)
    {
        NSLog(@"Failed to load the sound: %@", [error localizedDescription]);
        
        return;
    }
    
    [self.soundMusic prepareToPlay];
    
}

- (void)playBackgroundMusic:(NSString *)fileName loops:(BOOL)loops
{
    [self preloadBackgroundMusic:fileName];
    
    if( loops )
    {
        self.soundMusic.numberOfLoops = -1;
    }
         
    if( !self.soundMusic.isPlaying )
    {
        self.soundMusic.volume = self.musicVolume;
        [self.soundMusic play];
        //self.soundMusic.currentTime = 0.0f;
    }
//    else
//    {
//        self.soundMusic.volume = self.musicVolume;
//        [self.soundMusic play];
//    }
}

- (void)resumeBackgroundMusic
{
    [self.soundMusic play];
}

- (void)stopBackgroundMusic
{
    [self.soundMusic stop];
}

- (void)setMusicVolume:(CGFloat)musicVolume
{
    NSAssert(self.soundMusic != nil, @"you should first set preloadBackgroundMusic or playBackgroundMusic");
    _musicVolume = musicVolume;
    [self.soundMusic setVolume:_musicVolume];
}

- (void)preloadEffect:(NSString*)fileName
{
    if( [_lastEffect isEqualToString:fileName] ) return;
    
    _lastEffect = fileName;
    
    NSURL *filePath = ({
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *strPath = [path stringByAppendingPathComponent:_lastEffect];
        NSURL *url = [NSURL fileURLWithPath:strPath];
        url;
        
    });
    
    [self.soundEffect stop];
    self.soundEffect = nil;
    
    NSError *error = nil;
    
    self.soundEffect = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:&error];
    
    if(error)
    {
        NSLog(@"Failed to load the effect: %@", [error localizedDescription]);
        
        return;
    }
    
    [self.soundEffect prepareToPlay];
}

- (void)playEffect:(NSString *)fileName vibrate:(BOOL)vibrate
{
    [self preloadEffect:fileName];
    
    if(!self.soundEffect.isPlaying)
    {
        self.soundEffect.volume = self.effectVolume;
        [self.soundEffect play];
    }
    if( vibrate )
    {
        [self vibrate];
    }
}

- (void)setEffectVolume:(CGFloat)effectVolume
{
    NSAssert(self.soundEffect != nil, @"you should first set preloadEffect or playEffect");
    _effectVolume = effectVolume;
    [self.soundEffect setVolume:_effectVolume];
}

//震动
- (void)vibrate
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

@end


