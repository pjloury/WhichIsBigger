//
//  WIBDismissSegue.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/21/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBDismissSegue.h"

@implementation WIBDismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
