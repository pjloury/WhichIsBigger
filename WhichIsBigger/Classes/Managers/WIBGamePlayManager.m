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
            }
        };
    }
}

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
    
    if (self.gameRound.score > [[WIBGamePlayManager sharedInstance] highScore])
    {
        self.highScore = self.gameRound.score;
    }
}

- (NSInteger)level
{
    return self.lifeTimeScore / POINTS_PER_LEVEL;
}

- (NSInteger)lifeTimeScore
{
    return [[[PFUser currentUser] objectForKey:@"lifeTimeScore"] integerValue];
}

- (void)setLifeTimeScore:(NSInteger)lifeTimeScore
{
    [[PFUser currentUser] setObject:@(lifeTimeScore) forKey:@"lifeTimeScore"];
    [[PFUser currentUser] saveInBackground];
}

- (NSInteger)currentLevelPoints
{
    return self.lifeTimeScore % POINTS_PER_LEVEL;
}


- (NSArray *)availableQuestionTypes
{
    // for every 5, give me the next question type
    //NSUInteger indexOfUnlockedCategories = self.level/5;
    //return [self.questionTypes subarrayWithRange:NSMakeRange(0, indexOfUnlockedCategories)];
    NSMutableArray *array = [NSMutableArray array];
    for (WIBQuestionType *questionType in self.questionTypes) {
        if (self.lifeTimeScore > [questionType.pointsToUnlock integerValue]) {
            [array addObject:questionType];
        }
    }
    return array;
}

// Start with countries
// Then cities and states

// How to determine which category to give them next. Need to be risk Adverse
// Cloud brings down the categories.. Always in the same order..
// Start with
// Use a colon to split apart categoryString from tag


- (double) questionCeiling
{
    return 5;
}

- (double) questionFloor
{
    return 0;
}

- (void)adjustDifficulty
{
    if (self.gameRound.accuracy >= 0.8 && self.questionCeiling - 5 > self.questionFloor)
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
    
- (void)setupGamePlay
{
    self.highScore = ((NSNumber *)[[PFUser currentUser] objectForKey:@"highScore"]).integerValue;
    self.longestStreak = ((NSNumber *)[[PFUser currentUser] objectForKey:@"longestStreak"]).integerValue;
    [self authenticateGameKitUser];
}

- (WIBGameQuestion *)nextGameQuestion
{
    return [self.gameRound nextGameQuestion];
}

- (void)setHighScore:(NSInteger)highScore
{
    [[NSUserDefaults standardUserDefaults] setObject:@(highScore) forKey:@"highScore"];
    [[PFUser currentUser] setObject:@(highScore) forKey:@"highScore"];
    [[PFUser currentUser] saveInBackground];
    GKScore *gameKitHighScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"highScore"];
    gameKitHighScore.value = highScore;
    
    [GKScore reportScores:@[gameKitHighScore] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
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
    GKScore *gameKitLongestStreak = [[GKScore alloc] initWithLeaderboardIdentifier:@"longestStreak"];
    gameKitLongestStreak.value = longestStreak;
    [GKScore reportScores:@[gameKitLongestStreak] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (NSInteger)longestStreak
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"longestStreak"];
    return (num) ? num.integerValue: 0;
}

- (NSInteger)totalCorrectAnswers
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalCorrectAnswers"];
    return (num) ? num.integerValue: 0;
}

- (void)setTotalCorrectAnswers:(NSUInteger)totalCorrectAnswers
{
    [[NSUserDefaults standardUserDefaults] setObject:@(totalCorrectAnswers) forKey:@"totalCorrectAnswers"];
}

- (NSInteger)totalAnswers
{
    //PFQuery *totalAnswersQuery [PFQuery queryWithClassName:@"Question"];
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalAnswers"];
    return (num) ? num.integerValue: 0;
}

- (void)setTotalAnswers:(NSUInteger)totalAnswers
{
    [[NSUserDefaults standardUserDefaults] setObject:@(totalAnswers) forKey:@"totalAnswers"];
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
//    float accu;
//    PFQuery *accuracyQuery = [PFQuery queryWithClassName:@"Question"];
//    [accuracyQuery whereKey:@"user" equalTo: [PFUser currentUser]];
//    return accu;
    // can filter the questions for answeredCorrectly!
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

@end
