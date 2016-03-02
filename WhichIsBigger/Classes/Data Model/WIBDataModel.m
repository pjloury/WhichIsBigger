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
    NSMutableArray* categoryArray = [self.gameItemsDictionary objectForKey:gameItem.categoryString];
    if(!categoryArray)
    {
        categoryArray = [NSMutableArray array];
        [self.gameItemsDictionary setObject:categoryArray forKey:gameItem.categoryString];
    }
    [categoryArray addObject:gameItem];  
}

- (BOOL)itemNameAlreadyUsed:(NSString *)name
{
    return [[WIBGamePlayManager sharedInstance].gameRound.usedNames containsObject:name];
}

- (WIBGameItem*)firstGameItemForQuestionType:(WIBQuestionType *)type
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(![self itemNameAlreadyUsed:gameItem.name] && [gameItem supportsQuestionType:type])
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        return [self firstGameItemForQuestionType:type];
    }
}

- (WIBGameItem*)firstNonHumanGameItemForQuestionType:(WIBQuestionType *)type
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    if(![self itemNameAlreadyUsed:gameItem.name] && [gameItem supportsQuestionType:type] && !gameItem.isPerson)
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        return [self firstGameItemForQuestionType:type];
    }
}

- (WIBGameItem*)secondGameItemForQuestionType:(WIBQuestionType *)type dissimilarTo:(WIBGameItem *)item orderOfMagnitude:(double)magnitude
{
    NSAssert(magnitude>1,@"Magnitude is too small");
    
    // Start with Large Magnitude difference, then progressively smaller
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
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
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && differentEnough && [gameItem supportsQuestionType:type])
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForQuestionType:type dissimilarTo:item orderOfMagnitude:magnitude];
        }
        else
        {
            return [self secondGameItemForQuestionType:type dissimilarTo:item orderOfMagnitude:magnitude-1];
        }
    }
}

- (WIBGameItem*)secondGameItemForQuestionType:(WIBQuestionType *)type withRespectToItem:(WIBGameItem *)item withQuestionCeiling:(double)questionCeiling
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];

    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    NSLog(@"%@ vs %@", gameItem.name,item.name);
    double percentDifference = (fabs((gameItem.baseQuantity.doubleValue - item.baseQuantity.doubleValue)/fmin(item.baseQuantity.doubleValue,gameItem.baseQuantity.doubleValue))) * 100;
    BOOL closeEnough = (percentDifference < questionCeiling && percentDifference > [WIBGamePlayManager sharedInstance].questionFloor);
    
    static int tries = 0;
    
    // Cannot, be already used name, cannot be a tie, must be close enough
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && closeEnough && [gameItem supportsQuestionType:type])
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        NSLog(@"%@ and %@ are %.2f%% different",item.name, gameItem.name ,percentDifference);
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling];
        }
        else
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling+10];
        }
    }
}

- (WIBGameItem*)secondNonHumanGameItemForQuestionType:(WIBQuestionType *)type withRespectToItem:(WIBGameItem *)item withQuestionCeiling:(double)questionCeiling
{
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:type.category];
    
    int r = arc4random() % [gameItemsWithSameCategory count];
    
    WIBGameItem* gameItem = [gameItemsWithSameCategory objectAtIndex:r];
    
    NSLog(@"%@ vs %@", gameItem.name,item.name);
    double percentDifference = (fabs((gameItem.baseQuantity.doubleValue - item.baseQuantity.doubleValue)/fmin(item.baseQuantity.doubleValue,gameItem.baseQuantity.doubleValue))) * 100;
    BOOL closeEnough = (percentDifference < questionCeiling && percentDifference > [WIBGamePlayManager sharedInstance].questionFloor);
    
    static int tries = 0;
    
    // Cannot, be already used name, cannot be a tie, must be close enough
    if(![self itemNameAlreadyUsed:gameItem.name] &&
       [gameItem.baseQuantity doubleValue] != [item.baseQuantity doubleValue] && closeEnough && [gameItem supportsQuestionType:type] && !gameItem.isPerson)
    {
        [[WIBGamePlayManager sharedInstance].gameRound.usedNames addObject:gameItem.name];
        NSLog(@"%@ and %@ are %.2f%% different",item.name, gameItem.name ,percentDifference);
        return gameItem;
    }
    else
    {
        tries++;
        if (tries < [gameItemsWithSameCategory count])
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling];
        }
        else
        {
            return [self secondGameItemForQuestionType:type withRespectToItem:item withQuestionCeiling:questionCeiling+10];
        }
    }
}

@end
