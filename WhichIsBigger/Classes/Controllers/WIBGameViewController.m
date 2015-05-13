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
@property (strong, nonatomic) UILabel *timerLabel;
@property (strong, atomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *pausePlayButton;
- (IBAction)pressedPausePlay:(id)sender;

// Model
@property (strong, nonatomic) WIBGameQuestion *question;
@property int currSeconds;

// Views
@property (nonatomic, strong) WIBQuestionView *questionView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *questionNumberLabel;

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
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.questionView = [[WIBQuestionView alloc] initWithGameQuestion:self.question];
    self.questionView.delegate = self;
    
    [self.view addSubview:self.questionView];
    [self.questionView ic_pinViewToAllSidesOfSuperViewWithPadding:75];
    
    self.timerLabel = [UILabel new];
    self.timerLabel.frame = CGRectMake(50,50,50,50);
    self.timerLabel.text = @"10";
    [self.view insertSubview:self.timerLabel aboveSubview:self.questionView];
}

- (void)configureBackground
{
    CAGradientLayer *gradient = [UIColor gradientLayerWithColor:[UIColor sexyRedColor]];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.nextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"next" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.nextButton sizeToFit];
    self.nextButton.center = self.view.center;
    //self.nextButton.hidden = YES;
    [self.view insertSubview:self.nextButton aboveSubview:self.questionView];
    
    self.questionNumberLabel =  [UILabel new];
    self.questionNumberLabel.frame = CGRectMake(0,100,100,50);
    self.questionNumberLabel.text = @"1";
    [self.view insertSubview:self.questionNumberLabel aboveSubview:self.questionView];
}

- (void)nextButtonPressed:(id)sender
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
        //self.nextButton.hidden = YES;
    }    
}

- (void)startTimer
{
    _currSeconds = SECONDS_PER_QUESTION;
    [self.timerLabel setText:[NSString stringWithFormat:@"%d",_currSeconds]];
    if(!self.timer)
    {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}

- (void)timerFired
{
    if(_currSeconds>0)
    {
        _currSeconds-=1;
        [self.timerLabel setText:[NSString stringWithFormat:@"%d",_currSeconds]];
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
        self.nextButton.hidden = NO;
        if([WIBGamePlayManager sharedInstance].questionIndex == NUMBER_OF_QUESTIONS)
        {
            [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
            [self.nextButton sizeToFit];
        }
        //TODO: Used to reveal answer!!
    }
}

@end
