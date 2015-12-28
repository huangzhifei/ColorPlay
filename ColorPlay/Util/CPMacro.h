//
//  CPMacro.h
//  ColorPlay
//
//  Created by huangzhifei on 15/09/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#ifndef CPMacro_h
#define CPMacro_h

#define kUmengAppKey        @"5641ff5be0f55af099003237"
#define kChannelID          @"App store"
#define kVersion            @"CFBundleShortVersionString"
#define kScreen             [[UIScreen mainScreen] bounds]
#define kGameMusic          @"gameMusic.wav"
#define kMainMusic          @"mainMusic.wav"
#define kSenceEffect        @"shooter-action.wav"
#define kShotEffect         @"catch.wav"
#define kClassicHighScore   @"ClassicHighScore"
#define kFantasyHighScore   @"FantasyHighScore"

typedef NS_ENUM(NSInteger, CPGameMode)
{
    CPGameClassicMode = 0,
    CPGameFantasyMode
};

#endif /* CPMacro_h */
