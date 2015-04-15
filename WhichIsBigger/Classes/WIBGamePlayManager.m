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
@property (nonatomic) NSInteger difficulty;

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

- (void)generateQuestions
{
    for(int i = 0; i < 10; i++)
    {
        // Pick a random category
        WIBCategoryType randomCategory = arc4random_uniform(WIBCategoryTypeCount);
        
//        WIBGameItem *item1 = [[WIBDataModel sharedInstance ]gameItemForCategoryType:randomCategory];
//        WIBGameItem *item2 = [[WIBDataModel sharedInstance  ]gameItemForCategoryType:randomCategory];
        WIBGameItem *item1 = [[WIBDataModel sharedInstance] gameItemForCategoryType:WIBCategoryTypeHeight];
        WIBGameItem *item2 = [[WIBDataModel sharedInstance] gameItemForCategoryType:WIBCategoryTypeHeight];
        
        WIBGameQuestion *gameQuestion = [[WIBGameQuestion alloc]initWithGameItem:item1 gameItem2:item2]; //pass mult 1 mult2

        // Default case- only scale smaller item
        // Deal with the smaller and the larger from now on
        //multiplierSmaller = largerItem / smallerItem = # of smaller items that it would take to equal 1 largerItem
            230                    1150          5
            1
        
        -230/ 100 = -23
        //skew = random(-1 to 1)* multiplierSmaller / difficulty
        //multiplierSmaller = multiplierSmaller + skew
        253 - > 250
        //TODO: Try nice round numbers
        

        
        
        [self calculateMultipliers];
        
        //which one is larger
        
    }
}

- (void)calculateMultipliers:(WIBGameItem *)item1 item2:(WIBGameItem *)item2
{
    [

    
}


- (WIBGameQuestion *)nextGameQuestion
{
    WIBGameQuestion *question = [self.gameQuestions firstObject];
    [self.gameQuestions removeObject:0];
    return question;
}



@end
