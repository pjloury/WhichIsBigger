//
//  WIBHighScoresViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 9/16/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBHighScoresViewController.h"
#import "WIBTopScoreTableViewCell.h"

@interface WIBHighScoresViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *friendUsers;

@end

@implementation WIBHighScoresViewController

- (void)viewDidLoad
{
}

- (void)viewWillAppear:(BOOL)animated
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSArray *data = userData[@"data"];
            NSMutableArray *facebookIDs = [[NSMutableArray alloc] init];
            for(NSDictionary *tuple in data)
            {
                [facebookIDs addObject:tuple[@"id"]];
            }
            [facebookIDs addObject:[[PFUser currentUser] objectForKey:@"facebookID"]];
            
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookID" containedIn:facebookIDs];
            [friendQuery whereKey:@"highScore" greaterThan:@(0)];
            [friendQuery orderByDescending:@"highScore"];
            
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    self.friendUsers = objects;
                    [self.tableView reloadData];
                    
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendUsers.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    WIBTopScoreTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"topScoreCell"];
    PFUser *user = [self.friendUsers objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [user objectForKey:@"name"];
    NSNumber *highScoreNumber = [user objectForKey:@"highScore"];
    cell.topScoreLabel.text = highScoreNumber.stringValue;
    return cell;
    
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
