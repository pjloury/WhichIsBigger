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

@interface WIBGameCompleteViewController ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *answersCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet WIBPopButton *playAgainButton;
@property (weak, nonatomic) NSTimer *scoreLabelTimer;
@property (assign, nonatomic) NSInteger incrementedScore;

@end

@implementation WIBGameCompleteViewController

- (void)viewDidLoad
{
    self.incrementedScore = 0;
    self.streakLabel.hidden = YES;
    self.highScoreLabel.hidden = YES;
    self.scoreLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(incrementScore) userInfo:nil repeats:YES];
    self.highScoreLabel.alpha = 0.0;
}


- (void)incrementScore
{
    if (self.incrementedScore <= [WIBGamePlayManager sharedInstance].score)
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"Total Score: %ld",(long)self.incrementedScore];
        self.incrementedScore++;
    }
    else
    {
        [self.scoreLabelTimer invalidate];

        if([WIBGamePlayManager sharedInstance].score == [WIBGamePlayManager sharedInstance].highScore)
        {
            self.scoreLabel.text = [NSString stringWithFormat:@"Total Score: %ld",(long)self.incrementedScore];
            self.highScoreLabel.hidden = NO;
            [self fadeHighScoreLabel];
        }
        
        if([WIBGamePlayManager sharedInstance].currentStreak == [WIBGamePlayManager sharedInstance].longestStreak || [WIBGamePlayManager sharedInstance].currentStreak >= 5)
        {
            self.streakLabel.hidden = NO;
            self.streakLabel.text = [NSString stringWithFormat:@"%ld Question Streak!",(long)[WIBGamePlayManager sharedInstance].currentStreak];
        }
    }
}

- (void)fadeHighScoreLabel
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
    WIBGameQuestion *question = [WIBGamePlayManager sharedInstance].gameQuestions[indexPath.row];
    NSString *imageName = question.answeredCorrectly ? @"greenCheck" : @"redX";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answer" forIndexPath:indexPath];
    UIImageView *answerImageView = (UIImageView *)[cell viewWithTag:10];
    answerImageView.image = [UIImage imageNamed:imageName];
    return cell;
}

@end
