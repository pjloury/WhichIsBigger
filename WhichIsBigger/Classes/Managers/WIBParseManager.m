//
//  WIBParseManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBParseManager.h"

#import <Parse/Parse.h>

// Constants
#import "WIBConstants.h"

// Data Model
#import "WIBDataModel.h"

@implementation WIBParseManager

+ (WIBParseManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBParseManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBParseManager alloc] init];
        
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
                gameItem.photoURL = object[@"photoURL"];
                gameItem.baseQuantity = object[@"quantity"];
                gameItem.categoryString = object[@"category"];
                gameItem.tags = object[@"tags"];
                gameItem.tagsArray = object[@"tagsArray"];
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
@end
