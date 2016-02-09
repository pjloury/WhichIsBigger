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
    if ([self.reachability isReachable])
    {
        [PFConfig getConfig];
    }
    // TODO: Use promises here
    if (completion)
        completion();
}

- (void)getCategoriesWithCompletion:(void (^)())completion
{
    PFQuery *query =  [PFQuery queryWithClassName:@"QuestionType"];
    [query whereKey:@"name" containedIn:[[PFConfig currentConfig] objectForKey:@"questionTypeWhiteList"]];
    
    if ([WIBGamePlayManager sharedInstance].localStorage && ![self.reachability isReachable])[query fromLocalDatastore];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [WIBGamePlayManager sharedInstance].questionTypes = [objects copy];
         if (completion) completion();
         [PFObject pinAllInBackground:objects];
     }];
}

- (void)generateDataModelWithCompletion:(void (^)())completion
{
    PFQuery *query =  [PFQuery queryWithClassName:@"GameItem"];
    query.limit = GAME_ITEM_FETCH_LIMIT;
    
    if ([WIBGamePlayManager sharedInstance].localStorage && ![self.reachability isReachable])
    {
        [query fromLocalDatastore];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            [WIBGamePlayManager sharedInstance].localStorage = YES;
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu GameItems.", (unsigned long)objects.count);
            // Do something with the found objects
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
                    [[WIBDataModel sharedInstance] insertGameItem: gameItem];
                }
            }
            completion();
            [PFObject pinAllInBackground:objects];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            // If you get code 100, then use the local storage
        }
    }];
}

- (void)preloadImages:(NSMutableArray *)gameQuestions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_group_t downloadGroup = dispatch_group_create();
        
        for (WIBGameQuestion *question in gameQuestions)
        {
            NSString *urlString1 = question.option1.item.photoURL;
            NSString *urlString2 = question.option2.item.photoURL;
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            if([urlString1 length] >0) {
                dispatch_group_enter(downloadGroup);
                [manager downloadImageWithURL:[NSURL URLWithString:urlString1]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
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
            
            if([urlString2 length] >0) {
                dispatch_group_enter(downloadGroup);
                [manager downloadImageWithURL:[NSURL URLWithString:urlString2]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kGroupImageDownloadCompleteNotification object:nil];
        });
    });
}

@end
