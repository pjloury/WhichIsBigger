//
//  WIBDataModel.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBDataModel.h"
#import "WIBConstants.h"

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

- (WIBGameItem*) gameItemForCategoryType2:(WIBCategoryType)categoryType
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    NSLog(@"%ld",gameItemsWithSameCategory.count);
    NSAssert(gameItemsWithSameCategory.count > NUMBER_OF_QUESTIONS*2, @"NOT ENOUGH GAME ITEMS FROM SERVER");
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    //NSLog(gameItem.name);
    if(!gameItem.alreadyUsed)
    {
        //NSLog(@"not used yet");
        gameItem.alreadyUsed = YES;
        return gameItem;
    }
    else
    {
        //NSLog(@"already used");
        NSAssert([self unusedItemsAvailableForCategory:categoryType],@"DUDE YOU RAN OUT OF GAME ITEMS!!");
       gameItem =  [self gameItemForCategoryType:categoryType];
    }
    
     //TODO: Implement repeat prevention
//    if (!gameItem.usedAlready)
//    {
//        gameItem.usedAlready = YES;
//        return gameItem;
//    }
//    else //TODO: Potential for Infinite Loop!
//    {
//        [self gameItemForCategoryType:categoryType];
//    }
    
    //return nil;
    // TODO: Add the Item back in at the end of the game
    return gameItem;
}

- (WIBGameItem*) gameItemForCategoryType:(WIBCategoryType)categoryType
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(!gameItem.alreadyUsed)
    {
        //NSLog(@"not used yet");
        gameItem.alreadyUsed = YES;
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
