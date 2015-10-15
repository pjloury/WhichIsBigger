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
- (void)beginGame;
- (void)endGame;
- (NSUInteger)score;
- (WIBGameQuestion *)nextGameQuestion;

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
@property (nonatomic, assign, readonly) NSUInteger totalCorrectAnswers;
@property (nonatomic, assign, readonly) NSUInteger totalAnswers;
@property (nonatomic, assign, readonly) float accuracy;

@property (nonatomic, assign, readonly) NSUInteger level;

@end