//
//  WIBGamePlayManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameRound.h"
#import "WIBQuestionType.h"

@protocol WIBScoringDelegate
- (void)didAnswerQuestionCorrectly;
- (void)didAnswerQuestionIncorrectly;
- (void)didFailToAnswerQuestion;
@end

@class WIBGameQuestion;
@interface WIBGamePlayManager : NSObject<WIBScoringDelegate>

+ (WIBGamePlayManager *)sharedInstance;

// Game State
- (void)setupGamePlay;
- (void)beginRoundForType:(WIBQuestionType *)type;
- (void)beginRound;
- (void)endGame;
- (WIBGameQuestion *)nextGameQuestion;
- (void)authenticateGameKitUser;

@property (nonatomic, readonly) NSArray *availableQuestionTypes;
@property (nonatomic) NSMutableArray *questionTypes;
@property (nonatomic, readonly) WIBGameRound *gameRound;
@property (nonatomic, assign, readonly) NSUInteger questionNumber;

// Difficulty
@property (nonatomic, assign) double questionCeiling;
@property (nonatomic, assign) double questionFloor;
@property (nonatomic, assign) double skewFactor;

// Game Parameters
@property (nonatomic, assign, readonly) double secondsPerQuestion;
@property (nonatomic, assign, readonly) double animationSpeed;

// Caching
@property (nonatomic, assign) BOOL localStorage;

// Scoring
@property (nonatomic, assign, readonly) NSInteger highScore;
@property (nonatomic, assign, readonly) NSInteger currentStreak;
@property (nonatomic, assign, readonly) NSInteger longestStreak;

// Statistics
@property (nonatomic, assign, readonly) NSInteger totalCorrectAnswers;
@property (nonatomic, assign, readonly) NSInteger totalAnswers;
@property (nonatomic, assign, readonly) float accuracy;

// Level Advancement
- (NSUInteger)score;
@property (nonatomic, assign, readonly) NSInteger level;
@property (nonatomic, assign, readonly) NSInteger currentLevelPoints;
@property (nonatomic) WIBQuestionType *unlockedQuestionType;

@end