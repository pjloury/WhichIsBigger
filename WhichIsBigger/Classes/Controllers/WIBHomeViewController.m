//
//  WIBHomeViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/23/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBAdManager.h"
#import "WIBHomeViewController.h"
#import "WIBGameViewController.h"
#import "WIBGamePlayManager.h"
#import "WIBNetworkManager.h"
#import "WIBLoginViewController.h"
#import "WIBGameCompleteViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import Firebase;

#import "WIBQuestionType.h"
#import "WIBQuestionTypeCell.h"
#import <Crashlytics/Crashlytics.h>


@interface WIBHomeViewController()<PFLogInViewControllerDelegate, GADInterstitialDelegate, GKGameCenterControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;

@end

@implementation WIBHomeViewController

# pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categoriesCollectionView.userInteractionEnabled = NO;
    
    NSLog(@"======================== BEFORE CONFIG NETWORK CALLS");
    [[WIBNetworkManager sharedInstance] getConfigurationWithCompletion:^{
        NSLog(@"======================== CONFIG RECEIVED");
        [[WIBNetworkManager sharedInstance] getCategoriesWithCompletion:^{
            NSLog(@"======================== CATEGORIES RECEIVED");
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               NSLog(@"======================== RELOADING CATEGORY COLLECTION VIEW");
                               [self.categoriesCollectionView reloadData];
                               [self.categoriesCollectionView layoutIfNeeded];
                               [self.categoriesCollectionView flashScrollIndicators];
                               
                               [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
                                   NSLog(@"======================== DATA MODEL COMPLETE");
                                   dispatch_async(dispatch_get_main_queue(),
                                                  ^{
                                                      self.categoriesCollectionView.userInteractionEnabled = YES;
                                                  });
                               }];
                           });
        }];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPressHighScoresButton:) name:@"GameCenterDidFinishAuthentication" object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(showLaunchAdIfApplicable)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[WIBAdManager sharedInstance] loadGADInterstitial];
    [WIBAdManager sharedInstance].interstitial.delegate = self;
    [super viewWillAppear:animated];
    self.highScoresButton.layer.cornerRadius = 6;
    self.startNewGameButton.layer.cornerRadius = 6;
    [self.categoriesCollectionView reloadData];
    self.totalPointsLabel.text = [NSString stringWithFormat:@"%ld pts", (long)[WIBGamePlayManager sharedInstance].lifeTimeScore];
}

# pragma mark - Ads

- (BOOL)shouldShowNewRoundAd {
    BOOL shouldShowNewRoundAd = NO;
    NSInteger newRoundCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newRoundCount"] integerValue];
    newRoundCount = newRoundCount + 1;
    if (newRoundCount % 4 == 0) shouldShowNewRoundAd = YES;
    [[NSUserDefaults standardUserDefaults] setObject: @(newRoundCount) forKey: @"newRoundCount"];
    return shouldShowNewRoundAd;
}

- (BOOL)shouldShowLaunchAd {
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLaunchAdDate"];
    if (!startDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastLaunchAdDate"];
        return YES;
    } else {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:startDate
                                                              toDate:[NSDate date]
                                                             options:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastLaunchAdDate"];
        return (components.day > 1);
    }
}

- (void)showLaunchAdIfApplicable {
    if ([WIBAdManager sharedInstance].interstitial.isReady && [self shouldShowLaunchAd] && ![WIBAdManager sharedInstance].interstitial.hasBeenUsed) {
        [[WIBAdManager sharedInstance].interstitial presentFromRootViewController: self];
        [WIBAdManager sharedInstance].adType = kLaunchAd;
    }
}

# pragma mark - Crashlytics

- (void)addCrashButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 50, 100, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(crashButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}

# pragma mark - Interactions

- (IBAction)didPressHowToPlayButton:(id)sender
{
    [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
}

- (IBAction)didPressHighScoresButton:(id)sender
{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = @"highScore";
        [self presentViewController:gcViewController animated:YES completion:nil];
    } else {
        [[WIBGamePlayManager sharedInstance] authenticateGameKitUser];
    }
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[WIBGamePlayManager sharedInstance] questionTypes] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WIBQuestionTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"questionTypeCell" forIndexPath:indexPath];
    cell.clipsToBounds = NO;
    
    WIBQuestionType *type = [[WIBGamePlayManager sharedInstance] questionTypes][indexPath.row];
    
    if ([[WIBGamePlayManager sharedInstance].availableQuestionTypes containsObject:type]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:type.imageURL] completed:^
        (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.imageView.image = image;
        }];
        cell.label.text = type.title;
        cell.imageViewContainer.backgroundColor = type.backgroundColor;
        cell.imageView.tintColor = type.tintColor;
    } else {
        UIImage *image = [UIImage imageNamed:@"smallQuestionMark"];
        cell.imageView.image = image;
        cell.label.text = [NSString stringWithFormat:@"LEVEL %ld", (indexPath.item +1)];
        cell.imageViewContainer.backgroundColor = [UIColor whiteColor];
    }
    
    cell.label.textColor = [UIColor grayColor];
    cell.imageViewContainer.layer.cornerRadius = 8.0;
    cell.imageViewContainer.layer.masksToBounds = NO;
    cell.imageViewContainer.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.imageViewContainer.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    cell.imageViewContainer.layer.shadowOpacity = 0.5f;
    
    cell.animationView.type = CSAnimationTypeShake;
    cell.animationView.duration = 2.0;
    
    return cell;
}

# pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WIBQuestionType *type = [[WIBGamePlayManager sharedInstance] questionTypes][indexPath.row];
    if ([[WIBGamePlayManager sharedInstance].availableQuestionTypes containsObject:type]) {
        [[WIBGamePlayManager sharedInstance] beginRoundForType:type];
        if (type == [WIBGamePlayManager sharedInstance].unlockedQuestionType) {
            [self performSegueWithIdentifier:@"homeToCategoryUnlock" sender:self];
        } else {
            if ([WIBAdManager sharedInstance].interstitial.isReady && [self shouldShowNewRoundAd] && ![WIBAdManager sharedInstance].interstitial.hasBeenUsed) {
                [WIBAdManager sharedInstance].adType = kNewRoundAd;
                [[WIBAdManager sharedInstance].interstitial presentFromRootViewController: self];
            } else {
                [self performSegueWithIdentifier:@"newGameSegue" sender:self];
            }
        }
        [FIRAnalytics logEventWithName:kFIREventSelectContent
                            parameters:@{
                                         kFIRParameterItemID: @(indexPath.row),
                                         kFIRParameterItemCategory: type.category
                                         }
         ];
    } else {
        WIBQuestionTypeCell *cell = (WIBQuestionTypeCell *)[collectionView.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
        [cell.animationView startCanvasAnimation];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/3.0-collectionView.frame.size.width/10, collectionView.frame.size.height/3.0);
}

# pragma mark - Game Center Delegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - GADInterstitialDelegate
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    if ([WIBAdManager sharedInstance].adType == kNewRoundAd) {
        [self performSegueWithIdentifier:@"newGameSegue" sender:self];
    }
    [WIBAdManager sharedInstance].adType = kUndefined;
}

# pragma mark - Facebook
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
//{
//    [self _facebookAuth];
//}
//
//- (void)_facebookAuth
//{
//    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        self.loginButton.hidden = YES;
//        [self.profileButton setTitle:[[PFUser currentUser] objectForKey:@"firstName"] forState:UIControlStateNormal];
//    }
//    
//    else {
//        self.loginButton.hidden = NO;
//        self.profileButton.hidden = YES;
//    }
//}

//- (void)_scrapeFacebook
//{
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            // result is a dictionary with the user's Facebook data
//            NSDictionary *userData = (NSDictionary *)result;
//            
//            NSString *facebookID = userData[@"id"];
//            NSString *name = userData[@"name"];
//            //NSString *location = userData[@"location"][@"name"];
//            
//            NSString *picURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
//            NSString *firstName = [name componentsSeparatedByString:@" "].firstObject;
//            
//            self.footerLabel.text = [NSString stringWithFormat:@"Welcome back, %@", firstName];
//            
//            [[PFUser currentUser] setObject:facebookID forKey:@"facebookID"];
//            [[PFUser currentUser] setObject:name forKey:@"name"];
//            [[PFUser currentUser] setObject:firstName forKey:@"firstName"];
//            [[PFUser currentUser] setObject:picURLString forKey:@"picURLString"];
//            [[PFUser currentUser] saveInBackground];
//        }
//        else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
//            NSLog(@"The facebook session was invalidated");
//            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
//        } else {
//            NSLog(@"Some other error: %@", error);
//        }
//    }];
//}

@end
