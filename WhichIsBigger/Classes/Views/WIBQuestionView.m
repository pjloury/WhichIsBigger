//
//  WIBQuestionView.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/28/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBQuestionView.h"

// Views
#import "WIBOptionView.h"

// Models
#import "WIBGameOption.h"
#import "WIBGameQuestion.h"
#import "UIView+AutoLayout.h"

// Managers
#import "WIBGamePlayManager.h"

@protocol WIBScoringDelegate;

@interface WIBQuestionView ()<WIBQuestionViewDelegate>

@property (nonatomic, strong) IBOutlet WIBOptionView *optionView1;
@property (nonatomic, strong) IBOutlet WIBOptionView *optionView2;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *pointsLabel;
@property (nonatomic, assign) NSInteger incrementedScore;
@property (nonatomic, strong ) NSTimer * scoreLabelTimer;

@property (nonatomic, weak) id<WIBScoringDelegate> scoringDelegate;

@end

@implementation WIBQuestionView

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeUp) name:kGameQuestionTimeUpNotification object:nil];
    
    self.optionView1.gameOption = self.question.option1;
    [self.optionView1 configureViews];
    self.optionView1.delegate = self;
    
    self.optionView2.gameOption = self.question.option2;
    [self.optionView2 configureViews];
    self.optionView2.delegate = self;
    
    self.scoringDelegate = [WIBGamePlayManager sharedInstance];
    self.titleLabel.text = self.question.questionText ? : @"Which is Bigger?";
    self.pointsLabel.alpha = 0.0;
}

- (void)refreshWithQuestion:(WIBGameQuestion *)question
{
    self.question = question;
    self.gamePlayDisabled = NO;
    self.titleLabel.text = self.question.questionText ? : @"Which is Bigger?";
    [self.optionView1 refreshWithOption:self.question.option1];
    [self.optionView2 refreshWithOption:self.question.option2];
}

# pragma mark - Transition Animations
- (void)startQuestionEntranceAnimationWithCompletion:(void (^)(BOOL finished))completion
{
    [self.optionView1.layer removeAllAnimations];
    [self.optionView2.layer removeAllAnimations];
    
    self.optionView1.transform = CGAffineTransformMakeTranslation(-300, 0);
    self.optionView2.transform = CGAffineTransformMakeTranslation(300, 0);
    self.optionView1.hidden = NO;
    self.optionView2.hidden = NO;
    
    [UIView animateKeyframesWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed*.85 delay:0 options:0 animations:^{
        self.optionView1.transform = CGAffineTransformMakeTranslation(0, 0);
        self.optionView2.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:completion];
}

- (void)startQuestionExitAnimationWithCompletion:(void (^)(BOOL finished))completion
{
    [self.optionView1.layer removeAllAnimations];
    [self.optionView2.layer removeAllAnimations];
    
    [self.scoreLabelTimer invalidate];
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld pts",(long)[WIBGamePlayManager sharedInstance].score];
    
    [UIView animateKeyframesWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed*.85 delay:0 options:0 animations:^{
        self.optionView1.transform = CGAffineTransformMakeTranslation(-300, 0);
        self.optionView2.transform = CGAffineTransformMakeTranslation(300, 0);
        [self.optionView1 removeAllAnimations];
        [self.optionView2 removeAllAnimations];
    } completion:^(BOOL finished){
        self.optionView1.transform = CGAffineTransformMakeTranslation(0, 0);
        self.optionView2.transform = CGAffineTransformMakeTranslation(0, 0);
        self.optionView1.hidden = YES;
        self.optionView2.hidden = YES;
        completion(finished);
        }
     ];
}

- (void)animateCorrectOptionView:(WIBOptionView *)optionView
{
    [optionView animatePointsLabel:self.question.points];
    
    self.comparsionSymbol.hidden = NO;
    
    self.comparsionSymbol.transform = CGAffineTransformMakeScale(1, 1);
    self.comparsionSymbol.alpha = 1;
    self.comparsionSymbol.backgroundColor = [UIColor clearColor];
    self.comparsionSymbol.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
        // End
        self.comparsionSymbol.transform = CGAffineTransformMakeScale(3, 3);
        self.comparsionSymbol.alpha = 0;
        self.comparsionSymbol.backgroundColor = [UIColor clearColor];
        self.comparsionSymbol.layer.backgroundColor = [UIColor clearColor].CGColor;
        
    } completion:^(BOOL finished) {
        self.comparsionSymbol.transform = CGAffineTransformMakeScale(1, 1);
        self.comparsionSymbol.alpha = 0;
        self.comparsionSymbol.backgroundColor = [UIColor clearColor];
        self.comparsionSymbol.layer.backgroundColor = [UIColor clearColor].CGColor;
    }];
    
    [optionView.layer removeAllAnimations];
    optionView.type = CSAnimationTypePop;
    optionView.duration = [WIBGamePlayManager sharedInstance].animationSpeed;
    [optionView startCanvasAnimation];
}

- (void)animateIncorrectOptionView:(WIBOptionView *)optionView
{
    optionView.type = CSAnimationTypeShake;
    optionView.duration = [WIBGamePlayManager sharedInstance].animationSpeed;
    [optionView startCanvasAnimation];
}

# pragma mark - WIBQuestionViewDelegate
- (void)animatePointsView
{
    NSInteger score = [[[WIBGamePlayManager sharedInstance] gameRound] score];
    NSInteger questionIndex = [[[WIBGamePlayManager sharedInstance] gameRound] questionIndex];
    WIBGameQuestion *lastQuestion = [[[[WIBGamePlayManager sharedInstance] gameRound] gameQuestions] objectAtIndex:questionIndex-1];
    self.incrementedScore = score - lastQuestion.points;
    
    self.pointsLabel.alpha = 1.0;
    self.scoreLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
}

- (void)incrementScore
{
    if (self.incrementedScore < [WIBGamePlayManager sharedInstance].score)
    {
        _incrementedScore++;
        self.pointsLabel.text = [NSString stringWithFormat:@"%ld pts",(long)self.incrementedScore];
    }
    else
    {
        [self.scoreLabelTimer invalidate];
    }
}


- (void)optionView:(WIBOptionView *)optionView didSelectOption:(WIBGameOption *)option
{
    self.gamePlayDisabled = YES;
    [self.optionView1 optionWasSelected];
    [self.optionView2 optionWasSelected];
    
    [self.gamePlayDelegate questionView:self didSelectOption:option];
    NSLog(@"Selected: %@ vs Answer: %@",option.item.name, self.question.answer.item.name);
    
    if([option.item.name isEqualToString:self.question.answer.item.name])
    {
        self.titleLabel.text = @"Correct!";
        self.question.answeredCorrectly = YES;
        [optionView correctResponse];
        [self.scoringDelegate didAnswerQuestionCorrectly];
        [self animateCorrectOptionView:optionView];
        [self animatePointsView];
    }
    else
    {
        self.titleLabel.text = @"Wrong!";
        self.question.answeredCorrectly = NO;
        [optionView incorrectResponse];
        [self animateIncorrectOptionView:optionView];
        [self.scoringDelegate didAnswerQuestionIncorrectly];
    }
    
    [self revealAnswer];
}

- (void)timeUp
{
    self.titleLabel.text = @"Too Slow!";
    
    self.optionView1.type = CSAnimationTypeFadeIn;
    self.optionView1.duration = 0.75;
    
    self.optionView2.type = CSAnimationTypeFadeIn;
    self.optionView2.duration = 0.75;
    
    self.comparsionSymbolAnimationView.type = CSAnimationTypeFadeIn;
    self.comparsionSymbolAnimationView.duration = 0.75;
    
    [self.optionView1 startCanvasAnimation];
    [self.optionView2 startCanvasAnimation];
    
    if (self.optionView1.gameOption == self.question.answer)
    {
        [self.optionView1 animateTimeOutLarger];
    }
    else
    {
        [self.optionView2 animateTimeOutLarger];
    }

    self.gamePlayDisabled = YES;
    
    self.optionView1.alpha = 0.5;
    self.optionView2.alpha = 0.5;
    [self.optionView1 revealAnswerLabel];
    [self.optionView2 revealAnswerLabel];
    
    [self.scoringDelegate didFailToAnswerQuestion];
    
    [self.gamePlayDelegate questionViewDidFinishRevealingAnswer:self];
    
//    [self.comparsionSymbolAnimationView startCanvasAnimation];
//    self.comparsionSymbol.hidden = NO;
//    self.comparsionSymbol.alpha = 0.5;

//    if([self.optionView1.gameOption.item.name isEqualToString:self.question.answer.item.name])
//    {
//        self.comparsionSymbol.text = @">";
//    }
//    else
//    {
//        self.comparsionSymbol.text = @"<";
//    }
}

- (void)revealAnswer
{
    if(self.question.option1.total.doubleValue > self.question.option2.total.doubleValue) {
		// stub for answer reveal animation sequence
    }
    else {
		// stub for answer reveal animation sequence
    }
    
    [self.optionView1 revealAnswerLabel];
    [self.optionView2 revealAnswerLabel];
    [self.gamePlayDelegate questionViewDidFinishRevealingAnswer:self];//timeup is also calling this
}

@end
