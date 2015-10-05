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
@class WIBQuestionType;
@interface WIBGamePlayManager : NSObject<WIBScoringDelegate>

+ (WIBGamePlayManager *)sharedInstance;

- (void)setupGamePlay;
- (void)beginGame;
- (void)endGame;
- (WIBGameQuestion *)nextGameQuestion;

- (NSInteger)numberCorrectAnswers;

@property (readonly) NSInteger questionIndex;
@property (readonly) NSString *roundUUID;
@property (nonatomic) NSMutableArray *questionTypes;
@property (nonatomic, assign) double questionCeiling;
@property (nonatomic, assign) double questionFloor;
@property (nonatomic, assign) double skewFactor;
@property (nonatomic, strong) NSMutableSet *usedNames;
@property (nonatomic, assign) BOOL localStorage;

@property (nonatomic, strong, readonly) NSMutableArray *gameQuestions;
@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger highScore;
@property (nonatomic, assign, readonly) NSInteger currentStreak;
@property (nonatomic, assign, readonly) NSInteger longestStreak;
@property (nonatomic, assign, readonly) NSUInteger totalCorrectAnswers;
@property (nonatomic, assign, readonly) NSUInteger totalAnswers;
@property (nonatomic, assign, readonly) float accuracy;

@end