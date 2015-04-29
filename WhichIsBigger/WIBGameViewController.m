//
//  WIBGameViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameViewController.h"

#import "WIBGameView.h"
#import "WIBQuestionView.h"
#import "WIBGameQuestion.h"
#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"
#import "UIView+AutoLayout.h"
#import "UIColor+Additions.h"
#import <Parse/Parse.h>

@interface WIBGameViewController ()

@property (weak, nonatomic) IBOutlet WIBGameView *gameView1;
@property (weak, nonatomic) IBOutlet WIBGameView *gameView2;

@property (nonatomic, strong) WIBQuestionView *questionView;


@end

@implementation WIBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[WIBGamePlayManager sharedInstance] generateQuestions];
    
    [self configureBackground];
    [self configureOptionViews];
}

- (void)loadQuestion
{
    WIBGameQuestion *question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];   
    [self.gameView1 setupUI:question.option1];
    [self.gameView2 setupUI:question.option2];
}

- (IBAction)next:(id)sender {
    [self loadQuestion];
}

- (void)configureOptionViews {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    WIBGameQuestion *question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
    
    self.questionView = [[WIBQuestionView alloc] initWithGameQuestion:question];
    
    [self.view addSubview:self.questionView];
    [self.questionView ic_pinViewToAllSidesOfSuperViewWithPadding:0];
}

- (void)configureBackground {
    CAGradientLayer *gradient = [UIColor gradientLayerWithColor:[UIColor sexyRedColor]];
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
}



@end
