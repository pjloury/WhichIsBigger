//
//  WIBNetworkManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBNetworkManager.h"
#import <Parse/Parse.h>

// Data Model
#import "WIBGameQuestion.h"
#import "WIBQuestionType.h"
#import "WIBDataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDWebImagePrefetcher.h"
#import "WIBGamePlayManager.h"

@implementation WIBNetworkManager

+ (WIBNetworkManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBNetworkManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBNetworkManager alloc] init];
        shared.reachability = [WIBReachability reachabilityForInternetConnection];
    });
    
    return shared;
}

- (void)getConfigurationWithCompletion:(void (^)())completion
{    
    PFConfig *optimisticConfig = [PFConfig currentConfig];
    if (optimisticConfig) {
        NSLog(@"=============================== USING CACHED CONFIG");
        [PFConfig getConfigInBackground];
        if (completion)
            completion();
    }
    else {
        if ([self.reachability isReachable]) {
            NSLog(@"=============================== FETCHING CONFIG SYNCHRONOUSLY");
            [PFConfig getConfig];
            if (completion)
                completion();
        }
        else {
            [self showNetworkError];
        }
    }
}

- (void)showNetworkError {
    NSString *title = @"No network detected";
    NSString *message = @"Which is Bigger needs a network connection in order to load";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                         message:message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
        NSString *cancelButtonTitle = @"Okay";
    [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *viewController = keyWindow.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)getCategoriesWithCompletion:(void (^)())completion
{
    PFQuery *query =  [PFQuery queryWithClassName:@"QuestionType"];
    [query whereKey:@"name" containedIn:[[PFConfig currentConfig] objectForKey:@"questionTypeWhiteList"]];
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *latestVersion = [[PFConfig currentConfig] objectForKey:@"latestVersion"];
    if ([latestVersion isEqualToString:version]) {
        [query orderByAscending:@"safePointsToUnlock"];
    } else {
        [query orderByAscending:@"pointsToUnlock"];
    }
    
    BOOL localQuery = NO;
    if ([WIBGamePlayManager sharedInstance].categoriesInLocalStorage) {
        [query fromLocalDatastore];
        localQuery = YES;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         [WIBGamePlayManager sharedInstance].questionTypes = [objects copy];
         [self prefetchImagesForObjects:objects];
         if (completion) completion();
         if (![WIBGamePlayManager sharedInstance].categoriesInLocalStorage) {
             [PFObject pinAllInBackground:objects withName: @"categories" block:^(BOOL succeeded, NSError * _Nullable error) {
                 if (succeeded){
                     [[WIBGamePlayManager sharedInstance] setCategoriesInLocalStorage: YES];
                 }
                 else if (error){
                     NSLog(error.userInfo);
                 }
             }];
             if(localQuery) {
                 [self refreshCategoriesInBackground];
             }
         }
     }];
}

- (void)refreshCategoriesInBackground {
    PFQuery *query =  [PFQuery queryWithClassName:@"QuestionType"];
    [query whereKey:@"name" containedIn:[[PFConfig currentConfig] objectForKey:@"questionTypeWhiteList"]];
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *latestVersion = [[PFConfig currentConfig] objectForKey:@"latestVersion"];
    if ([latestVersion isEqualToString:version]) {
        [query orderByAscending:@"safePointsToUnlock"];
    } else {
        [query orderByAscending:@"pointsToUnlock"];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         [WIBGamePlayManager sharedInstance].questionTypes = [objects copy];
         [self prefetchImagesForObjects:objects];
         [PFObject unpinAllObjectsInBackgroundWithName: @"categories" block:^(BOOL succeeded, NSError * _Nullable error) {
             if (succeeded) {
                 [PFObject pinAllInBackground:objects withName: @"categories" block:^(BOOL succeeded, NSError * _Nullable error) {
                     if (succeeded){
                         NSLog(@"===================== Successfully refreshed categories");
                     }
                     else if (error){
                         NSLog(error.userInfo);
                     }
                 }];
             }
         }];
     }];
}

- (void)prefetchImagesForObjects:(NSArray *)array
{
    NSMutableArray *urls = [NSMutableArray array];
    for (WIBQuestionType *type in array) {
        [urls addObject:[NSURL URLWithString:type.imageURL]];
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

- (void)generateDataModelWithCompletion:(void (^)())completion
{
    PFQuery *query =  [PFQuery queryWithClassName:@"GameItem"];
    query.limit = GAME_ITEM_FETCH_LIMIT;
    
    BOOL localQuery = NO;
    
    if ([WIBGamePlayManager sharedInstance].gameItemsInLocalStorage)
    {
        NSLog(@"=============================== GENERATING DATA MODEL LOCALLY");
        [query fromLocalDatastore];
        localQuery = YES;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            NSLog(@"Successfully retrieved %lu GameItems.", (unsigned long)objects.count);
            [self insertObjects: objects intoDataModel:[WIBDataModel sharedInstance]];
            completion();
            
            if (![WIBGamePlayManager sharedInstance].gameItemsInLocalStorage) {
                [PFObject pinAllInBackground:objects withName: @"gameItems" block:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [[WIBGamePlayManager sharedInstance] setGameItemsInLocalStorage: YES];
                    }
                    else if (error){
                        NSLog(error.userInfo);
                    }
                }];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            // If you get code 100, then use the local storage
        }
        if (localQuery) {
            @synchronized([WIBDataModel sharedInstance]) {
                [self refreshGameItemsInBackground];
            }
        }
    }];
}

- (void)refreshGameItemsInBackground {
    PFQuery *query =  [PFQuery queryWithClassName:@"GameItem"];
    query.limit = GAME_ITEM_FETCH_LIMIT;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error) {
             NSLog(@"======== Successfully retrieved %lu REFRESHED GameItems .", (unsigned long)objects.count);
             [[WIBDataModel sharedInstance] invalidateDataModel];
             [self insertObjects:objects intoDataModel:[WIBDataModel sharedInstance]];
             
             [PFObject unpinAllObjectsInBackgroundWithName: @"gameItems" block:^(BOOL succeeded, NSError * _Nullable error) {
                 if (succeeded) {
                     [PFObject pinAllInBackground:objects withName: @"gameItems" block:^(BOOL succeeded, NSError * _Nullable error) {
                         if (succeeded){
                             NSLog(@"===================== Successfully refreshed gameItems");
                         }
                         else if (error){
                             NSLog(error.userInfo);
                         }
                     }];
                 }
             }];
         }
         else {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             // If you get code 100, then use the local storage
         }
     }];
}

- (void)insertObjects:(NSArray *) objects intoDataModel: (WIBDataModel *)dataModel
{
    for (PFObject *object in objects)
    {
        WIBGameItem *gameItem = [[WIBGameItem alloc] init];
        gameItem.name = object[@"name"];
        gameItem.baseQuantity = object[@"quantity"];
        gameItem.unit = object[@"unit"];
        gameItem.categoryString = object[@"category"];
        gameItem.tagArray = object[@"tagArray"];
        gameItem.photoURL = object[@"photoURL"];
        gameItem.objectId = object.objectId;
        if(gameItem.name && gameItem.baseQuantity)
        {
            [dataModel insertGameItem: gameItem];
        }
    }
}

- (void)preloadImages:(NSMutableArray *)gameQuestions
{
    _groupDownloadComplete = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_group_t downloadGroup = dispatch_group_create();
        
        for (WIBGameQuestion *question in gameQuestions)
        {
            NSString *urlString1 = question.option1.item.photoURL;
            NSString *urlString2 = question.option2.item.photoURL;
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            if(urlString1 != nil && ![urlString1 isKindOfClass:[NSNull class]]) {
                dispatch_group_enter(downloadGroup);
                [manager loadImageWithURL:[NSURL URLWithString:urlString1]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
                                         // progression tracking code
                                     }
                                    completed: ^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            // do something with image
                                            NSLog(@"Photo 1");
                                        }
                                        else {
                                            NSLog(@"Photo 1 done goofed: %@", error.description);
                                        }
                                        dispatch_group_leave(downloadGroup);
                                    }];
            }
                        
            if(urlString2 != nil && ![urlString2 isKindOfClass:[NSNull class]]) {
                dispatch_group_enter(downloadGroup);
                [manager loadImageWithURL:[NSURL URLWithString:urlString2]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            // do something with image
                                            NSLog(@"Photo 2");
                                        }
                                        else {
                                            NSLog(@"Photo 2 done goofed: %@", error.description);
                                        }
                                        dispatch_group_leave(downloadGroup);
                                    }];
            }
        }
        
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Finished downloading images! Let everyone know...");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGroupImageDownloadCompleteNotification object:nil];
            self.groupDownloadComplete = YES;
        });
    });
}

@end
