//
//  WIBParseManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBParseManager.h"
#import "WIBDataModel.h"
#import <Parse/Parse.h>

const NSUInteger kQueryCategoryLimit = 10;

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

- (void)generateDataModel
{
    // TODO: Expand
    for (NSUInteger i = WIBCategoryTypeHeight; i <= WIBCategoryTypeHeight; i++)
        [self fetchGameItemForCategoryType:i];
}

- (void)fetchGameItemForCategoryType:(WIBCategoryType)type
{
    PFQuery *query =  [PFQuery queryWithClassName:@"GameItem"];
    [query whereKey:@"category" equalTo:[WIBGameItem categoryValueForCategoryType:type]];
    query.limit = kQueryCategoryLimit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu GameItems.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                WIBGameItem *gameItem = [[WIBGameItem alloc] init];
                gameItem.name = object[@"name"];
                gameItem.photoURL = object[@"photoURL"];
                gameItem.quantity = object[@"quantity"];
                gameItem.categoryString = object[@"category"];
                gameItem.categoryType = type;
                [[WIBDataModel sharedInstance] insertGameItem: gameItem];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)insertGameItems
{
    
}

@end
