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
#import "WIBDissimilarHeightQuestion.h"

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
        
        if ([[PFUser currentUser] objectForKey:@"skewFactor"])
        {
            NSNumber *skewFactor = [[PFUser currentUser] objectForKey:@"skewFactor"];
            shared.skewFactor = skewFactor.doubleValue;
        }
        else
        {
            shared.skewFactor = 0.75;
        }
        
        shared.questionCeiling = 40;
        shared.questionFloor = 10;

    });
    return shared;
}

# pragma mark - Game State

- (void)beginGame
{
    self.questionIndex = 0;

    self.gameQuestions = nil;
    self.usedNames = nil;
    [self generateQuestions];
}

- (void)endGame
{
    if (self.numberCorrectAnswers > 4 && self.questionCeiling - 5 > self.questionFloor)
    {
        self.questionCeiling -= 5;
        if (self.questionFloor > 5)
        {
            self.questionFloor -=5;
        }
        else if (self.questionFloor > 1)
        {
            self.questionFloor --;
        }
        
        if (self.skewFactor > 0.1)
        {
            self.skewFactor -= 0.1;
        }
    }
    else if ( self.accuracy <= 0.55)
    {
        self.questionCeiling += 5;
        if (self.questionFloor < (self.questionCeiling - 5) )
        {
            self.questionFloor +=5;
        }
        
        self.skewFactor += 0.1;
    }
}

- (void)setupGamePlay
{
    self.highScore = [[PFUser currentUser] objectForKey:@"highScore"];
    self.longestStreak = [[PFUser currentUser] objectForKey:@"longestStreak"];
}

- (WIBGameQuestion *)nextGameQuestion
{
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
    [[PFUser currentUser] setObject:@(highScore) forKey:@"highScore"];
    [[PFUser currentUser] saveInBackground];
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
    [[PFUser currentUser] setObject:@(longestStreak) forKey:@"longestStreak"];
    [[PFUser currentUser] saveInBackground];
}

- (NSInteger)longestStreak
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"longestStreak"];
    return (num) ? num.integerValue: 0;
}

- (NSUInteger)totalCorrectAnswers
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalCorrectAnswers"];
    return (num) ? num.integerValue: 0;
}

- (void)setTotalCorrectAnswers:(NSUInteger)totalCorrectAnswers
{
    [[NSUserDefaults standardUserDefaults] setObject:@(totalCorrectAnswers) forKey:@"totalCorrectAnswers"];
}

- (NSUInteger)totalAnswers
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalAnswers"];
    return (num) ? num.integerValue: 0;
}

- (void)setTotalAnswers:(NSUInteger)totalAnswers
{
    [[NSUserDefaults standardUserDefaults] setObject:@(totalAnswers) forKey:@"totalAnswers"];
}

- (BOOL)localStorage
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"localStorage"];
    return (num) ? num.integerValue: 0;
}

- (void)setLocalStorage:(BOOL)localStorage
{
    [[NSUserDefaults standardUserDefaults] setObject:@(localStorage) forKey:@"localStorage"];
}

- (float)accuracy
{
    return (float)self.totalCorrectAnswers / (float)self.totalAnswers;
}

- (void)generateQuestions
{
    self.gameQuestions = [[NSMutableArray alloc] init];
    self.usedNames = [[NSMutableSet alloc] init];
    
    for(int i = 0; i < NUMBER_OF_QUESTIONS; i++)
    {
        // TODO: Server driven # of categories .. (future looking)
        //WIBCategoryType randomCategory = arc4random_uniform(WIBCategoryTypeCount-1);
        WIBCategoryType randomCategory = WIBCategoryTypeDissimilarHeight;
        
        WIBGameQuestion *question;
        
        switch (randomCategory)
        {
            case (WIBCategoryTypeDissimilarHeight):
            {
                question = [[WIBDissimilarHeightQuestion alloc] init];
                break;
            }
            default:
            {
                question = [[WIBGameQuestion alloc] initOneToOneQuestion:randomCategory];
                break;
            }
        }
        [self.gameQuestions addObject:question];
        
    }
    //[self printQuestions];
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
    self.totalCorrectAnswers++;
    self.totalAnswers++;
}

- (void)didAnswerQuestionIncorrectly
{
    self.currentStreak = 0;
    self.totalAnswers++;
}

- (void)didFailToAnswerQuestion
{
    self.currentStreak = 0;
    self.totalAnswers++;
}

@end
