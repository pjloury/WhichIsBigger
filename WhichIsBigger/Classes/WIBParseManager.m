//
//  WIBParseManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBParseManager.h"
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

- (void)fetchGameItemForCategoryType:(WIBCategoryType)type
{
    //Ask for 10 items of this type
    WIBGameItem *gameItem = [[WIBGameItem alloc] init];
    gameItem.name = @"Empire";
    gameItem.photoURL =@"http://nba.com";
    gameItem.quantity = @(42);
    gameItem.categoryType = WIBCategoryTypeHeight;
    [[WIBDataModel sharedInstance] insertGameItem: gameItem];
}

- (void)insertGameItems
{
    
}

@end
