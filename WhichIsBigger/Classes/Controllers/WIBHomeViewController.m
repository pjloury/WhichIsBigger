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

@interface WIBHomeViewController()<PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@end

@implementation WIBHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.startNewGameButton.enabled = NO;
    __weak WIBHomeViewController *weakSelf = self;
    [[WIBNetworkManager sharedInstance] generateDataModelWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(),
        ^{
            weakSelf.startNewGameButton.enabled = YES;
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
#ifdef FACEBOOK_LOGIN
	// Check if user is logged in
	if (![PFUser currentUser]) {
		// Instantiate our custom log in view controller
		WIBLoginViewController *logInViewController = [[WIBLoginViewController alloc] init];
		[logInViewController setDelegate:self];
		[logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
		[logInViewController setFields:PFLogInFieldsUsernameAndPassword
		 | PFLogInFieldsFacebook
		 | PFLogInFieldsDismissButton];

        // Present log-in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
		/*
		// Instantiate our custom sign up view controller
		WIBLoginViewController *signUpViewController = [[WIBLoginViewController alloc] init];
		[signUpViewController setDelegate:self];
		[signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
		// Link the sign up view controller
		[logInViewController setSignUpController:signUpViewController];
		*/
	}
#endif
	
}

- (IBAction)didPressNewGameButton:(id)sender
{
    // Set Game State
    [[WIBGamePlayManager sharedInstance] beginGame];
    
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
}

@end
