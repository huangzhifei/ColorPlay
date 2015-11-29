//
//  AppDelegate.m
//  StroopPlay
//
//  Created by huangzhifei on 15/11/4.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "AppDelegate.h"
#import "CPMenuViewController.h"
#import "CPAboutViewController.h"
#import "MobClick.h"
#import "CPMacro.h"
#import "CPSettingData.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[NSThread sleepForTimeInterval:3.5];//设置启动页面时间
    
    //[self registerUmeng];
    
    [self readSettingData];
    
    // hidden status bar 
    [application setStatusBarHidden:YES];
    
    // 1 -- window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2 -- window bg
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 3 -- rootVC
    //CPMenuViewController *rootVC = [CPMenuViewController initWithNib];
    CPAboutViewController *rootVC = [CPAboutViewController initWithNib];
    // 4 -- rootNavc
    UINavigationController *rootNaVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    // 5 -- set navigation bar hidden
    [rootNaVC setNavigationBarHidden:YES];
    
    // 6 -- set root
    self.window.rootViewController = rootNaVC;
    
    // 7 -- make visible
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private methods

- (void)registerUmeng
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary ] objectForKey:kVersion];
    
    [MobClick setAppVersion:version];
    
    [MobClick startWithAppkey:kUmengAppKey reportPolicy:BATCH channelId:kChannelID];
}

- (void)readSettingData
{
    //CPSettingData *setting = [CPSettingData sharedInstance];
    
}

@end
