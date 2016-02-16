//
//  WIBGamePlayManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameRound.h"

@protocol WIBScoringDelegate
- (void)didAnswerQuestionCorrectly;
- (void)didAnswerQuestionIncorrectly;
- (void)didFailToAnswerQuestion;
@end

@class WIBGameQuestion;
@class WIBQuestionType;
@interface WIBGamePlayManager : NSObject<WIBScoringDelegate>

+ (WIBGamePlayManager *)sharedInstance;

- (void)setupGamePlay;
- (void)beginRoundForType:(WIBQuestionType *)type;
- (void)beginRound;
- (void)endGame;
- (NSUInteger)score;
- (WIBGameQuestion *)nextGameQuestion;

@property (nonatomic) NSArray *availableQuestionTypes;
@property (nonatomic) NSMutableArray *questionTypes;
@property (nonatomic, readonly) WIBGameRound *gameRound;
@property (nonatomic, assign, readonly) NSUInteger questionNumber;


@property (nonatomic, assign) double questionCeiling;
@property (nonatomic, assign) double questionFloor;
@property (nonatomic, assign) double skewFactor;
@property (nonatomic, assign) BOOL localStorage;

@property (nonatomic, assign, readonly) NSInteger highScore;
@property (nonatomic, assign, readonly) NSInteger currentStreak;
@property (nonatomic, assign, readonly) NSInteger longestStreak;
@property (nonatomic, assign, readonly) NSInteger totalCorrectAnswers;
@property (nonatomic, assign, readonly) NSInteger totalAnswers;
@property (nonatomic, assign, readonly) float accuracy;

@property (nonatomic, assign, readonly) NSInteger level;
@property (nonatomic, assign, readonly) NSInteger currentLevelPoints;

@end