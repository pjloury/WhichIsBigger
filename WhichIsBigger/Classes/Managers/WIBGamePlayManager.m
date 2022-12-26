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
        shared.skewFactor = 0.5;
        shared.questionCeiling = 40;
        shared.questionFloor = 10;
    });
    return shared;
}

# pragma mark - Testing
- (void)generateQuestionTypes {
    
    WIBQuestionType *age = [[WIBQuestionType alloc] initWith: 0
                                                      category: @"age" // This is used as a reference type in the data model
                                                         title:  @"Age" // Under the little app icon on the home screen
                                                  primaryColor:  @"FCEC61"
                                                secondaryColor:  @"F09F44"
                                                pointsToUnlock: @-1
                                                      imageURL: @"https://cdn-icons-png.flaticon.com/512/9064/9064190.png"
                                                questionString: @"Who is Older?" ];
    
    WIBQuestionType *weight = [[WIBQuestionType alloc] initWith: 0
                                                      category: @"weight" // This is used as a reference type in the data model
                                                         title:  @"Weight" // Under the little app icon on the home screen
                                                  primaryColor:  @"6FB948"
                                                secondaryColor:  @"6737B5"
                                                pointsToUnlock: @600
                                                      imageURL: @"https://cdn-icons-png.flaticon.com/512/2834/2834539.png"
                                                questionString: @"Who is Heavier?" ];
    
    WIBQuestionType *height = [[WIBQuestionType alloc] initWith: 0
                                                      category: @"height" // This is used as a reference type in the data model
                                                         title:  @"Height" // Under the little app icon on the home screen
                                                  primaryColor:  @"D63A64"
                                                secondaryColor:  @"FAE251"
                                                pointsToUnlock: @1200
                                                      imageURL: @"https://cdn-icons-png.flaticon.com/512/8531/8531897.png"
                                                questionString: @"Who is Taller?" ];
    
    WIBQuestionType *population = [[WIBQuestionType alloc] initWith: 0
                                                      category: @"population" // This is used as a reference type in the data model
                                                         title:  @"Population" // Under the little app icon on the home screen
                                                  primaryColor:  @"D0D552"
                                                secondaryColor:  @"55A9D8"
                                                pointsToUnlock: @1800
                                                      imageURL: @"https://cdn-icons-png.flaticon.com/512/33/33308.png"
                                                questionString: @"Which is Bigger?" ];
    
    self.questionTypes = [@[age, weight, height, population] mutableCopy];
    
}


# pragma mark - Game State

- (void)beginRound
{
    [self beginRoundForType:[self randomQuestionType]];
}

- (WIBQuestionType *)randomQuestionType
{
    NSUInteger randomQuestionTypeIndex = arc4random_uniform((u_int32_t)self.availableQuestionTypes.count);
    return self.availableQuestionTypes[randomQuestionTypeIndex];
}

- (void)beginRoundForType:(WIBQuestionType *)type
{
    self.gameRound = [[WIBGameRound alloc] initWithQuestionType:type];
    @synchronized ([WIBDataModel sharedInstance]) {
        [self.gameRound generateQuestions];
    }
    
    /*
    if (self.unlockedQuestionType == type) {
        self.unlockedQuestionTypes = self.availableQuestionTypes;
    }
     */
}

- (void)endGame
{
    [self adjustDifficulty];
    
    self.lifeTimeScore = self.lifeTimeScore + self.score;
    
    if (self.availableQuestionTypes.count > self.previouslyUnlockedQuestionTypes.count) {
        self.unlockedQuestionType = self.availableQuestionTypes.lastObject;
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

- (NSArray *) previouslyUnlockedQuestionTypes {
    NSMutableArray *array = [NSMutableArray array];
    for (WIBQuestionType *questionType in self.questionTypes) {
        NSInteger previousScore = self.lifeTimeScore - self.score;
        if (previousScore > [questionType.pointsToUnlock integerValue] ) {
            [array addObject:questionType];
        }
    }
    //return [self.questionTypes subarrayWithRange:NSMakeRange(0,3)];
    return array;
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

/*
- (NSArray *) unlockedQuestionTypes
{
    return ((NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"unlockedQuestionTypes"]);
    
    
}
    
- (void) setUnlockedQuestionTypes: (NSArray *) unlockedQuestionTypes
{
    [[NSUserDefaults standardUserDefaults] setObject:unlockedQuestionTypes forKey:@"unlockedQuestionTypes"];
}
*/
    
    
- (NSInteger)pointsPerQuestion
{
    return 100;
}

- (NSInteger)pointsPerLevel
{
    return 600;
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
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"lifeTimeScore"]).integerValue;
}

- (void)setLifeTimeScore:(NSInteger)lifeTimeScore
{
    [[NSUserDefaults standardUserDefaults] setObject:@(lifeTimeScore) forKey:@"lifeTimeScore"];
    NSLog(@"🎉Lifetime score: %ld",(long)lifeTimeScore);
    [self syncScoreWithGameKit:@"topScores" scoreValue:self.lifeTimeScore];
}

- (NSInteger)currentLevelPoints
{
    return self.lifeTimeScore % self.pointsPerLevel;
}

- (NSInteger)initialSecondsPerQuestion
{
    return 5;
}

- (double)secondsPerQuestion
{
    double sec = ((double)-1 / (double)self.pointsPerLevel)* (double)self.currentLevelPoints + self.initialSecondsPerQuestion;
    return sec;
    
}

- (double)fastAnimationSpeed
{
    return self.secondsPerQuestion/10;
}

- (double)animationSpeed
{
    //return 0.5 * (self.secondsPerQuestion/SECONDS_PER_QUESTION) * 1.75;
    return self.secondsPerQuestion/6;
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

// Set during app initialization
- (void)setQuestionTypes:(NSMutableArray *)questionTypes
{
    _questionTypes = questionTypes;
}

- (void)setHighScore:(NSInteger)highScore
{
    [[NSUserDefaults standardUserDefaults] setObject:@(highScore) forKey:@"highScore"];
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
    [[NSUserDefaults standardUserDefaults] setObject:@(currentStreak) forKey:@"currentStreak"];
}

- (NSInteger)currentStreak
{
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"currentStreak"]).integerValue;
}

- (void)setLongestStreak:(NSInteger)longestStreak
{
    [[NSUserDefaults standardUserDefaults] setObject:@(longestStreak) forKey:@"longestStreak"];
    [self syncScoreWithGameKit:@"longestStreak" scoreValue:self.longestStreak];
}

- (NSInteger)longestStreak
{
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"longestStreak"]).integerValue;
}

- (NSInteger)totalCorrectAnswers
{
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"totalCorrectAnswers"]).integerValue;
}

- (void)setTotalCorrectAnswers:(NSUInteger)totalCorrectAnswers
{
    [[NSUserDefaults standardUserDefaults] setObject:@(totalCorrectAnswers) forKey:@"totalCorrectAnswers"];
    [self syncScoreWithGameKit:@"totalCorrectAnswers" scoreValue:self.longestStreak];
}

- (NSInteger)totalAnswers
{
    return ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"totalAnswers"]).integerValue;
}

- (void)setTotalAnswers:(NSUInteger)totalAnswers
{
    [[NSUserDefaults standardUserDefaults] setObject:@(totalAnswers) forKey:@"totalAnswers"];
    [self syncScoreWithGameKit:@"totalAnswers" scoreValue:self.longestStreak];

}

- (NSUInteger)questionNumber
{
    return self.gameRound.questionIndex;
}

- (BOOL)localStorage
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    NSNumber *num;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *versionNumber = [f numberFromString:version];
    if (versionNumber.doubleValue >= 2) {
         num = [[NSUserDefaults standardUserDefaults] objectForKey:@"localStorageV2"];
    } else {
         num = [[NSUserDefaults standardUserDefaults] objectForKey:@"localStorage"];
    }
    return (num) ? num.integerValue: 0;
}

- (void)setLocalStorage:(BOOL)localStorage
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *versionNumber = [f numberFromString:version];
    if (versionNumber.doubleValue >= 2) {
        [[NSUserDefaults standardUserDefaults] setObject:@(localStorage) forKey:@"localStorageV2"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@(localStorage) forKey:@"localStorage"];
    }
}

- (BOOL)categoriesInLocalStorage
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"categoriesInLocalStorage"];
    return (num) ? num.integerValue: 0;
}

- (void)setCategoriesInLocalStorage:(BOOL)categoriesInLocalStorage
{
    [[NSUserDefaults standardUserDefaults] setObject:@(categoriesInLocalStorage) forKey:@"categoriesInLocalStorage"];
}

- (BOOL)gameItemsInLocalStorage
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"gameItemsInLocalStorage"];
    return (num) ? num.integerValue: 0;
}

- (void)setGameItemsInLocalStorage:(BOOL)gameItemsInLocalStorage
{
    [[NSUserDefaults standardUserDefaults] setObject:@(gameItemsInLocalStorage) forKey:@"gameItemsInLocalStorage"];
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
