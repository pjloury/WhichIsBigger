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

@property (nonatomic, weak) WIBGameQuestion *question;
@property (nonatomic, strong) WIBOptionView *optionView1;
@property (nonatomic, strong) WIBOptionView *optionView2;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WIBQuestionView

- (instancetype)initWithGameQuestion:(WIBGameQuestion *)question {
    if (self = [super init]) {
        _question = question;
        
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revealAnswer) name:kGameQuestionTimeUpNotification object:nil];
    
    self.optionView1 = [[WIBOptionView alloc] initWithGameOption:self.question.option1];
    self.optionView1.delegate = self;
    
    self.optionView2 = [[WIBOptionView alloc] initWithGameOption:self.question.option2];
    self.optionView2.delegate = self;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = self.question.questionText ? : @"Which is Bigger?";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:HELVETICA_NEUE_LIGHT size:24];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    
    [self addSubview:self.optionView1];
    [self addSubview:self.optionView2];
    [self addSubview:self.titleLabel];
    
    self.optionView1.translatesAutoresizingMaskIntoConstraints = NO;
    self.optionView2.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.titleLabel ic_centerHorizontallyInSuperView];
    NSDictionary *views = @{@"title" : self.titleLabel , @"option1" : self.optionView1 , @"option2" : self.optionView2};
    NSDictionary *metics = @{@"pad" : @16};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[title(40)]" options:0 metrics:metics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-10-[option2]-pad-|" options:0 metrics:metics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-10-[option1]-pad-|" options:0 metrics:metics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pad-[option1]-pad-[option2]-pad-|" options:0 metrics:metics views:views]];
    [self.optionView1 ic_constraintForWidthAttributeEqualtToView:self.optionView2 multiplier:1];
    
    self.backgroundColor = [UIColor purpleColor];
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
