//
//  WIBProfileViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 9/26/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBProfileViewController.h"

@interface WIBProfileViewController ()

@end

@implementation WIBProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.accuracyLabel.text = [NSString stringWithFormat:@"%g%%",floorf([WIBGamePlayManager sharedInstance].accuracy*100.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressLogoutButton:(id)sender {
    //[PFUser logOut];
    [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error)
     {
         
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
