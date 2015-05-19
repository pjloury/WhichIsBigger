//
//  WIBDataModel.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBDataModel.h"
#import "WIBConstants.h"

// GamePlayManager keeps track of used names
#import "WIBGamePlayManager.h"

@interface WIBDataModel()
@property (nonatomic, strong) NSMutableDictionary *gameItemsDictionary;
@end

@implementation WIBDataModel

+ (WIBDataModel *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBDataModel *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBDataModel alloc] init];
        shared.gameItemsDictionary = [NSMutableDictionary dictionary];
    });
    
    return shared;
}

- (void)insertGameItem:(WIBGameItem *)gameItem
{
    NSMutableArray* categoryArray = [self.gameItemsDictionary objectForKey:@(gameItem.categoryType)];
    if(!categoryArray)
    {
        categoryArray = [NSMutableArray array];
        [self.gameItemsDictionary setObject:categoryArray forKey:@(gameItem.categoryType)];
    }
    [categoryArray addObject:gameItem];  
}

- (BOOL)unusedItemsAvailableForCategory:(WIBCategoryType)categoryType
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    for( WIBGameItem *gameItem in gameItemsWithSameCategory)
    {
        if(!gameItem.alreadyUsed)
            return YES;
        else
        {
            NSLog(@"Already used!");
        }
    }
    return NO;
}

- (BOOL)itemNameAlreadyUsed:(NSString *)name
{
    return [[WIBGamePlayManager sharedInstance].usedNames containsObject:name];
}

- (WIBGameItem*) gameItemForCategoryType:(WIBCategoryType)categoryType
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(!gameItem.alreadyUsed && ![self itemNameAlreadyUsed:gameItem.name])
    {
        //NSLog(@"not used yet");
        gameItem.alreadyUsed = YES;
        [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        for(WIBGameItem *item in gameItemsWithSameCategory)
        {
            if (!item.alreadyUsed)
            {
                item.alreadyUsed = YES;
                return item;
            }
        }
    }
    return nil;
}



@end
