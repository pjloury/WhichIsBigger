//
//  WIBGamePlayManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WIBScoringDelegate
- (void)didAnswerQuestionCorrectly;
- (void)didAnswerQuestionIncorrectly;
- (void)didFailToAnswerQuestion;
@end

@class WIBGameQuestion;
@interface WIBGamePlayManager : NSObject<WIBScoringDelegate>

- (void)beginGame;
- (void)endGame;

- (void)setupGamePlay;

+ (WIBGamePlayManager *)sharedInstance;
- (WIBGameQuestion *)nextGameQuestion;
- (NSInteger)numberCorrectAnswers;

@property (readonly) NSInteger questionIndex;
@property (nonatomic, strong) NSArray *tagBlacklist;
@property (nonatomic, assign) double questionCeiling;
@property (nonatomic, assign) double questionFloor;
@property (nonatomic, assign) double skewFactor;
@property (nonatomic, strong) NSMutableSet *usedNames;
@property (nonatomic, strong, readonly) NSMutableArray *gameQuestions;
@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger highScore;
@property (nonatomic, assign, readonly) NSInteger currentStreak;
@property (nonatomic, assign, readonly) NSInteger longestStreak;
@property (nonatomic, assign, readonly) NSUInteger totalCorrectAnswers;
@property (nonatomic, assign, readonly) NSUInteger totalAnswers;
@property (nonatomic, assign, readonly) float accuracy;


@end