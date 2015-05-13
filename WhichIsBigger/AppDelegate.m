//
//  AppDelegate.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "WIBParseManager.h"
#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"
#import "WIBHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    
    // Do not cache PF Objects unless we know that they contain all the required properties
    //[Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"mQP5uTJvSvOmM2UNXxe31FsC5BZ1sP1rkABnynbd"
                  clientKey:@"ckRmomV114XuUhuKU6WzpeY3zQg4h2McXCQSdEP9"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self.window setRootViewController:[[WIBHomeViewController alloc]init]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    return YES;
}

//-(void)loadInitialViewController
//{
//    //Create first view controller
//    NewLoginViewController* ipadLoginViewController = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:[NSBundle mainBundle]];
//    
//    //if you want a nav controller do this
//    UINavigationController *navController =  [[UINavigationController alloc]initWithRootViewController:ipadLoginViewController];
//    
//    //add them to window
//    [self.window addSubview:self.navController.view];
//    [self.window setRootViewController:self.navController];
//    
//    
//    if([standardUserDefaults objectForKey:@"PassCorrect"])
//    {
//        //push the next view controller on the stack inside the initial view
//        [ipadLoginViewController bypassLoginView];
//    }
//    
//}



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

@end
