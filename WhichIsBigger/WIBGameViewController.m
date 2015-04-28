//
//  WIBGameViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameViewController.h"

#import "WIBGameView.h"
#import "WIBGameQuestion.h"
#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"
#import <Parse/Parse.h>

@interface WIBGameViewController ()
@property (weak, nonatomic) IBOutlet WIBGameView *gameView1;
@property (weak, nonatomic) IBOutlet WIBGameView *gameView2;


@end

@implementation WIBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageView];
    [self.view setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    // Do any additional setup after loading the view, typically from a nib.
    [[WIBGamePlayManager sharedInstance] generateQuestions];
    
    [self loadQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadQuestion
{
    WIBGameQuestion *question = [[WIBGamePlayManager sharedInstance] nextGameQuestion];
    
    self.gameView1 = [WIBGameView initWithGameOption:question.option1];
    self.gameView1 = [WIBGameView initWithGameOption:question.option1];
}

- (IBAction)next:(id)sender {
    [self loadQuestion];

}



@end
