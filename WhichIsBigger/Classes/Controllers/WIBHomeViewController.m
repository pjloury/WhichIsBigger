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
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@end

@implementation WIBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.startNewGameButton.enabled = NO;
    __weak WIBHomeViewController *weakSelf = self;
    
    [[WIBNetworkManager sharedInstance] getConfigurationWithCompletion:^{
        [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(),
            ^{
                weakSelf.startNewGameButton.enabled = YES;
            });
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

//    if(![PFUser currentUser].objectId)
//    {
//        // show the link to Facebook button
//    }
    
    
	// Check if user is logged in
	if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
		// Instantiate our custom log in view controller
		
        self.loginButton.hidden = NO;
        
//        WIBLoginViewController *logInViewController = [[WIBLoginViewController alloc] init];
//		[logInViewController setDelegate:self];
//		[logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
//		[logInViewController setFields:PFLogInFieldsUsernameAndPassword
//		 | PFLogInFieldsFacebook
//		 | PFLogInFieldsDismissButton];
//
//        // Present log-in view controller
//        [self presentViewController:logInViewController animated:YES completion:NULL];
	}
    else
    {
        self.loginButton.hidden = YES;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *facebookID = userData[@"id"];
                NSString *name = userData[@"name"];
                //NSString *location = userData[@"location"][@"name"];

                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
                NSString *firstName = [name componentsSeparatedByString:@" "].firstObject;
                
                self.footerLabel.text = [NSString stringWithFormat:@"Welcome back, %@", firstName];
                
                // Now add the data to the UI elements
                // ...
            }
            else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
    }

}

# pragma mark - FBSDKLoginButtonDelegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    self.loginButton.hidden = YES;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            //NSString *location = userData[@"location"][@"name"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSString *firstName = [name componentsSeparatedByString:@" "].firstObject;
            
            self.footerLabel.text = [NSString stringWithFormat:@"Welcome back, %@", firstName];
            
            // Now add the data to the UI elements
            // ...
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
    // Set Game State
    [[WIBGamePlayManager sharedInstance] beginGame];
    
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
}

@end
