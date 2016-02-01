//
//  WIBGameRound.m
//  WhichIsBigger
//
//  Created by PJ Loury on 10/15/15.
//  Copyright © 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameRound.h"
#import "WIBGameQuestion.h"
#import "WIBDissimilarQuestion.h"

// Managers
#import "WIBNetworkManager.h"
#import "WIBGamePlayManager.h"

@interface WIBGameRound ()
@property (nonatomic) NSInteger questionIndex;

@property (nonatomic, strong) WIBGameQuestion *currentQuestion;

@property NSMutableArray *randomColors;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSMutableArray *gameQuestions;
@property (nonatomic) NSString *roundUUID;

@end

@implementation WIBGameRound

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.questionIndex = 0;
        self.usedNames = [[NSMutableSet alloc] init];
        self.roundUUID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSString *)category
{
    WIBGameQuestion *question =  [self.gameQuestions firstObject];
    NSString *qString = question.questionType.questionString;
    return [NSString stringWithFormat:@"Which %@", qString];
}

- (void)generateQuestions
{
    NSMutableArray *questions = [NSMutableArray array];
    
    WIBQuestionType *questionType = [self randomQuestionType];
    
    for(int i = 0; i < NUMBER_OF_QUESTIONS; i++)
    {
        // TODO: Server driven # of categories .. (future looking)
        
        // random number based on the number of categories
        // categories should be a set
        
        // can have a relation to another type of object
        // the send type of object is a category
        
        WIBGameQuestion *question;
        switch(questionType.comparisonType) {
            case (WIBComparisonUnalikeType):
                question = [[WIBDissimilarQuestion alloc] initWithQuestionType:questionType];
                break;
            default:
                question = [[WIBGameQuestion alloc] initOneToOneQuestion:questionType];
                break;
        }
        [questions addObject:question];
        
    }

    [[WIBNetworkManager sharedInstance] preloadImages:questions];
    self.gameQuestions = questions;
    
    self.randomColors = [UIColor randomColors];
}

- (UIColor *)randomColor
{
    UIColor *color = [self.randomColors firstObject];
    [self.randomColors removeObject:color];
    return color;
}

- (void)printQuestions
{
    for(WIBGameQuestion *question in self.gameQuestions)
    {
        NSString *string = [NSString stringWithFormat:@"%@ vs. %@", question.option1.item.name, question.option2.item.name];
        NSLog(@"%@",string);
    }
}

- (WIBQuestionType *)randomQuestionType
{
    // categoryWhiteList
    NSUInteger randomQuestionTypeIndex = arc4random_uniform((u_int32_t)[WIBGamePlayManager sharedInstance].questionTypes.count);
    return [WIBGamePlayManager sharedInstance].questionTypes[randomQuestionTypeIndex];
    
    // return a specific questionType
}

- (WIBGameQuestion *)nextGameQuestion
{
    // always ask for next question. Manager should hold all of the state
    if (self.currentQuestion)
    {
        [self.currentQuestion saveInBackground];
    }
    self.currentQuestion = [self.gameQuestions objectAtIndex:self.questionIndex];
    self.questionIndex++;
    return self.currentQuestion;
}

- (NSUInteger)numberOfCorrectAnswers
{
    NSInteger correctAnswers = 0;
    for (WIBGameQuestion *question in self.gameQuestions)
    {
        if(question.answeredCorrectly)
            correctAnswers++;
    }
    return correctAnswers;
}

- (float)accuracy
{
    return (float)self.numberOfCorrectAnswers / NUMBER_OF_QUESTIONS;
}

- (void)questionAnsweredCorrectly
{
    self.currentQuestion.points = round(POINTS_PER_QUESTION - (POINTS_PER_QUESTION * self.currentQuestion.answerTime / SECONDS_PER_QUESTION));
}

- (void)questionAnsweredInCorrectly
{
    self.currentQuestion.points = 0;
}

# pragma mark - Accessors
- (NSInteger)score
{
    _score = 0;
    for (WIBGameQuestion *question in self.gameQuestions)
    {
        if (question.answeredCorrectly)
        {
            _score += round(POINTS_PER_QUESTION - (POINTS_PER_QUESTION * question.answerTime / SECONDS_PER_QUESTION));
        }
    }
    
    return _score;
}


@end
