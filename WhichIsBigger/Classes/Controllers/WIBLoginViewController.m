//
//  WIBLoginViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 7/9/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBLoginViewController.h"

@interface WIBLoginViewController ()

//@property (nonatomic, strong, readwrite) PFLogInView *logInView;

@end

@implementation WIBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *logo = [[[NSBundle mainBundle] loadNibNamed:@"WIBLogo" owner:self options:nil] firstObject];
    self.logInView.logo = logo;
	//self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loginWithFacebook {
    
//    Class fbUtils = NSClassFromString(@"PFFacebookUtils");
//    [fbUtils initializeFacebook];
//    
//    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
//    
//    // Login PFUser using Facebook
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//        } else {
//            NSLog(@"User logged in through Facebook!");
//        }
//    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
# pragma mark - PFLogInViewControllerDelegate
- (BOOL)logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
				   password:(NSString *)password
{
	return YES;
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
	
}

- (void)logInViewController:(PFLogInViewController *)logInController
	didFailToLogInWithError:(PFUI_NULLABLE NSError *)error
{
	
}


- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController;
{
	
}
 */

@end
