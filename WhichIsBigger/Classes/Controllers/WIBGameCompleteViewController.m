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

// Views
#import "WIBPopButton.h"

@interface WIBGameCompleteViewController ()< FBSDKAppInviteDialogDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
//@property (weak, nonatomic) IBOutlet WIBPopButton *challengeAFriendButton;

@end

@implementation WIBGameCompleteViewController

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton= YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.playAgainButton.layer.borderColor = [UIColor lightPurpleColor].CGColor;
//    self.challengeAFriendButton.layer.borderColor = [UIColor lightPurpleColor].CGColor;

    self.playAgainButton.layer.cornerRadius = 10;
    self.playAgainButton.layer.borderWidth = 2;
}

- (IBAction)didPressDone:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didPressPlayAgain:(id)sender
{
    if ([[WIBGamePlayManager sharedInstance] unlockedQuestionType]) {
        [self performSegueWithIdentifier:@"unlockedQuestionTypeSegue" sender:self];
    }
    else {
        WIBQuestionType *type = [WIBGamePlayManager sharedInstance].gameRound.questionType;
        [[WIBGamePlayManager sharedInstance] beginRoundForType:type];
        [self performSegueWithIdentifier:@"playAgainSegue" sender:self];
    }
}

- (IBAction)didPressActionButton:(id)sender {
}

- (void)openFacebookShareFlow
{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    
    // Should be a link to the app store!
    content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showWithContent:content
                                 delegate:self];
}

/*!
 @abstract Sent to the delegate when the app invite completes without error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
{
    
}
/*!
 @abstract Sent to the delegate when the app invite encounters an error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param error The error.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error;
{
    
}


@end
