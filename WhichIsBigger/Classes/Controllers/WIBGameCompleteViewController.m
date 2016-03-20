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

@interface WIBGameCompleteViewController ()
//@interface WIBGameCompleteViewController ()< FBSDKAppInviteDialogDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
//@property (weak, nonatomic) IBOutlet WIBPopButton *challengeAFriendButton;

@end

@implementation WIBGameCompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton= YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.playAgainButton.layer.borderColor = [UIColor lightPurpleColor].CGColor;
//    self.challengeAFriendButton.layer.borderColor = [UIColor lightPurpleColor].CGColor;
    self.playAgainButton.layer.cornerRadius = 6;
}

- (IBAction)didPressDone:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didPressActionButton:(id)sender {
    NSString *highScore = [NSString stringWithFormat:@"Have you played Which is Bigger? See if you can beat my top score of %ld!", [WIBGamePlayManager sharedInstance].highScore];
    NSString *urlString = [[PFConfig currentConfig] objectForKey:@"appURL"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:highScore];
    if (url) [items addObject:url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    NSArray *excludedActivities = @[
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)didPressPlayAgain:(id)sender
{
    self.playAgainButton.userInteractionEnabled = NO;
    if ([[WIBGamePlayManager sharedInstance] unlockedQuestionType]) {
        WIBQuestionType *type = [WIBGamePlayManager sharedInstance].unlockedQuestionType;
        [[WIBGamePlayManager sharedInstance] beginRoundForType:type];
        [self performSegueWithIdentifier:@"unlockedQuestionTypeSegue" sender:self];
    }
    else {
        WIBQuestionType *type = [WIBGamePlayManager sharedInstance].gameRound.questionType;
        [[WIBGamePlayManager sharedInstance] beginRoundForType:type];
        [self performSegueWithIdentifier:@"playAgainSegue" sender:self];
    }
}

//- (void)openFacebookShareFlow
//{
//    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
//    
//    // Should be a link to the app store!
//    content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
//    //optionally set previewImageURL
//    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
//    
//    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
//    [FBSDKAppInviteDialog showWithContent:content
//                                 delegate:self];
//}
//
///*!
// @abstract Sent to the delegate when the app invite completes without error.
// @param appInviteDialog The FBSDKAppInviteDialog that completed.
// @param results The results from the dialog.  This may be nil or empty.
// */
//- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results;
//{
//    
//}
///*!
// @abstract Sent to the delegate when the app invite encounters an error.
// @param appInviteDialog The FBSDKAppInviteDialog that completed.
// @param error The error.
// */
//- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error;
//{
//    
//}


@end
