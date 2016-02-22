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

@interface WIBGameCompleteTableViewController () <UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *answersCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLevelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelProgressConstraint;

@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@property (weak, nonatomic) NSTimer *scoreLabelTimer;
@property (assign, nonatomic) NSInteger incrementedScore;
@end


@implementation WIBGameCompleteTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _incrementedScore = 0;
    self.streakLabel.hidden = YES;
    
    self.highScoreLabel.alpha = 0.0;
    
    //self.levelLabel.text = [NSString stringWithFormat:@"Level:%ld Points:%ld/1000",[WIBGamePlayManager sharedInstance].level, [WIBGamePlayManager sharedInstance].currentLevelPoints];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scoreLabelTimer = [NSTimer scheduledTimerWithTimeInterval:[WIBGamePlayManager sharedInstance].animationSpeed/100 target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
//    CGFloat progress = [WIBGamePlayManager sharedInstance].currentLevelPoints/POINTS_PER_LEVEL;
//    [self.progressBar setProgress:progress animated:YES duration:1.0];
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
        [self didFinishIncrementingScore];
    }
}

- (void)didFinishIncrementingScore
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

- (void)displayLevelProgress
{
    self.scoreLabel.text = @"";
    //    self.levelLabel.text = ;
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
    return NUMBER_OF_QUESTIONS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    WIBGameQuestion *question = [WIBGamePlayManager sharedInstance].gameRound.gameQuestions[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answer" forIndexPath:indexPath];
    UIImageView *answerImageView = (UIImageView *)[cell viewWithTag:10];
    
    if (question.answeredCorrectly) {
        [answerImageView sd_setImageWithURL:[NSURL URLWithString:question.answer.item.photoURL]];
    } else {
        answerImageView.image = [UIImage imageNamed:@"redX"];
    }
    return cell;
}


@end
