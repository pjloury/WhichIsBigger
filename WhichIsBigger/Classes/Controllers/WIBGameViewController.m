//
//  WIBGameViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameViewController.h"

// Views
#import "WIBPopButton.h"
#import "WIBQuestionView.h"
#import "WIBPopButton.h"
#import "UIView+AutoLayout.h"
#import "WIBOptionView.h"

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
@property (strong, atomic) NSTimer *nextButtonBlinkTimer;
@property (strong, atomic) NSTimer *nextButtonRevealTimer;
@property (strong, atomic) NSDate *startDate;
@property int currSeconds;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerBarWidth;

// Views
@property (nonatomic, strong) IBOutlet WIBQuestionView *questionView;
@property (weak, nonatomic) IBOutlet CSAnimationView *nextButtonParentView;
@property (nonatomic, strong) IBOutlet WIBPopButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *timerBar;
@property (nonatomic, strong) IBOutlet UILabel *questionNumberLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation WIBGameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
    
    // Configure View using Model
    [self configureQuestionView];
    [self configureBackground];
    
    self.navigationItem.hidesBackButton = YES;
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBarTintColor:[WIBGamePlayManager sharedInstance].gameRound.questionType.themeColor];
}

- (void)configureQuestionView
{
    self.questionView.question = self.question;
    self.questionView.gamePlayDelegate = self;
    [self.questionView setup];
    self.questionView.comparsionSymbol.hidden = YES;
	self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextButtonPressed:)];
	[self.questionView addGestureRecognizer:self.tapRecognizer];
	self.tapRecognizer.enabled = NO;
    [self.questionView startQuestionEntranceAnimationWithCompletion:
     ^(BOOL finished){
         [self startTimer];
     }];
}

- (void)configureBackground
{
    self.nextButton.alpha = 0.0;
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld of %d",(long)[WIBGamePlayManager sharedInstance].questionNumber, NUMBER_OF_QUESTIONS];
}

- (IBAction)nextButtonPressed:(id)sender
{
	self.tapRecognizer.enabled = NO;
    [self.timerBar.layer removeAllAnimations];
    [self.nextButtonBlinkTimer invalidate];
    [self.nextButtonRevealTimer invalidate];
    self.nextButton.enabled = NO;
    self.nextButton.alpha = 0.0;
    self.questionView.comparsionSymbol.hidden = YES;
    if([WIBGamePlayManager sharedInstance].questionNumber == NUMBER_OF_QUESTIONS)
    {    
        [[WIBGamePlayManager sharedInstance] endGame];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WIBGameCompleteViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GameCompleteViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self.questionView startQuestionExitAnimationWithCompletion:
         ^(BOOL finished){             
             self.question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
            [self.questionView refreshWithQuestion:self.question];
            self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld of %d",(long)[WIBGamePlayManager sharedInstance].questionNumber, NUMBER_OF_QUESTIONS];
            [self.questionView startQuestionEntranceAnimationWithCompletion:
             ^(BOOL finished){
                 [self startTimer];
             }];
            [self resumeLayer:self.timerBar.layer];
            self.timerBarWidth.constant = 0;
        }];
    }
}

- (void)startTimer
{
    _currSeconds = [WIBGamePlayManager sharedInstance].secondsPerQuestion;
    self.startDate = [NSDate date];
    
    self.timerBarWidth.constant = -self.view.frame.size.width;
    [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].secondsPerQuestion delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){}];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:[WIBGamePlayManager sharedInstance].secondsPerQuestion target:self selector:@selector(timerExpired) userInfo:nil repeats:NO];
    
}

- (void)timerExpired
{
    if (!self.questionView.isGamePlayDisabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGameQuestionTimeUpNotification object:nil];
    }
            
    if([WIBGamePlayManager sharedInstance].questionNumber > NUMBER_OF_QUESTIONS) {
        [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
        [self.nextButton sizeToFit];
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
    // if someone taps too late, don't construe this tap as a "next" tap
    if([WIBGamePlayManager sharedInstance].questionNumber >= NUMBER_OF_QUESTIONS) {
        if (questionView.isGamePlayDisabled) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.tapRecognizer.enabled = YES;
                self.nextButton.enabled = YES;
            });
        }
        else {
            self.tapRecognizer.enabled = YES;
            self.nextButton.enabled = YES;
        }
    }
    else {
        if (questionView.isGamePlayDisabled) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.tapRecognizer.enabled = YES;
            });
        }
        else {
            self.tapRecognizer.enabled = YES;
        }
    }
    [self.nextButtonRevealTimer invalidate];
    if (questionView.isGamePlayDisabled) {
        self.nextButtonRevealTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(revealNext) userInfo:nil repeats:NO];
    } else {
        self.nextButtonRevealTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(revealNext) userInfo:nil repeats:NO];
    }
}

- (void)revealNext
{
    void (^revealButton)() = ^void() {
        self.nextButton.alpha = 1.0;
    };
    
    if([WIBGamePlayManager sharedInstance].questionNumber >= NUMBER_OF_QUESTIONS) {
        [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.1 animations:revealButton completion:^(BOOL finished){
        self.nextButton.enabled = YES;
        if([WIBGamePlayManager sharedInstance].questionNumber > NUMBER_OF_QUESTIONS)
        {
            self.nextButtonParentView.type = CSAnimationTypePop;
        }
        else {
            self.nextButtonParentView.type = CSAnimationTypeFlash;
        }
        self.nextButtonParentView.delay = 0.3;
        self.nextButtonParentView.duration = 0.6;
        
        self.nextButtonBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target: self.nextButtonParentView
                                       selector: @selector(startCanvasAnimation) userInfo: nil repeats: YES];
        
    }];
}

@end
