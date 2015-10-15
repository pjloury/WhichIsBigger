//
//  WIBGameCompleteViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/29/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameCompleteViewController.h"
#import "WIBGameViewController.h"
#import "WIBGamePlayManager.h"

// Models
#import "WIBGameQuestion.h"

// Views
#import "WIBPopButton.h"

@interface WIBGameCompleteViewController ()<UICollectionViewDataSource, FBSDKAppInviteDialogDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *answersCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet WIBPopButton *playAgainButton;
@property (weak, nonatomic) IBOutlet WIBPopButton *challengeAFriendButton;
@property (weak, nonatomic) NSTimer *scoreLabelTimer;
@property (assign, nonatomic) NSInteger incrementedScore;

@end

@implementation WIBGameCompleteViewController

- (void)viewDidLoad
{
    self.scoreLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.incrementedScore = 0;
    self.streakLabel.hidden = YES;
    self.scoreLabel.text = @"";
    self.highScoreLabel.hidden = YES;
    self.playAgainButton.enabled = NO;
    self.highScoreLabel.alpha = 0.0;
    
    self.playAgainButton.layer.borderColor = [UIColor lightPurpleColor].CGColor;
    self.challengeAFriendButton.layer.borderColor = [UIColor lightPurpleColor].CGColor;
    self.playAgainButton.layer.borderWidth = 1;
    self.challengeAFriendButton.layer.borderWidth = 1;
}

- (void)incrementScore
{
    if (self.incrementedScore < [WIBGamePlayManager sharedInstance].score)
    {
        self.incrementedScore++;
        self.scoreLabel.text = [NSString stringWithFormat:@"Total Score: %ld",(long)self.incrementedScore];
    }
    else
    {
        [self.scoreLabelTimer invalidate];
        [self didFinishIncrementingScore];
    }
}

- (void)didFinishIncrementingScore
{
    if([WIBGamePlayManager sharedInstance].score == [WIBGamePlayManager sharedInstance].highScore)
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"Total Score: %ld",(long)self.incrementedScore];
        self.highScoreLabel.hidden = NO;
        [self throbHighScoreLabel];
    }
    
    if(([WIBGamePlayManager sharedInstance].currentStreak == [WIBGamePlayManager sharedInstance].longestStreak && [WIBGamePlayManager sharedInstance].currentStreak >= 3) || [WIBGamePlayManager sharedInstance].currentStreak >= 5)
    {
        self.streakLabel.hidden = NO;
        self.streakLabel.text = [NSString stringWithFormat:@"%ld Question Streak!",(long)[WIBGamePlayManager sharedInstance].currentStreak];
    }

    if([WIBGamePlayManager sharedInstance].score == 0)
    {
        self.highScoreLabel.hidden = NO;
        self.highScoreLabel.text = @"LOL!";
        [self throbHighScoreLabel];
    }
        
    self.playAgainButton.enabled = YES;
}

- (void)throbHighScoreLabel
{
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^{
                         self.highScoreLabel.alpha = 1.0;
                     }
                     completion:nil];
}

- (IBAction)didPressPlayAgain:(id)sender
{
    [[WIBGamePlayManager sharedInstance] beginGame];
    [self performSegueWithIdentifier:@"playAgainSegue" sender:self];
}

- (IBAction)didPressChallengeAFriend:(id)sender
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    
    // Should be a link to the app store!
    content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showWithContent:content
                                 delegate:self];

}

/*!
 @abstract Sent to the delegate when the app invite completes without error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
{
    
}
/*!
 @abstract Sent to the delegate when the app invite encounters an error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param error The error.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error;
{
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER_OF_QUESTIONS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WIBGameQuestion *question = [WIBGamePlayManager sharedInstance].gameRound.gameQuestions[indexPath.row];
    NSString *imageName = question.answeredCorrectly ? @"greenCheck" : @"redX";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answer" forIndexPath:indexPath];
    UIImageView *answerImageView = (UIImageView *)[cell viewWithTag:10];
    answerImageView.image = [UIImage imageNamed:imageName];
    return cell;
}

@end
