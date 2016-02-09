//
//  WIBGameRound.h
//  WhichIsBigger
//
//  Created by PJ Loury on 10/15/15.
//  Copyright © 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIBGameQuestion;
@class WIBQuestionType;

@interface WIBGameRound : NSObject

// mutable
@property (nonatomic, strong) NSMutableSet *usedNames;

// non-mutable
@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) float accuracy;
@property (nonatomic, strong, readonly) NSMutableArray *gameQuestions;
@property (readonly) NSString *roundUUID;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, readonly) NSInteger questionIndex;

- (void)generateQuestions;
- (void)generateQuestionsForType:(WIBQuestionType *)questionType;
- (UIColor *)randomColor;

- (void)questionAnsweredCorrectly;
- (void)questionAnsweredInCorrectly;

- (WIBGameQuestion *)nextGameQuestion;
- (NSUInteger)numberOfCorrectAnswers;

@end
