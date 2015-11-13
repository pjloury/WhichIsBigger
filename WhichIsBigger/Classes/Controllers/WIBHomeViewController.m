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

@interface WIBHomeViewController()<PFLogInViewControllerDelegate, GKGameCenterControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *highScoresUnderscore;
@property (weak, nonatomic) IBOutlet UIView *highScoresBackground;

@property (nonatomic) NSArray *readPermissions;

@end

@implementation WIBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.startNewGameButton.enabled = NO;
    
    [[WIBNetworkManager sharedInstance] getConfigurationWithCompletion:^{
        [[WIBNetworkManager sharedInstance] getCategoriesWithCompletion:^{
            [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                    self.startNewGameButton.enabled = YES;
                               });
            }];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHighScore) name:@"GameCenterDidFinishAuthentication" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateHighScore];
}

- (void)updateHighScore
{
    if (![GKLocalPlayer localPlayer].isAuthenticated) {
        self.highScoresButton.hidden = YES;
        self.highScoresBackground.hidden = YES;
        self.highScoresUnderscore.hidden = YES;
    }
    else {
        self.highScoresButton.hidden = NO;
        self.highScoresBackground.hidden = NO;
        self.highScoresUnderscore.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self _facebookAuth];
//    [self _scrapeFacebook];
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

- (IBAction)didPressNewGameButton:(id)sender
{
    [[WIBGamePlayManager sharedInstance] beginGame];
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
}

- (IBAction)didPressHighScoresButton:(id)sender {

    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = @"highScore";
        [self presentViewController:gcViewController animated:YES completion:nil];
    }

//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WIBGameCompleteViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GameCompleteViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Game Center Delegate
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
