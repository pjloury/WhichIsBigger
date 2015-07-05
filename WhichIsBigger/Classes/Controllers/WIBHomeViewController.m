//
//  WIBHomeViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/23/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBHomeViewController.h"
#import "WIBGameViewController.h"
#import "WIBGamePlayManager.h"
#import "WIBNetworkManager.h"

@interface WIBHomeViewController()
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@end

@implementation WIBHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.startNewGameButton.enabled = NO;
    __weak WIBHomeViewController *weakSelf = self;
    [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(),
        ^{
            weakSelf.startNewGameButton.enabled = YES;
        });
    }];
}
- (IBAction)didPressNewGameButton:(id)sender
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"newGameSegue" sender:self];
    });
}

@end
