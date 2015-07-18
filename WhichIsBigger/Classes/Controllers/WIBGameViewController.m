//
//  WIBGameViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameViewController.h"

// Views
#import "WIBQuestionView.h"
#import "WIBPopButton.h"
#import "UIView+AutoLayout.h"

// Models
#import "WIBGameQuestion.h"
#import "WIBGameItem.h"

// Controller
#import "WIBGameCompleteViewController.h"

// Managers
#import "WIBGamePlayManager.h"

@interface WIBGameViewController ()

// Model
@property (strong, nonatomic) WIBGameQuestion *question;
@property (strong, atomic) NSTimer *timer;
@property (strong, atomic) NSDate *startDate;
@property int currSeconds;

// Views
@property (nonatomic, strong) IBOutlet WIBQuestionView *questionView;
@property (nonatomic, strong) IBOutlet WIBPopButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *timerBar;
@property (nonatomic, strong) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerLengthConstraint;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation WIBGameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Set Game State
    [[WIBGamePlayManager sharedInstance] beginGame];
    
    // Set Model
    self.question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
    
    // Configure View using Model
    [self configureQuestionView];
    [self configureBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Kick off the first question's timer
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)configureQuestionView
{
    self.questionView.question = self.question;
    self.questionView.gamePlayDelegate = self;
    [self.questionView setup];
    self.questionView.type = CSAnimationTypeShake;
    self.questionView.duration = 0.5;
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonPressed:)];
	[self.questionView addGestureRecognizer:self.tapRecognizer];
	self.tapRecognizer.enabled = NO;
    [self.questionView startQuestionEntranceAnimationWithCompletion:
     ^(BOOL finished){}];
}

- (void)configureBackground
{
    self.nextButton.hidden = YES;
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld of %d",(long)[WIBGamePlayManager sharedInstance].questionIndex, NUMBER_OF_QUESTIONS];
}

- (IBAction)nextButtonPressed:(id)sender
{
	self.tapRecognizer.enabled = NO;
	NSLog(@"NextPressed!");
    if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
    {
        [[WIBGamePlayManager sharedInstance] completeGame];        
        [self performSegueWithIdentifier:@"gameCompleteSegue" sender:self];
    }
    else
    {
        [self.questionView startQuestionExitAnimationWithCompletion:
         ^(BOOL finished){
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
                [self.questionView refreshWithQuestion:self.question];
                self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld of %d",(long)[WIBGamePlayManager sharedInstance].questionIndex, NUMBER_OF_QUESTIONS];
                [self.questionView startQuestionEntranceAnimationWithCompletion:
                 ^(BOOL finished){}];
                [self resumeLayer:self.timerBar.layer];
                self.timerLengthConstraint.constant = self.view.frame.size.width;
                [self.timerBar layoutIfNeeded];
                [self startTimer];
                self.nextButton.hidden = YES;
            });
        }];
    }
}

- (void)startTimer
{
    _currSeconds = SECONDS_PER_QUESTION;
    self.startDate = [NSDate date];
    self.timerLengthConstraint.constant = 0;
    [UIView animateWithDuration:5
                     animations:^{
                         [self.timerBar layoutIfNeeded];
                     }];
    if(!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}

- (void)timerFired
{
    if(_currSeconds>1)
    {
        _currSeconds-=1;
    }
    else
    {
        _currSeconds-=1;
        [self.timer invalidate];
        self.timer = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGameQuestionTimeUpNotification object:nil];
        [self.questionView startCanvasAnimation];
        
        if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
        {
            [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
            [self.nextButton sizeToFit];
        }
        //TODO: Kick off "reveal" animation!
    }
}

# pragma mark - WIBGamePlayDelegate
- (void)questionView:(WIBQuestionView *)questionView didSelectOption:(WIBGameOption *)option
{
    [self.timer invalidate];
    self.timer = nil;
    [self pauseLayer:self.timerBar.layer];
    self.question.answerTime = fabs([self.startDate timeIntervalSinceNow]);
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)questionViewDidFinishRevealingAnswer:(WIBQuestionView *)questionView
{
	self.tapRecognizer.enabled = YES;
	
	void (^revealButton)() = ^void() {
        self.nextButton.hidden = NO;
        self.nextButton.transform = CGAffineTransformMakeScale(1.5,1.5);
        if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
        {
            [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
            [self.nextButton sizeToFit];
        }
    };
    [UIView animateWithDuration:0.5 animations:revealButton];
	
    [UIView animateWithDuration:0.5 animations:revealButton completion:^(BOOL finished){
        self.nextButton.transform = CGAffineTransformMakeScale(1.0,1.0);
    }];
}

@end
