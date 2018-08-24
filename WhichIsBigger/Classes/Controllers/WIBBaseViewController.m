//
//  WIBBaseViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/24/18.
//  Copyright © 2018 Angry Tortoise Productions. All rights reserved.
//

#import "WIBBaseViewController.h"

@interface WIBBaseViewController ()

@end

@implementation WIBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleNavBar];
}

- (void)styleNavBar {
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBarTintColor:[UIColor darkPurpleColor]];
    
    UILabel *whichIsBigger = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(nc.navigationBar.frame))];
    self.navigationItem.titleView = whichIsBigger;
    
    whichIsBigger.font = [UIFont fontWithName:@"RifficFree-Bold" size:24];
    whichIsBigger.textColor = [UIColor whiteColor];
    whichIsBigger.text = @"WHICH IS BIGGER ?";
    whichIsBigger.textAlignment = NSTextAlignmentCenter;
}

@end

