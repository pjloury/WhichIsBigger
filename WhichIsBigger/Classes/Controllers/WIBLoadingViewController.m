//
//  WIBLoadingViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/19/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBLoadingViewController.h"
#import "WIBGamePlayManager.h"
#import "WIBGameViewController.h"
#import "WIBNetworkManager.h"

const static double kIdealWaitTime = 1.0;

@interface WIBLoadingViewController ()
@property (weak, nonatomic) IBOutlet CSAnimationView *animationView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingQuestionMarkView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *clarifyingLabel;

@property BOOL exiting;
@property (weak, nonatomic) NSDate *startDate;
@property (nonatomic) BOOL *stopThat;

@end

@implementation WIBLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![WIBNetworkManager sharedInstance].groupDownloadComplete) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupImageDownloadDidComplete:) name:kGroupImageDownloadCompleteNotification object:nil];
    } else {
        [self groupImageDownloadDidComplete: nil];
    }
    self.navigationItem.hidesBackButton = YES;
    self.startDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.categoryLabel.text = [WIBGamePlayManager sharedInstance].gameRound.questionType.questionString;
    self.categoryLabel.alpha = 0.0;
    
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBarTintColor:[WIBGamePlayManager sharedInstance].gameRound.questionType.themeColor];
    self.categoryLabel.textColor = [[[[WIBGamePlayManager sharedInstance] gameRound] questionType] tintColor];
    self.clarifyingLabel.text = [NSString stringWithFormat: @"Loading %@...", [WIBGamePlayManager sharedInstance].gameRound.questionType.clarifyingString];
    
    self.shimmeringView.contentView = self.loadingQuestionMarkView;
    self.shimmeringView.shimmering = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)groupImageDownloadDidComplete:(NSNotification *)note
{
    NSTimeInterval timeElapsed = [self.startDate timeIntervalSinceReferenceDate];
    if (timeElapsed > kIdealWaitTime) {
        [self categoryEntranceAnimation];
    }
    else {
        double extraWaitTime = kIdealWaitTime - timeElapsed;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, extraWaitTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // Double notification?
            if (_stopThat == NO) {
                _stopThat = YES;
                [self categoryEntranceAnimation];
            }
        });
    }
}

- (void)categoryEntranceAnimation
{
    if (!self.exiting) {
        self.exiting = YES;
        self.categoryLabel.transform = CGAffineTransformMakeScale(2, 2);
        self.categoryLabel.alpha = 0;
        [UIView animateKeyframesWithDuration:0.75 delay:0.0 options:0 animations:^{
            // End
            self.categoryLabel.transform = CGAffineTransformMakeScale(1, 1);
            self.categoryLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [self exitAnimation];
        }];
    }
}

- (void)exitAnimation
{
    // Start
    [UIView animateKeyframesWithDuration:0.5 delay:1.0 options:0 animations:^{
        // End
        self.view.transform = CGAffineTransformMakeScale(3.0, 3.0);
        self.shimmeringView.alpha = 0;
        self.categoryLabel.alpha = 0;
    } completion:^(BOOL finished) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WIBGameViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self.navigationController pushViewController:vc animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
        });
    }];
}

@end
