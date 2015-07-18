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
#import "WIBDataModel.h"

@implementation WIBNetworkManager

+ (WIBNetworkManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBNetworkManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBNetworkManager alloc] init];
    });
    
    return shared;
}

- (void)generateDataModelWithCompletion:(void (^)())completion
{
    PFQuery *query =  [PFQuery queryWithClassName:@"GameItem"];
    query.limit = GAME_ITEM_FETCH_LIMIT;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu GameItems.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects)
            {
                //NSLog(@"%@", object.objectId);
                WIBGameItem *gameItem = [[WIBGameItem alloc] init];
                gameItem.name = object[@"name"];
                gameItem.baseQuantity = object[@"quantity"];
                gameItem.unit = object[@"unit"];
                gameItem.categoryString = object[@"category"];
                gameItem.tagArray = object[@"tagArray"];
                gameItem.photoURL = object[@"photoURL"];
                [[WIBDataModel sharedInstance] insertGameItem: gameItem];
            }
            completion();
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)preloadImages:(NSMutableArray *)gameQuestions
{
    for (WIBGameQuestion *question in gameQuestions)
    {
        NSString *urlString1 = question.option1.item.photoURL;
        NSString *urlString2 = question.option2.item.photoURL;
        [[AsyncImageLoader sharedLoader] loadImageWithURL:[NSURL URLWithString:urlString1]];
        [[AsyncImageLoader sharedLoader] loadImageWithURL:[NSURL URLWithString:urlString2]];
    }
}

@end
