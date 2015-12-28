//
//  CPSoundManager.h
//  Test
//
//  Created by huangzhifei on 15/12/1.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

@interface CPSoundManager : NSObject

+ (instancetype)sharedInstance;

- (void)preloadBackgroundMusic:(NSString*)fileName;

/**
 *  play music with loops
 *
 *  @param fileName music name eg: xx.mp3
 *  @param loops    YES: play loop, NO: play once, default YES
 */
- (void)playBackgroundMusic:(NSString *)fileName loops:(BOOL)loops;

- (void)resumeBackgroundMusic;

- (void)stopBackgroundMusic;

/**
 *  volume 0.0f - 1.0f, default 0.5f
 */
@property (assign, nonatomic) CGFloat musicVolume;

- (void)preloadEffect:(NSString*)fileName;

/**
 *  play effect with vibrate
 *
 *  @param fileName effect, eg: xx.mp3
 *  @param vibrate  YES: vibrate, default NO
 */
- (void)playEffect:(NSString *)fileName vibrate:(BOOL)vibrate;

/**
 *  volume 0.0f - 1.0f, default 0.5f
 */
@property (assign, nonatomic) CGFloat effectVolume;

@end
