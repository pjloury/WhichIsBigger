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

// Managers
#import "WIBNetworkManager.h"

@interface WIBGamePlayManager()
@property (nonatomic, strong) NSMutableArray *gameQuestions;
@property (nonatomic, assign) NSInteger questionIndex;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger currentStreak;
@property (nonatomic, assign) NSInteger longestStreak;

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

# pragma mark - Game State

- (void)beginGame
{
    self.questionIndex = 0;
    self.difficulty = 100;
    self.gameQuestions = nil;
    self.usedNames = nil;
    [self generateQuestions];
}

- (WIBGameQuestion *)nextGameQuestion
{
    NSLog(@"QUESTION %ld",self.questionIndex+1);
    WIBGameQuestion *question = [self.gameQuestions objectAtIndex:self.questionIndex];
    self.questionIndex++;
    return question;
}

- (void)printQuestions
{
    for(WIBGameQuestion *question in self.gameQuestions)
    {
        NSString *string = [NSString stringWithFormat:@"%@ vs. %@", question.option1.item.name, question.option2.item.name];
        NSLog(@"%@",string);
    }
}

# pragma mark - Accessors
- (NSInteger)score
{
    _score = 0;
    for (WIBGameQuestion *question in self.gameQuestions)
    {
        if (question.answeredCorrectly)
        {
            _score += round(POINTS_PER_QUESTION - (POINTS_PER_QUESTION * question.answerTime / SECONDS_PER_QUESTION));
        }
    }
    
    if (_score > self.highScore)
    {
        self.highScore = _score;
    }
    
    return _score;
}

- (void)setHighScore:(NSInteger)highScore
{
    [[NSUserDefaults standardUserDefaults] setObject:@(highScore) forKey:@"highScore"];
}

- (NSInteger)highScore
{
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"]).integerValue;
}

- (void)setCurrentStreak:(NSInteger)currentStreak
{
    [[NSUserDefaults standardUserDefaults] setObject:@(currentStreak) forKey:@"currentStreak"];
}

- (NSInteger)currentStreak
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentStreak"];
    return (num) ? num.integerValue: 0;
}

- (void)setLongestStreak:(NSInteger)longestStreak
{
    [[NSUserDefaults standardUserDefaults] setObject:@(longestStreak) forKey:@"longestStreak"];
}

- (NSInteger)longestStreak
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"longestStreak"];
    return (num) ? num.integerValue: 0;
}

- (void)generateQuestions
{
    self.gameQuestions = [[NSMutableArray alloc] init];
    self.usedNames = [[NSMutableSet alloc] init];
    
    for(int i = 0; i < NUMBER_OF_QUESTIONS; i++)
    {
        // TODO: accomodate different question types
        WIBCategoryType randomCategory = arc4random_uniform(WIBCategoryTypeCount);
        
        WIBGameItem *item1 = [[WIBDataModel sharedInstance] firstGameItemForCategoryType:randomCategory];
        WIBGameItem *item2 = [[WIBDataModel sharedInstance] secondGameItemForCategoryType:randomCategory withRespectToItem:item1 withDifficulty:[WIBGamePlayManager sharedInstance].difficulty];
        // Encapsulate game item cache into the method call!
                              
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
		
        [self.gameQuestions addObject:gameQuestion];
    }
    [self printQuestions];
    [[WIBNetworkManager sharedInstance] preloadImages:self.gameQuestions];
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

# pragma mark - WIBScoringDelegate

- (void)didAnswerQuestionCorrectly
{
    self.currentStreak++;
    if(self.currentStreak > self.longestStreak)
    {
        self.longestStreak = self.currentStreak;
    }
}

- (void)didAnswerQuestionIncorrectly
{
    self.currentStreak = 0;
}

@end
