//
//  ViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "ViewController.h"
#import "WIBImageView.h"
#import <Parse/Parse.h>

>>>>>>> 77adb2a8f27ab3eed9d7625ce9140aa2ce6a38c9

@interface ViewController ()

@property (nonatomic, strong) WIBImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageView];
    [self.view setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    // Do any additional setup after loading the view, typically from a nib.
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupImageView {
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
