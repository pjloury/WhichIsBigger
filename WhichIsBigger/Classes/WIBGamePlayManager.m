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

#import "WIBConstants.h"

@interface WIBGamePlayManager()

@property (nonatomic, strong) NSMutableArray *gameQuestions;
@property (nonatomic) NSInteger difficulty;

@end


@implementation WIBGamePlayManager

double difficulty = 10; // 0 to 100

+ (WIBGamePlayManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBGamePlayManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBGamePlayManager alloc] init];

    });
    return shared;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.gameQuestions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)generateQuestions
{
    for(int i = 0; i < kNumberOfQuestions; i++)
    {
        // Pick a random category
        WIBCategoryType randomCategory = arc4random_uniform(WIBCategoryTypeCount);
        
//        WIBGameItem *item1 = [[WIBDataModel sharedInstance ]gameItemForCategoryType:randomCategory];
//        WIBGameItem *item2 = [[WIBDataModel sharedInstance  ]gameItemForCategoryType:randomCategory];
        WIBGameItem *item1 = [[WIBDataModel sharedInstance] gameItemForCategoryType:WIBCategoryTypeHeight];
        WIBGameItem *item2 = [[WIBDataModel sharedInstance] gameItemForCategoryType:WIBCategoryTypeHeight];
        
        WIBGameQuestion *gameQuestion = [[WIBGameQuestion alloc]initWithGameItem:item1 gameItem2:item2]; //pass mult 1 mult2
        
        WIBGameItem *largerItem = [WIBGameItem maxOfItem:item1 item2:item2];
        WIBGameItem *smallerItem = [WIBGameItem minOfItem:item1 item2:item2];
        
        // it actually takes 230.3 Kanyes...
        double answerQuantity = largerItem.quantity.doubleValue / largerItem.quantity.doubleValue;
        
        // random # between 0 and N-1
        NSUInteger r = arc4random_uniform(2) * 2 -1;
        
        double skew = r * answerQuantity / difficulty;
        double calculatedMultiplier =  answerQuantity + skew;

        if(smallerItem == item1)
        {
            gameQuestion.multiplier1 = ceil(calculatedMultiplier);
            gameQuestion.multiplier2 = 1;
        }
        else
        {
            gameQuestion.multiplier2 = ceil(calculatedMultiplier);
            gameQuestion.multiplier1 = 1;
        }
        
        [self.gameQuestions addObject:gameQuestion];
        
    }
}

- (WIBGameQuestion *)nextGameQuestion
{
    WIBGameQuestion *question = [self.gameQuestions firstObject];
    [self.gameQuestions removeObjectAtIndex:0];
    NSLog(@"Only %lu more questions left!", (unsigned long)self.gameQuestions.count);
    return question;
}

@end
