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
#import "WIBGameQuestion.h"
#import "WIBGameOption.h"
#import "WIBGameItem.h"

#import "WIBConstants.h"

@interface WIBGamePlayManager()

@property (nonatomic, strong) NSMutableArray *gameQuestions;
@property (nonatomic) NSInteger difficulty;
@property NSInteger questionIndex;

@end

@implementation WIBGamePlayManager

double difficulty = 80; // 1 to 100

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
        self.gameComplete = NO;
    }
    return self;
}

- (void)generateQuestions
{
    for(int i = 0; i < NUMBER_OF_QUESTIONS; i++)
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
        double answerQuantity = largerItem.baseQuantity.doubleValue / smallerItem.baseQuantity.doubleValue;
        gameQuestion.answerQuantity = largerItem.baseQuantity.doubleValue / smallerItem.baseQuantity.doubleValue;
        
        // random # between 0 and 1
        double val = ((double)arc4random() / ARC4RANDOM_MAX);
        // random # between -1 and 1
        double r = val * 2 -1;
        // random # normalized to correct answer, adjusted with difficulty (low number means easier)
        double skew = r * answerQuantity / difficulty;
        
        // multiplier that will be associated with smaller item
        int multiplier = (int)ceil(answerQuantity + skew);

        if(smallerItem == item1)
        {
            gameQuestion.option1.multiplier = multiplier;
            gameQuestion.option2.multiplier = 1;
        }
        else
        {
            gameQuestion.option1.multiplier = 1;
            gameQuestion.option2.multiplier = multiplier;
        }
        
        [self.gameQuestions addObject:gameQuestion];
    }
}

- (BOOL)questionIndexIsInBounds
{
    if(self.questionIndex <= NUMBER_OF_QUESTIONS-1)
        return YES;
    else
        return NO;
}

- (WIBGameQuestion *)nextGameQuestion
{
    NSLog(@"QUESTION %ld",self.questionIndex+1);
    WIBGameQuestion *question = [self.gameQuestions objectAtIndex:self.questionIndex];
    if(self.questionIndex == NUMBER_OF_QUESTIONS-1) //When you hit 9
    {
        [self completeGame];
    }
    else
    {
        self.questionIndex++;
    }
    return question;
}

// Who should determine that the game is over???
- (void)completeGame
{
    for (WIBGameQuestion *question in self.gameQuestions)
    {
        question.option1.item.alreadyUsed = NO;
        question.option2.item.alreadyUsed = NO;
    }
    self.questionIndex = 0;
    self.gameComplete = YES;
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
