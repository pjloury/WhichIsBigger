//
//  WIBParseManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBParseManager.h"
#import "WIBGameItem.h"
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

- (void)fetchGameItemForCategoryType(WIBCategoryType)
{
    //Ask for 10 items of this type
    
    WIBGameItem *gameItem = [[WIBGameItem alloc] initWithJSON:json];
    [[WIBDataModel sharedInstance] insertGameItem: gameItem];
    
}

- (void)insertGameItems
{
    
}

@end
