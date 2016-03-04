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
#import "WIBNetworkManager.h"
#import "WIBLoginViewController.h"
#import "WIBGameCompleteViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "WIBQuestionType.h"
#import "WIBQuestionTypeCell.h"

@interface WIBHomeViewController()<PFLogInViewControllerDelegate, GKGameCenterControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;


@property (nonatomic) NSArray *readPermissions;

@end

@implementation WIBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.startNewGameButton.enabled = NO;
    self.categoriesCollectionView.userInteractionEnabled = NO;
        
    [[WIBNetworkManager sharedInstance] getConfigurationWithCompletion:^{
        [[WIBNetworkManager sharedInstance] getCategoriesWithCompletion:^{
            [self.categoriesCollectionView reloadData];
            [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                    self.startNewGameButton.enabled = YES;
                                   self.categoriesCollectionView.userInteractionEnabled = YES;
                               });
            }];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPressHighScoresButton:) name:@"GameCenterDidFinishAuthentication" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.highScoresButton.layer.cornerRadius = 6;
    self.startNewGameButton.layer.cornerRadius = 6;
    [self.categoriesCollectionView reloadData];
    self.totalPointsLabel.text = [NSString stringWithFormat:@"%ld pts", [WIBGamePlayManager sharedInstance].lifeTimeScore];
}

- (IBAction)didPressLoginButton:(id)sender
{
    // need to protect against the case where another user is already linked to the ID
    [PFFacebookUtils logInInBackgroundWithReadPermissions:self.readPermissions block:^(PFUser *user, NSError *error){
        if(error) {
            NSLog(error.description);
        }
        [self _facebookAuth];
        [self _scrapeFacebook];
    }];
}

- (IBAction)didPressNewGameButton:(id)sender
{
    [[WIBGamePlayManager sharedInstance] beginRound];
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
}

- (IBAction)didPressHighScoresButton:(id)sender
{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = @"highScore";
        [self presentViewController:gcViewController animated:YES completion:nil];
    }else {
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
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:type.image.url] completed:^
        (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.imageView.image = image;
        }];
        cell.label.text = type.title;
        cell.imageViewContainer.backgroundColor = type.backgroundColor;
        cell.imageView.tintColor = type.tintColor;
    } else {
        UIImage *image = [UIImage imageNamed:@"smallQuestionMark"];
        //image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //cell.imageView.tintColor = type.tintColor;
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
        [self performSegueWithIdentifier:@"newGameSegue" sender:self];
    } else {
        WIBQuestionTypeCell *cell = (WIBQuestionTypeCell *)[collectionView.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
        [cell.animationView startCanvasAnimation];
    }
}

# pragma mark - Game Center Delegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Facebook
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self _facebookAuth];
}

- (void)_facebookAuth
{
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.loginButton.hidden = YES;
        [self.profileButton setTitle:[[PFUser currentUser] objectForKey:@"firstName"] forState:UIControlStateNormal];
    }
    
    else {
        self.loginButton.hidden = NO;
        self.profileButton.hidden = YES;
    }
}

- (void)_scrapeFacebook
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            //NSString *location = userData[@"location"][@"name"];
            
            NSString *picURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            NSString *firstName = [name componentsSeparatedByString:@" "].firstObject;
            
            self.footerLabel.text = [NSString stringWithFormat:@"Welcome back, %@", firstName];
            
            [[PFUser currentUser] setObject:facebookID forKey:@"facebookID"];
            [[PFUser currentUser] setObject:name forKey:@"name"];
            [[PFUser currentUser] setObject:firstName forKey:@"firstName"];
            [[PFUser currentUser] setObject:picURLString forKey:@"picURLString"];
            [[PFUser currentUser] saveInBackground];
        }
        else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

@end
