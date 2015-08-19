//
//  WIBDataModel.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBDataModel.h"

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
        if(![self itemNameAlreadyUsed:gameItem.name])
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

- (WIBGameItem*)gameItemForCategoryType:(WIBCategoryType)categoryType withUniqueBaseQuantity:(NSNumber *)baseQuantity withDifficulty:(NSNumber *)difficulty
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [baseQuantity doubleValue])
    {
		[[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        return [self gameItemForCategoryType:categoryType withUniqueBaseQuantity:baseQuantity];
    }
    return nil;
}






- (WIBGameItem*)firstGameItemForCategoryType:(WIBCategoryType)categoryType
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(![self itemNameAlreadyUsed:gameItem.name])
    {
        [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        return [self firstGameItemForCategoryType:categoryType];
    }
}

- (WIBGameItem*)secondGameItemForCategoryType:(WIBCategoryType)categoryType withRespectToItem:(WIBGameItem *)item withDifficulty:(double)difficulty
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    NSLog(@"%d",r);
    
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    BOOL regulated = arc4random_uniform(1); // 0 or 1
    
    NSLog(@"Used Names Count:%ld",[WIBGamePlayManager sharedInstance].usedNames.count);
    
    switch(categoryType)
    {
            // The database only has humans currently
        case WIBCategoryTypeAge:
        {
            double percentDifference = ABS((gameItem.baseQuantity.doubleValue - item.baseQuantity.doubleValue)/item.baseQuantity.doubleValue);
            BOOL closeEnough = (percentDifference < difficulty); //percent difficulty
            
            // if it's close enough
            if(![self itemNameAlreadyUsed:gameItem.name] &&
               [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] )
            {
                [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
                return gameItem;
            }
            else
            {
                // tried
                return [self secondGameItemForCategoryType:categoryType withRespectToItem:item withDifficulty:difficulty];
            }
        }
        case WIBCategoryTypeWeight:
        {
            if(![self itemNameAlreadyUsed:gameItem.name] &&
               [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] )
            {
                [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
                return gameItem;
            }
            else
            {
                return [self secondGameItemForCategoryType:categoryType withRespectToItem:item withDifficulty:difficulty];
            }
        }
        case WIBCategoryTypeHeight:
        {
            if(![self itemNameAlreadyUsed:gameItem.name] &&
               [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] &&
               item.isPerson != gameItem.isPerson)
            {
                [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
                return gameItem;
            }
            else
            {
                return [self secondGameItemForCategoryType:categoryType withRespectToItem:item withDifficulty:difficulty];
            }
        }
        default:
            return nil;
    }
}





@end
