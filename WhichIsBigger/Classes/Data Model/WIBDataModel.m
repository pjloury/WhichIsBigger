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

- (BOOL)itemNameAlreadyUsed:(NSString *)name
{
    return [[WIBGamePlayManager sharedInstance].usedNames containsObject:name];
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

- (WIBGameItem*)secondGameItemForCategoryType:(WIBCategoryType)categoryType dissimilarTo:(WIBGameItem *)item orderOfMagnitude:(double)magnitude
{
    NSAssert(magnitude>1,@"Magnitude is too small");
    
    // Start with Large Magnitude difference, then progressively smaller
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    // Example, 300 ft item, 10 ft gameItem
    double scaling = item.baseQuantity.doubleValue/gameItem.baseQuantity.doubleValue;
    // scaling.. 30x bigger
    
    NSAssert((item.baseQuantity.doubleValue > 0 && gameItem.baseQuantity.doubleValue > 0), @"Base quantities must be greater than zero!");
    
    double reciprocal = 1/magnitude;
    
    BOOL differentEnough = (scaling > magnitude || scaling < reciprocal);
    
    static int tries = 0;
    
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && differentEnough)
    {
        [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForCategoryType:categoryType dissimilarTo:item orderOfMagnitude:magnitude];
        }
        else
        {
            return [self secondGameItemForCategoryType:categoryType dissimilarTo:item orderOfMagnitude:magnitude-1];
        }
    }
}

- (WIBGameItem*)secondGameItemForCategoryType:(WIBCategoryType)categoryType withRespectToItem:(WIBGameItem *)item withQuestionCeiling:(double)questionCeiling
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    int r = arc4random() % [gameItemsWithSameCategory count];

    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    double percentDifference = (fabs((gameItem.baseQuantity.doubleValue - item.baseQuantity.doubleValue)/item.baseQuantity.doubleValue)) * 100;
    BOOL closeEnough = (percentDifference < questionCeiling && percentDifference > [WIBGamePlayManager sharedInstance].questionFloor);
    
    static int tries = 0;
    
    // Cannot, be already used name, cannot be a tie, must be close enough
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && closeEnough)
    {
        [[WIBGamePlayManager sharedInstance].usedNames addObject:gameItem.name];
        NSLog(@"%@ and %@ are %.2f%% different",item.name, gameItem.name ,percentDifference);
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForCategoryType:categoryType withRespectToItem:item withQuestionCeiling:questionCeiling];
        }
        else
        {
            return [self secondGameItemForCategoryType:categoryType withRespectToItem:item withQuestionCeiling:questionCeiling+10];
        }
    }
}

@end
