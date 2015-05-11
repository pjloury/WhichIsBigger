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
        weakSelf.startNewGameButton.enabled = YES;
    }];
}
- (IBAction)didPressNewGame:(id)sender {
    //UINavigationController *nvc = [[UINavigationController alloc] init];
    //[nvc pushViewController:[[WIBGameViewController alloc] init ]animated:YES];
    [self presentViewController:[[WIBGameViewController alloc] init] animated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

@end
