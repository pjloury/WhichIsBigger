//
//  ViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "ViewController.h"
#import "WIBOptionView.h"
#import "WIBGameQuestion.h"
#import "WIBGamePlayManager.h"
#import <Parse/Parse.h>
#import "UIView+AutoLayout.h"
#import "UIColor+Additions.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic, strong) WIBOptionView *optionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupOptions];
    [self configureGradientBackground];
    //[self.view setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    // Do any additional setup after loading the view, typically from a nib.
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    [self loadQuestion];
}

- (void)loadQuestion
{
    WIBGameQuestion *question = [WIBGamePlayManager sharedInstance].gameQuestion;
    self.label1.text = question.option1.name;
    self.label2.text = question.option2.name;
}

- (void)setupOptions {
    self.optionView = [[WIBOptionView alloc] initWithGameItem:nil];
    [self.view addSubview:self.optionView];
    [self.optionView ic_centerHorizontallyInSuperView];
    [self.optionView ic_centerVerticallyInSuperView];
    [self.optionView ic_constraintForHeightAttributeEqualtToView:self.view multiplier:.7];
    [self.optionView ic_constraintForWidthAttributeEqualtToView:self.view multiplier:.5];
}

- (void)configureGradientBackground {
    //self.view.backgroundColor = [UIColor sexyRedColor];
    
    CAGradientLayer *gradient = [UIColor gradientLayerWithColor:[UIColor sexyPurpleColor]];
    
    
    
    
    
    
    
    
    
    
    
    
    CGRect frame = self.view.bounds;
    frame.size.height *= 16;
    gradient.frame = frame;
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = 50.0f;
    animation.toValue = @(-self.view.frame.size.height*15);
    animation.repeatCount = INFINITY;
    animation.autoreverses = YES;
    [gradient addAnimation:animation forKey:@"scale1"];
}

@end
