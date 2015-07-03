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
#import "WIBParseManager.h"

@interface WIBHomeViewController()
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@end

@implementation WIBHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.startNewGameButton.enabled = NO;
    __weak WIBHomeViewController *weakSelf = self;
    [[WIBParseManager sharedInstance] generateDataModelWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(),
        ^{
            weakSelf.startNewGameButton.enabled = YES;
        });
    }];
}
- (IBAction)didPressNewGame:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    WIBGameViewController *gameViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    
    [self presentViewController:gameViewController animated:NO completion:nil];
}

@end
