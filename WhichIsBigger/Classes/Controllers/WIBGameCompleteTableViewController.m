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
#import "KTCenterFlowLayout.h"
#import "WIBProgressView.h"
#import "WIBAchievementCollectionViewCell.h"

// View Models
#import "WIBAchievementDataSource.h"

@interface WIBGameCompleteTableViewController () <UICollectionViewDataSource, UICollectionViewDelegate, GKGameCenterControllerDelegate, WIBProgressViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *answersCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDescriptionlabel;

@property (weak, nonatomic) IBOutlet UIView *leftLevelView;
@property (weak, nonatomic) IBOutlet UIView *currentLevelBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *currentLevelImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;

@property (weak, nonatomic) IBOutlet UIView *rightLevelView;
@property (weak, nonatomic) IBOutlet UIView *goalLevelBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *goalLevelImageView;
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

- (void)viewDidLoad
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setPreviousProgress];
    
    self.tableView.backgroundColor = [UIColor faintPurpleColor];
    
    self.answersCollectionView.delegate = self;
    
    self.achievementDataSource = [[WIBAchievementDataSource alloc] init];
    self.achievementsCollectionView.dataSource = self.achievementDataSource;
    KTCenterFlowLayout *achievementLayout = [KTCenterFlowLayout new];
    achievementLayout.minimumInteritemSpacing = 20.f;
    achievementLayout.minimumLineSpacing = 10.f;
    achievementLayout.itemSize = CGSizeMake(85, 80);
    self.achievementsCollectionView.collectionViewLayout = achievementLayout;
    
    _incrementedScore = 0;
    self.progressMeterSuperView.delegate = self;
    
    self.scoreLabel.alpha = 0;
    self.scoreDescriptionlabel.alpha = 0;
    
    self.streakLabel.hidden = YES;
    self.highScoreLabel.alpha = 0.0;
    self.tableView.allowsSelection = NO;
    
    WIBQuestionType *type = [[[WIBGamePlayManager sharedInstance] gameRound] questionType];
    
    self.currentLevelBackgroundView.backgroundColor = type.backgroundColor;
    [self.currentLevelImageView sd_setImageWithURL:[NSURL URLWithString:type.image.url] completed:^
                                 (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                     image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                                     self.currentLevelImageView.image = image;
                                 }];
    self.currentLevelImageView.tintColor = type.tintColor;
    self.currentLevelBackgroundView.layer.cornerRadius = 5.0f;
    
    NSInteger previousLevel = [WIBGamePlayManager sharedInstance].previousLevel;
    self.currentLevelLabel.text = [NSString stringWithFormat:@"LEVEL %ld", (long)previousLevel];
    self.goalLevelLabel.text = [NSString stringWithFormat:@"LEVEL %d",     (previousLevel + 1)];
  
    UIBezierPath *currentLevelShadowPath = [UIBezierPath bezierPathWithRect:    self.currentLevelBackgroundView.bounds];
    self.currentLevelBackgroundView.layer.masksToBounds = NO;
    self.currentLevelBackgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.currentLevelBackgroundView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.currentLevelBackgroundView.layer.shadowOpacity = 0.5f;
    self.currentLevelBackgroundView.layer.shadowPath = currentLevelShadowPath.CGPath;
    
    UIBezierPath *goalLevelShadowPath = [UIBezierPath bezierPathWithRect:    self.goalLevelBackgroundView.bounds];
    self.goalLevelBackgroundView.layer.masksToBounds = NO;
    self.goalLevelBackgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.goalLevelBackgroundView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.goalLevelBackgroundView.layer.shadowOpacity = 0.5f;
    self.goalLevelBackgroundView.layer.shadowPath = goalLevelShadowPath.CGPath;
    self.goalLevelBackgroundView.layer.cornerRadius = 5.0f;
    
    if ([WIBGamePlayManager sharedInstance].availableQuestionTypes.count == [WIBGamePlayManager sharedInstance].questionTypes.count) {
        self.goalLevelImageView.image = [UIImage trophy];
        self.goalLevelImageView.tintColor = [UIColor sexyAmberColor];
        self.goalLevelBackgroundView.backgroundColor = [UIColor colorForLevel:[WIBGamePlayManager sharedInstance].previousLevel];
    } else {
        self.goalLevelImageView.image =  [UIImage imageNamed:@"smallQuestionMark"];
        self.goalLevelBackgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.answerTimer = [NSTimer scheduledTimerWithTimeInterval:[WIBGamePlayManager sharedInstance].animationSpeed/2 target:self selector:@selector(revealCell) userInfo:nil repeats:YES];
}

- (void)setPreviousProgress
{
    CGFloat previousPoints = ([[WIBGamePlayManager sharedInstance] currentLevelPoints] - [WIBGamePlayManager sharedInstance].score);
    CGFloat previousPercentage = (CGFloat) previousPoints/(CGFloat) [WIBGamePlayManager sharedInstance].pointsPerLevel;
    NSLog(@"PREVIOUS: %f",previousPercentage);
    //previousPercentage = .8;
    [self.progressMeterSuperView setProgress:previousPercentage animated:NO completion:nil];
}

- (void)revealCell
{
    self.cellNumber ++;
    [self.answersCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.cellNumber-1 inSection:0]]];
    if (self.cellNumber == NUMBER_OF_QUESTIONS) {
        [self.answerTimer invalidate];
        KTCenterFlowLayout *answerLayout = [KTCenterFlowLayout new];
        answerLayout.minimumInteritemSpacing = 5.0f;
        answerLayout.minimumLineSpacing = 10.f;
        answerLayout.itemSize = CGSizeMake(55, 65);
        self.answersCollectionView.collectionViewLayout = answerLayout;
        [self revealScoreAndProgress];
    }
}

- (void)revealScoreAndProgress
{
    self.scoreLabelTimer = [NSTimer scheduledTimerWithTimeInterval:[WIBGamePlayManager sharedInstance].animationSpeed/125 target:self                                                             selector:@selector(incrementScore) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scoreDescriptionlabel.alpha = 1.0;
        self.scoreLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    CGFloat currentPercentage = (CGFloat) [[WIBGamePlayManager sharedInstance] currentLevelPoints]/ (CGFloat) [WIBGamePlayManager sharedInstance].pointsPerLevel;
    NSLog(@"CURRENT: %f",currentPercentage);
    //currentPercentage = .2;
    [self.progressMeterSuperView setProgress:currentPercentage animated:YES completion:^(){
        [self didFinishProgressUpdate];
    }];
}

- (void)incrementScore
{
    if (_incrementedScore < [WIBGamePlayManager sharedInstance].score) {
        _incrementedScore++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)_incrementedScore];
    }
    else {
        [self.scoreLabelTimer invalidate];
    }
}

- (void)didFinishProgressUpdate
{
    if([WIBGamePlayManager sharedInstance].score == [WIBGamePlayManager sharedInstance].highScore) {
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)_incrementedScore];
        self.highScoreLabel.hidden = NO;
        [self throbHighScoreLabel];
    }
    
    if(([WIBGamePlayManager sharedInstance].currentStreak == [WIBGamePlayManager sharedInstance].longestStreak && [WIBGamePlayManager sharedInstance].currentStreak >= 3) || [WIBGamePlayManager sharedInstance].currentStreak >= 5) {
        self.streakLabel.hidden = NO;
        self.streakLabel.text = [NSString stringWithFormat:@"%ld Question Streak!",(long)[WIBGamePlayManager sharedInstance].currentStreak];
    }
    
    if([WIBGamePlayManager sharedInstance].score == 0) {
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

#pragma mark - UICollectionViewDataSource
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
    else if ([collectionView isEqual:self.achievementsCollectionView] && ![GKLocalPlayer localPlayer].isAuthenticated){
        [[WIBGamePlayManager sharedInstance] authenticateGameKitUser];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.answersCollectionView]) {
        CGFloat proportionalWidth = (collectionView.frame.size.width - 20) / NUMBER_OF_QUESTIONS;
        return CGSizeMake(proportionalWidth, 65);
    }
    else if ([collectionView isEqual:self.achievementsCollectionView]) {
        CGFloat proportionalWidth = (collectionView.frame.size.width - 50) / 3;
        return CGSizeMake(proportionalWidth, 80);
    }
    else {
        return CGSizeZero;
    }
}

#pragma mark - Game Center Delegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WIBProgressViewDelegate
// Started with L1, L2
// progress did surpass, and changed to L2, L2. Left image stayed the same while Right changed to Orange and Purple

- (void)progressViewDidSurpassFullProgress:(WIBProgressView *)progressView {
    [UIView animateWithDuration:0.25 animations:^(void){
        self.leftLevelView.alpha = 0.0;
        self.rightLevelView.alpha = 0.0; }
                    completion:^(BOOL finished) {
                        self.currentLevelLabel.text = [NSString stringWithFormat:@"LEVEL %ld",(long)[WIBGamePlayManager sharedInstance].level];
                        // If something was just unlocked, foreshadow it
                        if ([WIBGamePlayManager sharedInstance].unlockedQuestionType) {
                            self.currentLevelImageView.image = [UIImage placeholder];
                            self.currentLevelImageView.tintColor = [WIBGamePlayManager sharedInstance].unlockedQuestionType.tintColor;
                            self.currentLevelBackgroundView.backgroundColor = [WIBGamePlayManager sharedInstance].unlockedQuestionType.backgroundColor;
                            self.goalLevelImageView.tintColor = [UIColor lightPurpleColor];
                            self.goalLevelBackgroundView.backgroundColor = [UIColor whiteColor];
                        } else {
                            self.goalLevelBackgroundView.backgroundColor = [UIColor colorForLevel:[WIBGamePlayManager sharedInstance].level];
                            self.goalLevelImageView.tintColor = [UIColor sexyAmberColor];
                        }
                        self.goalLevelLabel.text = [NSString stringWithFormat:@"LEVEL %ld",([WIBGamePlayManager sharedInstance].level+1)];
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            self.leftLevelView.alpha = 1.0;
                            self.rightLevelView.alpha = 1.0;
                        } completion:nil];
    }];
}

@end
