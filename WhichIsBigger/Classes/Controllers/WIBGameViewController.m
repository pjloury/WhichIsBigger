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
@property (weak, nonatomic) IBOutlet WIBGameView *gameView1;
@property (weak, nonatomic) IBOutlet WIBGameView *gameView2;
@property (strong, nonatomic) UILabel *timerLabel;
@property (strong, atomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *pausePlayButton;
- (IBAction)pressedPausePlay:(id)sender;
@property int currSeconds;

// Model
@property (strong, nonatomic) WIBGameQuestion *question;

// View
@property (nonatomic, strong) WIBQuestionView *questionView;


@end

@implementation WIBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    // Do any additional setup after loading the view, typically from a nib.
    [[WIBGamePlayManager sharedInstance] generateQuestions];
    [self loadQuestion];
    
    UITapGestureRecognizer *gameView1TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameView1Tapped:)];
    [self.gameView1 addGestureRecognizer:gameView1TapGestureRecognizer];
    
    UITapGestureRecognizer *gameView2TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameView2Tapped:)];
    [self.gameView2 addGestureRecognizer:gameView2TapGestureRecognizer];
    
    [self configureBackground];
    [self configureQuestionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadQuestion
{
    if([[WIBGamePlayManager sharedInstance] questionIndexIsInBounds])
    {
        self.question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
        [self.questionView refreshWithQuestion:self.question];
        //[self.questionView setNeedsLayout];
//        [self.gameView1 setupUI:self.question.option1];
//        [self.gameView2 setupUI:self.question.option2];
        [self startTimer];
    }
    else
    {
        WIBGameCompleteViewController *vc = [[WIBGameCompleteViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        //[self performSegueWithIdentifier:@"gameCompleteSegue" sender:self];
    }
}

- (void)configureQuestionView
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    WIBGameQuestion *question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
    
    self.questionView = [[WIBQuestionView alloc] initWithGameQuestion:question];
    self.questionView.delegate = self;
    
    [self.view addSubview:self.questionView];
    [self.questionView ic_pinViewToAllSidesOfSuperViewWithPadding:0];
    
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
        //TODO: Used to reveal answer!!
        [self loadQuestion];
    }
}

- (void)gameView1Tapped:(UITapGestureRecognizer *)recognizer
{
    if (self.question.option1 == self.question.answer)
    {
        NSLog(@"CORRECT ANSWER CHOSEN!");
        self.gameView1.containsCorrectAnswer = YES;
    }
    else
    {
        NSLog(@"INCORRECT ANSWER CHOSEN!");
        self.gameView2.containsCorrectAnswer = NO;
    }
    [self.timer invalidate];
    [self revealAnswer];
}

- (void)gameView2Tapped:(UITapGestureRecognizer *)recognizer
{
    if (self.question.option2 == self.question.answer)
    {
        NSLog(@"CORRECT ANSWER CHOSEN!");
        self.gameView2.containsCorrectAnswer = YES;
    }
    else
    {
        NSLog(@"INCORRECT ANSWER CHOSEN!");
        self.gameView1.containsCorrectAnswer = NO;
    }
    [self.timer invalidate];
    [self revealAnswer];
}

- (WIBGameView *)biggerGameView
{
    if (self.question.option1 == self.question.answer)
    {
        return self.gameView1;
    }
    else
    {
        return self.gameView2;
    }
}

- (WIBGameView *)smallerGameView
{
    if (self.question.option1 == self.question.answer)
    {
        return self.gameView2;
    }
    else
    {
        return self.gameView1;
    }
}

- (void)revealAnswer
{
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.smallerGameView.backgroundColor = [UIColor redColor];
        self.biggerGameView.backgroundColor = [UIColor greenColor];
    } completion:^(BOOL finished){
        if (finished)
            [self loadQuestion];
    }];
}

- (IBAction)next:(id)sender
{
    [self loadQuestion];
}

- (IBAction)pressedPausePlay:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if ([button.titleLabel.text isEqualToString:@"Pause"])
         {
             if(_timer.isValid)
             {
                 [_timer invalidate];
             }
             _timer = nil;
             self.pausePlayButton.titleLabel.text = @"Resume";
         }
    else if ([button.titleLabel.text isEqualToString:@"Resume"])
    {
        [self startTimer];
        self.pausePlayButton.titleLabel.text = @"Pause";
    }
}

# pragma mark - WIBGamePlayDelegate
- (void)questionView:(WIBQuestionView *)questionView didTapNextButton:(UIButton *)nextButton
{
    [self loadQuestion];
}


    

@end
