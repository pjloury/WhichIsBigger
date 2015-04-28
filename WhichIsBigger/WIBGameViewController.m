//
//  ViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "ViewController.h"
#import "WIBImageView.h"
#import "WIBGameQuestion.h"
#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"
#import <Parse/Parse.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic, strong) WIBImageView *imageView;

@end

@implementation ViewController

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
    self.label1.text = question.option1.name;
    self.label2.text = question.option2.name;
}

- (IBAction)next:(id)sender {
    [self loadQuestion];

}

- (void)setupImageView
{
    self.imageView = [WIBImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.imageView];
    [self.view addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]
                                    ]];
}

@end
