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

@interface WIBHomeViewController()<PFLogInViewControllerDelegate, FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;

@property (weak, nonatomic) IBOutlet UIButton *parseLoginButton;

@property (weak, nonatomic) IBOutlet UIView *highScoresUnderscore;
@property (weak, nonatomic) IBOutlet UIView *highScoresBackground;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonWidth;
@property (nonatomic) NSArray *readPermissions;

@end

@implementation WIBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.readPermissions = self.readPermissions;
    self.loginButton.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    self.startNewGameButton.userInteractionEnabled = NO;
    self.loginButton.delegate = self;
    
//    [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
//        dispatch_async(dispatch_get_main_queue(),
//                       ^{
//                           self.startNewGameButton.userInteractionEnabled = YES;
//                       });
//    }];
    
    [[WIBNetworkManager sharedInstance] getConfigurationWithCompletion:^{
        [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                                self.startNewGameButton.userInteractionEnabled = YES;
                           });
        }];
    }];
}

- (void)viewWillAppear2:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    self.loginButton.hidden = ([FBSDKAccessToken currentAccessToken]) ? YES: NO;
    self.highScoresButton.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    self.highScoresUnderscore.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    self.highScoresBackground.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    self.nameButton.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    [self.nameButton setTitle:[[PFUser currentUser] objectForKey:@"name"] forState:UIControlStateNormal];
    
    // do I need to set the currentUser by checking the token?
    
    // the Token is always the same for a given FB user
    
    //once you've linked, you want to
    
    if ([FBSDKAccessToken currentAccessToken])
    {
       // [self _scrapeFacebook];
        [PFFacebookUtils linkUserInBackground:[PFUser currentUser] withAccessToken:[FBSDKAccessToken currentAccessToken] block:^(BOOL succeeded, NSError *error){
            if(error)
            {
                NSLog(error.description);
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // a) If its not linked then the user is anonymous
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        // a) the user is linked, don't show facebook
        self.parseLoginButton.hidden = YES;
        [self.nameButton setTitle:[[PFUser currentUser] objectForKey:@"name"] forState:UIControlStateNormal];
    }
    
    else {
        
    }
    
    self.loginButton.userInteractionEnabled = NO;
    
    self.loginButton.hidden = ([FBSDKAccessToken currentAccessToken]) ? YES: NO;
    self.highScoresButton.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    self.highScoresUnderscore.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    self.highScoresBackground.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    self.nameButton.hidden = ([FBSDKAccessToken currentAccessToken]) ? NO: YES;
    
    // do I need to set the currentUser by checking the token?
    
    // the Token is always the same for a given FB user
    
    //once you've linked, you want to
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        // [self _scrapeFacebook];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

    //if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//    if(![PFUser currentUser].objectId)
//    {
//        // show the link to Facebook button
//    }
//    NSArray *permissions = @[@"friends_about_me"];
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions
//                                                    block:^(PFUser *user, NSError *error){
//                                                        
//                                                    }];
//

/*
        if ([FBSDKAccessToken currentAccessToken]) {
            NSLog(@"already a token");
        }
        
        [PFFacebookUtils linkUserInBackground:[PFUser currentUser] withReadPermissions:permissions block:
         ^(BOOL succeeded, NSError *error){
            NSLog(@(succeeded));
            if(error)
            {
                NSLog(error.description);
            }
        }];
*/
}

# pragma mark - FBSDKLoginButtonDelegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    // Once the user authenticates facebook, we can actually pull down their correct PFUser
    // by querying based on facebook ID
    
    self.loginButton.hidden = YES;
    [self _scrapeFacebook];
    
    /*
    NSArray *permissions =     @[@"public_profile", @"email", @"user_friends"];//
    [PFFacebookUtils linkUserInBackground:[PFUser currentUser] withReadPermissions:permissions block:
     ^(BOOL succeeded, NSError *error){
         
         NSLog(@(succeeded));
         if(error)
         {
             NSLog(error.description);
         }
     }];
     */
    

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
            [[PFUser currentUser] setObject:name forKey:@"firstName"];
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

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}


- (IBAction)didPressParseLogin:(id)sender
{
    // need to protect against the case where another user is already linked to the ID
    // 
    [PFFacebookUtils logInInBackgroundWithReadPermissions:self.readPermissions block:^(PFUser *user, NSError *error){
        if(error) {
            NSLog(error.description);
        }
        [[PFUser currentUser] setObject:@"ParseLogin" forKey:@"firstName"];
        [self _scrapeFacebook];
    }];
}

- (IBAction)didPressNewGameButton:(id)sender
{
    // Set Game State
    [[WIBGamePlayManager sharedInstance] beginGame];
    
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
}

@end
