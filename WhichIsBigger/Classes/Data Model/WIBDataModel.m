//
//  WIBDataModel.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBDataModel.h"

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

- (WIBGameItem*) gameItemForCategoryType:(WIBCategoryType)categoryType
{
    // TODO: Remove RETURNS FIRST OBJECT ALWAYS
    NSMutableArray* gameItemsWithSameCategory= [self.gameItemsDictionary objectForKey:@(categoryType)];
    
    //THere might be no dictionary
    
    WIBGameItem* gameItem = [gameItemsWithSameCategory firstObject];
    // Avoid repeats of the same item
    // [gameItemsWithSameCategory removeObject:gameItem];
    return gameItem;
}

@end
