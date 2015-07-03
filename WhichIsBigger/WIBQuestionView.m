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
#import "WIBConstants.h"
#import "UIView+AutoLayout.h"

@interface WIBQuestionView ()<WIBQuestionViewDelegate>

@property (nonatomic, strong) IBOutlet WIBOptionView *optionView1;
@property (nonatomic, strong) IBOutlet WIBOptionView *optionView2;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation WIBQuestionView

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revealAnswer) name:kGameQuestionTimeUpNotification object:nil];
    
    self.optionView1.gameOption = self.question.option1;
    [self.optionView1 configureViews];
    self.optionView1.delegate = self;
    
    self.optionView2.gameOption = self.question.option2;
    [self.optionView2 configureViews];
    self.optionView2.delegate = self;
    
    self.titleLabel.text = self.question.questionText ? : @"Which is Bigger?";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:HELVETICA_NEUE_LIGHT size:24];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    
    [self addSubview:self.titleLabel];
}

- (void)refreshWithQuestion:(WIBGameQuestion *)question
{
    self.question = question;
    self.titleLabel.text = self.question.questionText ? : @"Which is Bigger?";
    [self.optionView1 refreshWithOption:self.question.option1];
    [self.optionView2 refreshWithOption:self.question.option2];
    self.optionView1.backgroundColor = [UIColor clearColor];
    self.optionView2.backgroundColor = [UIColor clearColor];
}

# pragma mark - WIBQuestionViewDelegate
- (void)optionView:(WIBOptionView *)optionView didSelectOption:(WIBGameOption *)option
{
    [self.delegate questionView:self didSelectOption:option];
    NSLog(@"Selected: %@ vs Answer: %@",option.item.name, self.question.answer.item.name);
    if([option.item.name isEqualToString:self.question.answer.item.name])
    {
        NSLog(@"CORRECT OPTION CHOSEN");
        self.question.answeredCorrectly = YES;
    }
    else
    {
        NSLog(@"Wrong Answer Chosen!");
        self.question.answeredCorrectly = NO;
    }
    [self revealAnswer];
}

- (void)revealAnswer
{
    if(self.question.option1.total.doubleValue > self.question.option2.total.doubleValue)
    {
        self.optionView1.backgroundColor = [UIColor greenColor];
    }
    else
    {
        self.optionView2.backgroundColor = [UIColor greenColor];
    }
    
    [self.optionView1 revealAnswerLabel];
    [self.optionView2 revealAnswerLabel];
    [self.delegate questionViewDidFinishRevealingAnswer:self];
}

@end
