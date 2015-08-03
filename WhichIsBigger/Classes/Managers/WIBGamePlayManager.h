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
@end

@class WIBGameQuestion;
@interface WIBGamePlayManager : NSObject<WIBScoringDelegate>

- (void)beginGame;

+ (WIBGamePlayManager *)sharedInstance;
- (WIBGameQuestion *)nextGameQuestion;
- (NSInteger)numberCorrectAnswers;

@property (readonly) NSInteger questionIndex;
@property (nonatomic, assign) double difficulty;
@property (nonatomic, strong) NSMutableSet *usedNames;
@property (nonatomic, strong, readonly) NSMutableArray *gameQuestions;
@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger highScore;
@property (nonatomic, assign, readonly) NSInteger currentStreak;
@property (nonatomic, assign, readonly) NSInteger longestStreak;

@end