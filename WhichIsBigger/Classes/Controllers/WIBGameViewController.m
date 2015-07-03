//
//  WIBGameViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameViewController.h"

//Deprecated
#import "WIBGameView.h"
#import "WIBGameItem.h"

// Views
#import "WIBQuestionView.h"
#import "UIView+AutoLayout.h"
#import "UIColor+Additions.h"

// Models
#import "WIBGameQuestion.h"

// Controller
#import "WIBGameCompleteViewController.h"

// Managers
#import "WIBGamePlayManager.h"

// Frameworks
#import <Parse/Parse.h>

// Constants
#import "WIBConstants.h"

@interface WIBGameViewController ()

// Deprecated

@property (strong, atomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *pausePlayButton;
- (IBAction)pressedPausePlay:(id)sender;

// Model
@property (strong, nonatomic) WIBGameQuestion *question;
@property int currSeconds;

// Views
@property (nonatomic, strong) IBOutlet WIBQuestionView *questionView;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) IBOutlet UILabel *questionNumberLabel;

@end

@implementation WIBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    // Do any additional setup after loading the view, typically from a nib.
}

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
    
    // Kick off the first question's timer
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureQuestionView
{
    self.questionView.question = self.question;
    self.questionView.delegate = self;
    [self.questionView setup];
    
    self.timerLabel.text = @"10";
    [self.view bringSubviewToFront:self.timerLabel];
}

- (void)configureBackground
{
    self.nextButton.hidden = YES;
    self.questionNumberLabel.text = @"1";
}

- (IBAction)nextButtonPressed:(id)sender
{
    NSLog(@"NextPressed!");
    if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
    {
        [[WIBGamePlayManager sharedInstance] completeGame];
        WIBGameCompleteViewController *vc = [[WIBGameCompleteViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        self.question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
        [self.questionView refreshWithQuestion:self.question];
        self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld",[WIBGamePlayManager sharedInstance].questionIndex];
        [self startTimer];
        self.nextButton.hidden = YES;
    }
}

- (void)startTimer
{
    _currSeconds = SECONDS_PER_QUESTION;
    self.timerLabel.hidden = NO;
    [self.timerLabel setText:[NSString stringWithFormat:@"%d",_currSeconds]];
    if(!self.timer)
    {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}

- (void)timerFired
{
    if(_currSeconds>1)
    {
        _currSeconds-=1;
        [self.timerLabel setText:[NSString stringWithFormat:@"%d",_currSeconds]];
    }
    else
    {
        _currSeconds-=1;
        [self.timerLabel setText:[NSString stringWithFormat:@"%d",_currSeconds]];
        
        [self.timer invalidate];
        self.timer = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGameQuestionTimeUpNotification object:nil];
        
        if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
        {
            [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
            [self.nextButton sizeToFit];
        }
        //TODO: Used to reveal answer!!
    }
}

# pragma mark - WIBGamePlayDelegate
- (void)questionView:(WIBQuestionView *)questionView didSelectOption:(WIBGameOption *)option
{
    [self.timer invalidate];
    self.timer = nil;
    self.timerLabel.hidden = YES;
}


- (void)questionViewDidFinishRevealingAnswer:(WIBQuestionView *)questionView
{
    self.nextButton.hidden = NO;
    if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
    {
        [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
        [self.nextButton sizeToFit];
    }
}

@end
