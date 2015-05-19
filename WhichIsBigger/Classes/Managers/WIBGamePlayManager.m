//
//  WIBGamePlayManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGamePlayManager.h"
#import "WIBDataModel.h"

// Models
#import "WIBHumanComparisonQuestion.h"
#import "WIBGameQuestion.h"
#import "WIBGameOption.h"
#import "WIBGameItem.h"
#import "WIBConstants.h"

@interface WIBGamePlayManager()
@property (nonatomic, strong) NSMutableArray *gameQuestions;
@property NSInteger questionIndex;
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

- (id)init
{
    return [super init];
}

- (void)beginGame
{
    self.questionIndex = 0;
    self.difficulty = 100;
    self.gameQuestions = nil;
    self.usedNames = nil;
    [self generateQuestions];
}

- (void)completeGame
{
    for (WIBGameQuestion *question in self.gameQuestions)
    {
        question.option1.item.alreadyUsed = NO;
        question.option2.item.alreadyUsed = NO;
    }
}

- (void)generateQuestions
{
    self.gameQuestions = [[NSMutableArray alloc] init];
    self.usedNames = [[NSMutableSet alloc] init];
    
    for(int i = 0; i < NUMBER_OF_QUESTIONS; i++)
    {
        WIBCategoryType randomCategory = arc4random_uniform(WIBCategoryTypeCount);
        
        WIBGameItem *item1 = [[WIBDataModel sharedInstance ]gameItemForCategoryType:randomCategory];
        WIBGameItem *item2 = [[WIBDataModel sharedInstance  ]gameItemForCategoryType:randomCategory];
        
//        WIBGameItem *item1 = [[WIBDataModel sharedInstance] gameItemForCategoryType:WIBCategoryTypeHeight];
//        WIBGameItem *item2 = [[WIBDataModel sharedInstance] gameItemForCategoryType:WIBCategoryTypeHeight];
        NSAssert(![item1 isEqual:item2], @"ITEMS SHOULD NOT BE IDENTICAL");
        
        WIBGameQuestion *gameQuestion = nil;
        
        if(randomCategory == WIBCategoryTypeAge)
        {
            gameQuestion = [[WIBHumanComparisonQuestion alloc]initWithGameItem:item1 gameItem2:item2]; //pass mult 1
        }
        else
        {
            gameQuestion = [[WIBGameQuestion alloc]initWithGameItem:item1 gameItem2:item2]; //pass mult 1 mult2
        }
//        if(item1.isPerson && item2.isPerson)
//        {
//            gameQuestion = [[WIBHumanComparisonQuestion alloc]initWithGameItem:item1 gameItem2:item2]; //pass mult 1 mult2
//        }
//        else
//        {
//            gameQuestion = [[WIBGameQuestion alloc]initWithGameItem:item1 gameItem2:item2]; //pass mult 1 mult2
//        }
        
        [self.gameQuestions addObject:gameQuestion];
    }
    [self printQuestions];
}

- (void)printQuestions
{
    for(WIBGameQuestion *question in self.gameQuestions)
    {
        NSString *string = [NSString stringWithFormat:@"%@ vs. %@", question.option1.item.name, question.option2.item.name];
        NSLog(string);
    }
}

- (WIBGameQuestion *)nextGameQuestion
{
    NSLog(@"QUESTION %ld",self.questionIndex+1);
    WIBGameQuestion *question = [self.gameQuestions objectAtIndex:self.questionIndex];
    self.questionIndex++;
    return question;
}

- (NSInteger)numberCorrectAnswers
{
    NSInteger correctAnswers = 0;
    for (WIBGameQuestion *question in self.gameQuestions)
    {
        if(question.answeredCorrectly)
            correctAnswers++;
    }
    return correctAnswers;
}

@end
