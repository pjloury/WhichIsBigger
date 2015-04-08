//
//  WIBGamePlayManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGamePlayManager.h"
#import "WIBDataModel.h"
#import "WIBGameItem.h"

@interface WIBGamePlayManager()

@property (nonatomic, strong) NSMutableArray *gameQuestions;

@end

@implementation WIBGamePlayManager

+ (WIBGamePlayManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBGamePlayManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBGamePlayManager alloc] init];
    });
    return shared;
}

- (WIBGameQuestion *)gameQuestion
{
    // Choose Random Category Type (random number 0 thru
    WIBCategoryType type = arc4random_uniform(WIBCategoryTypeCount);
    
    // Retrieve all of that type
//    WIBGameItem *item1 = [[WIBDataModel sharedInstance ]gameItemForCategoryType:type];
//    WIBGameItem *item2 = [[WIBDataModel sharedInstance  ]gameItemForCategoryType:type];
    WIBGameItem *item1 = [[WIBDataModel sharedInstance ]gameItemForCategoryType:WIBCategoryTypeHeight];
    WIBGameItem *item2 = [[WIBDataModel sharedInstance  ]gameItemForCategoryType:WIBCategoryTypeHeight];
    
    WIBGameQuestion *gameQuestion = [[WIBGameQuestion alloc]initWithGameItem:item1 gameItem2:item2];
    return gameQuestion;
}



@end
