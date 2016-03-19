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

#import "AppDelegate.h"

@interface WIBGamePlayManager()

@property (nonatomic) WIBGameRound *gameRound;

@property (nonatomic, assign) NSInteger currentStreak;
@property (nonatomic, assign) NSInteger longestStreak;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger lifeTimeScore;

@property (nonatomic, assign) NSInteger currentLevelPoints;

@property (nonatomic) NSString *roundUUID;

@property NSArray *previousQuestionTypes;

@end

@implementation WIBGamePlayManager


+ (WIBGamePlayManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBGamePlayManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBGamePlayManager alloc] init];
        
        if ([[PFUser currentUser] objectForKey:@"skewFactor"]) {
            NSNumber *skewFactor = [[PFUser currentUser] objectForKey:@"skewFactor"];
            shared.skewFactor = skewFactor.doubleValue;
        }
        else {
            shared.skewFactor = 0.5;
        }
        
        shared.questionCeiling = 40;
        shared.questionFloor = 10;

    });
    return shared;
}

# pragma mark - Game State

- (void)beginRound
{
    self.gameRound = [[WIBGameRound alloc] init];
    [self.gameRound generateQuestions];
}

- (void)beginRoundForType:(WIBQuestionType *)type
{
    self.gameRound = [[WIBGameRound alloc] init];
    [self.gameRound generateQuestionsForType:type];
}

- (void)endGame
{
    [self adjustDifficulty];
    self.lifeTimeScore = self.lifeTimeScore + self.score;
    for (WIBQuestionType *questionType in self.availableQuestionTypes) {
        NSArray *unlockedQuestionTypes = [[PFUser currentUser] objectForKey:@"unlockedQuestionTypes"];
        if (!unlockedQuestionTypes) {
            [self unlockedQuestionTypeSeen:self.questionTypes.firstObject];
        }
        else if (![unlockedQuestionTypes containsObject:questionType.name]) {
            self.unlockedQuestionType = questionType;
            break;
        }
    }
        
    if (self.gameRound.score > [[WIBGamePlayManager sharedInstance] highScore])
    {
        self.highScore = self.gameRound.score;
    }
}

- (WIBGameQuestion *)nextGameQuestion
{
    return [self.gameRound nextGameQuestion];
}

//- (WIBQuestionType *)unlockedQuestionType
//{
//    return [self availableQuestionTypes].firstObject;
//}

- (NSInteger)pointsPerQuestion
{
    return [[[PFConfig currentConfig] objectForKey:@"pointsPerQuestion"] integerValue];
}

- (NSInteger)pointsPerLevel
{
    return 500;//return [[[PFConfig currentConfig] objectForKey:@"pointsPerLevel"] integerValue];
}

- (NSInteger)level
{
    return (self.lifeTimeScore / self.pointsPerLevel) +1;
}

- (NSInteger)previousLevel
{
    return (self.lifeTimeScore - self.score) / self.pointsPerLevel + 1;
}

- (NSInteger)lifeTimeScore
{
    return [[[PFUser currentUser] objectForKey:@"lifeTimeScore"] integerValue];
}

- (void)setLifeTimeScore:(NSInteger)lifeTimeScore
{
    [[PFUser currentUser] setObject:@(lifeTimeScore) forKey:@"lifeTimeScore"];
    [[PFUser currentUser] saveInBackground];
    [self syncScoreWithGameKit:@"topScores" scoreValue:self.lifeTimeScore];
}

- (NSInteger)currentLevelPoints
{
    return self.lifeTimeScore % self.pointsPerLevel;
}

- (NSInteger)initialSecondsPerQuestion
{
    return [[[PFConfig currentConfig] objectForKey:@"initialSecondsPerQuestion"] integerValue];
}

- (double)secondsPerQuestion
{
    double sec = ((double)-1 / (double)self.pointsPerLevel)* (double)self.currentLevelPoints + self.initialSecondsPerQuestion;
    return sec;
    
}

- (double)animationSpeed
{
    //return 0.5 * (self.secondsPerQuestion/SECONDS_PER_QUESTION) * 1.75;
    return self.secondsPerQuestion/6;
}

- (NSArray *)availableQuestionTypes
{
    NSMutableArray *array = [NSMutableArray array];
    for (WIBQuestionType *questionType in self.questionTypes) {
        if (self.lifeTimeScore > [questionType.pointsToUnlock integerValue]) {
            [array addObject:questionType];
        }
    }
    //return [self.questionTypes subarrayWithRange:NSMakeRange(0,3)];
    return array;
}

- (double) skewFactor
{
    double skew = - (double).25 / (double)self.pointsPerLevel * self.currentLevelPoints + .3;
    return skew;
}

- (double) questionCeiling
{
    double ceiling = - (double)15 / (double)self.pointsPerLevel * self.currentLevelPoints + 20;
    return ceiling;
}

- (double) questionFloor
{
    double floor = - (double)4.99 / (double)self.pointsPerLevel * self.currentLevelPoints + 5;
    return floor;
}

- (void)adjustDifficulty
{
    if (self.gameRound.accuracy >= 0.7 && self.questionCeiling - 5 > self.questionFloor)
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
    else if (self.gameRound.accuracy <= 0.4)
    {
        self.questionCeiling += 5;
        if (self.questionFloor < (self.questionCeiling - 5) )
        {
            self.questionFloor +=5;
        }
        
        self.skewFactor += 0.1;
    }
}

- (void)setQuestionTypes:(NSMutableArray *)questionTypes
{
    _questionTypes = questionTypes;
    self.previousQuestionTypes = self.availableQuestionTypes;
}

- (void)unlockedQuestionTypeSeen:(WIBQuestionType *)unlockedQuestionType
{
    NSMutableArray *unlockedQuestionTypes = [[[PFUser currentUser] objectForKey:@"unlockedQuestionTypes"] mutableCopy];
    if (!unlockedQuestionTypes) {
        unlockedQuestionTypes = [NSMutableArray array];
    }
    [unlockedQuestionTypes addObject:unlockedQuestionType.name];
    [[PFUser currentUser] setObject:unlockedQuestionTypes forKey:@"unlockedQuestionTypes"];
    [[PFUser currentUser] saveInBackground];
}

- (void)setHighScore:(NSInteger)highScore
{
    [[NSUserDefaults standardUserDefaults] setObject:@(highScore) forKey:@"highScore"];
    [[PFUser currentUser] setObject:@(highScore) forKey:@"highScore"];
    [[PFUser currentUser] saveInBackground];
    [self syncScoreWithGameKit:@"highScore" scoreValue:self.highScore];
}

- (NSInteger)highScore
{
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"]).integerValue;
}

- (NSUInteger)score
{
    return self.gameRound.score;
}

- (void)setCurrentStreak:(NSInteger)currentStreak
{
//    [[NSUserDefaults standardUserDefaults] setObject:@(currentStreak) forKey:@"currentStreak"];
    [[PFUser currentUser] setObject:@(currentStreak) forKey:@"currentStreak"];
    [[PFUser currentUser] saveInBackground];
}

- (NSInteger)currentStreak
{
//    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentStreak"];
//    return (num) ? num.integerValue: 0;
    return [[[PFUser currentUser] objectForKey:@"currentStreak" ] integerValue];
}

- (void)setLongestStreak:(NSInteger)longestStreak
{
    [[NSUserDefaults standardUserDefaults] setObject:@(longestStreak) forKey:@"longestStreak"];
    [[PFUser currentUser] setObject:@(longestStreak) forKey:@"longestStreak"];
    [[PFUser currentUser] saveInBackground];
    [self syncScoreWithGameKit:@"longestStreak" scoreValue:self.longestStreak];
}

- (NSInteger)longestStreak
{
    return [[[PFUser currentUser] objectForKey:@"longestStreak" ] integerValue];
}

- (NSInteger)totalCorrectAnswers
{
    return [[[PFUser currentUser] objectForKey:@"totalCorrectAnswers" ] integerValue];
}

- (void)setTotalCorrectAnswers:(NSUInteger)totalCorrectAnswers
{
    [[PFUser currentUser] setObject:@(totalCorrectAnswers) forKey:@"totalCorrectAnswers"];
    [[PFUser currentUser] saveInBackground];
}

- (NSInteger)totalAnswers
{
    return [[[PFUser currentUser] objectForKey:@"totalAnswers" ] integerValue];
}

- (void)setTotalAnswers:(NSUInteger)totalAnswers
{
    [[PFUser currentUser] setObject:@(totalAnswers) forKey:@"totalAnswers"];
    [[PFUser currentUser] saveInBackground];
}

- (NSUInteger)questionNumber
{
    return self.gameRound.questionIndex;
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
    
    [self.gameRound questionAnsweredCorrectly];
}

- (void)didAnswerQuestionIncorrectly
{
    self.currentStreak = 0;
    self.totalAnswers++;
    [self.gameRound questionAnsweredInCorrectly];
}

- (void)didFailToAnswerQuestion
{
    self.currentStreak = 0;
    self.totalAnswers++;
    [self.gameRound questionAnsweredInCorrectly];
}

# pragma mark - GameKit
- (void)authenticateGameKitUser
{
    if ([GKLocalPlayer localPlayer].isAuthenticated == NO) {
        [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController * viewController, NSError *error){
            if (viewController) {
                AppDelegate *del = [UIApplication sharedApplication].delegate;
                [del.window.rootViewController presentViewController:viewController animated:YES completion:nil];
            }
            if(!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GameCenterDidFinishAuthentication" object:nil];
                [self syncScoresWithGameCenter];
            }
        };
    }
}

- (void)syncScoresWithGameCenter
{
    [self syncScoreWithGameKit:@"topScores" scoreValue:self.lifeTimeScore];
    [self syncScoreWithGameKit:@"highScore" scoreValue:self.highScore];
    [self syncScoreWithGameKit:@"longestStreak" scoreValue:self.longestStreak];
}

- (void)syncScoreWithGameKit:(NSString *)scoreName scoreValue:(NSInteger)scoreValue
{
    GKScore *gameKitScore = [[GKScore alloc] initWithLeaderboardIdentifier:scoreName];
    gameKitScore.value = scoreValue;
    [GKScore reportScores:@[gameKitScore] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
