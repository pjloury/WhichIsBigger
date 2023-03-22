//
//  AppDelegate.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

// 2023 TODO:
// Implement GameItem isPerson method

// Check if Request Review has intelligence
// Add intelligence to "Share w/ a Friend"
// GADNativeContentAd w/ GADNativeContentAdView
// Add White Outline to Points Text
// Question String: Change to "Who" when applicable
// Want to compare yourself to others? Tap on your "Best Round" to view the leaderboard!
// Looks like you're enjoying playing Which is Bigger? Would you like to share it with a friend?
// Animate Points to the total

#import "AppDelegate.h"
#import "WIBNetworkManager.h"
#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"
#import "WIBHomeViewController.h"
@import GoogleMobileAds;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	  [application setStatusBarHidden:YES];
	
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    NSLog(@"===============================START APP DELEGATE");
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    
    if ([GKLocalPlayer localPlayer].authenticated == YES) {
        [[WIBGamePlayManager sharedInstance] authenticateGameKitUser];
    }
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    [FIRApp configure]; // This apparently isn't coming back on main thread
    
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-4490282633558794~6852699468"];

    NSLog(@"===============================END APP DELEGATE");
    return YES;
}

 
@end
