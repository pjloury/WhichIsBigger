//
//  WIBHomeViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/23/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBHomeViewController.h"
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

@end
