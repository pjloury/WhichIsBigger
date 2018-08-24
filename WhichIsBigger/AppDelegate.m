//
//  AppDelegate.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

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
	
    NSLog(@"===============================START APP DELEGATE");
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    
    ParseClientConfiguration *clientConfig = [ParseClientConfiguration configurationWithBlock:^void(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"mQP5uTJvSvOmM2UNXxe31FsC5BZ1sP1rkABnynbd";
        configuration.clientKey = @"ckRmomV114XuUhuKU6WzpeY3zQg4h2McXCQSdEP9";
        configuration.server = @"https://fast-anchorage-42311.herokuapp.com/parse";
        configuration.localDatastoreEnabled = YES;
    }];
    
    [Parse initializeWithConfiguration:clientConfig];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    //[PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [PFUser enableAutomaticUser];
    // [PFUser enableRevocableSessionInBackground];
    
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[PFUser currentUser] setObject:@([WIBGamePlayManager sharedInstance].highScore) forKey:@"highScore"];
    [[PFUser currentUser] setObject:@([WIBGamePlayManager sharedInstance].longestStreak) forKey:@"longestStreak"];
    [[PFUser currentUser] setObject:@([WIBGamePlayManager sharedInstance].skewFactor) forKey:@"skewFactor"];
    [[PFUser currentUser] setObject:@([WIBGamePlayManager sharedInstance].questionFloor) forKey:@"questionFloor"];
    [[PFUser currentUser] setObject:@([WIBGamePlayManager sharedInstance].questionCeiling) forKey:@"questionCeiling"];
    
    [[PFUser currentUser] saveInBackground];
}

# pragma mark - Remote Notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
