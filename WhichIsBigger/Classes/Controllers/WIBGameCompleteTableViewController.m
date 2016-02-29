//
//  WIBGameCompleteTableViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/21/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameCompleteTableViewController.h"
#import "WIBGamePlayManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

// Models
#import "WIBGameQuestion.h"

// Views
#import "WIBProgressView.h"
#import "WIBAchievementCollectionViewCell.h"

// View Models
#import "WIBAchievementDataSource.h"

@interface WIBGameCompleteTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate, GKGameCenterControllerDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *answersCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet WIBProgressView *progressMeterSuperView;

@property (weak, nonatomic) NSTimer *scoreLabelTimer;
@property (assign, nonatomic) NSInteger incrementedScore;

@property (weak, nonatomic) NSTimer *answerTimer;
@property NSInteger cellNumber;

@property (weak, nonatomic) IBOutlet UICollectionView *achievementsCollectionView;
@property WIBAchievementDataSource *achievementDataSource;

@end


@implementation WIBGameCompleteTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.achievementDataSource = [[WIBAchievementDataSource alloc] init];
    self.achievementsCollectionView.dataSource = self.achievementDataSource;
    _incrementedScore = 0;
    self.streakLabel.hidden = YES;
    self.highScoreLabel.alpha = 0.0;
    self.tableView.allowsSelection = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.answerTimer = [NSTimer scheduledTimerWithTimeInterval:[WIBGamePlayManager sharedInstance].animationSpeed/2 target:self selector:@selector(revealCell) userInfo:nil repeats:YES];
}

- (void)revealCell
{
    self.cellNumber ++;
    [self.answersCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.cellNumber-1 inSection:0]]];
    if (self.cellNumber == NUMBER_OF_QUESTIONS) {
        [self.scoreLabelTimer invalidate];
        self.scoreLabelTimer = [NSTimer scheduledTimerWithTimeInterval:[WIBGamePlayManager sharedInstance].animationSpeed/100 target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
    }
}

- (void)incrementScore
{
    if (_incrementedScore < [WIBGamePlayManager sharedInstance].score)
    {
        _incrementedScore++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)_incrementedScore];
    }
    else
    {
        [self.scoreLabelTimer invalidate];
        
        CGFloat currentPercentage = (CGFloat) [[WIBGamePlayManager sharedInstance] currentLevelPoints]/ (CGFloat) POINTS_PER_LEVEL;
        NSLog(@"%f",currentPercentage);
        currentPercentage = .9;
        [self.progressMeterSuperView setProgress:currentPercentage animated:YES completion:^(){
            [self didFinishProgressUpdate];
        }];
    }
}

- (void)didFinishProgressUpdate
{
    if([WIBGamePlayManager sharedInstance].score == [WIBGamePlayManager sharedInstance].highScore)
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)_incrementedScore];
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
}

- (void)displayAchievements
{
    
    self.highScoreLabel.hidden = YES;
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

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellNumber;
    //return NUMBER_OF_QUESTIONS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WIBGameQuestion *question = [WIBGamePlayManager sharedInstance].gameRound.gameQuestions[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answer" forIndexPath:indexPath];
    UIImageView *answerImageView = (UIImageView *)[cell viewWithTag:10];
    UILabel *answerLabel = (UILabel *)[cell viewWithTag:11];
    
    answerImageView.layer.cornerRadius = 4.0f;
    answerImageView.layer.borderWidth = 2.0f;
    if (question.answeredCorrectly) {
        answerImageView.layer.borderColor = [UIColor greenColor].CGColor;
        [answerImageView sd_setImageWithURL:[NSURL URLWithString:question.answer.item.photoURL] placeholderImage:[UIImage placeholder]];
        answerLabel.text = [NSString stringWithFormat:@"%ld", (long)question.points];
        answerLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        answerImageView.layer.borderColor = [UIColor clearColor].CGColor;
        answerImageView.image = [UIImage imageNamed:@"redX"];
        answerLabel.text = @"";
    }
    return cell;
}

#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.achievementsCollectionView] && [GKLocalPlayer localPlayer].isAuthenticated){
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        WIBAchievementCollectionViewCell *cell = (WIBAchievementCollectionViewCell *)[self.achievementDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
        gcViewController.leaderboardIdentifier = cell.descriptor;
        [self presentViewController:gcViewController animated:YES completion:nil];
    }
}

#pragma mark - Game Center Delegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
