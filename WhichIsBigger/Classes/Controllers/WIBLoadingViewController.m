//
//  WIBLoadingViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/19/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBLoadingViewController.h"
#import "WIBGameViewController.h"

@interface WIBLoadingViewController ()
@property (weak, nonatomic) IBOutlet CSAnimationView *animationView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingQuestionMarkView;

@end

@implementation WIBLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupImageDownloadDidComplete:) name:kGroupImageDownloadCompleteNotification object:nil];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.shimmeringView.contentView = self.loadingQuestionMarkView;
    self.shimmeringView.shimmering = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)groupImageDownloadDidComplete:(NSNotification *)note
{
    // Start
    self.animationView.transform = CGAffineTransformMakeScale(1, 1);
    self.animationView.alpha = 1;
    [UIView animateKeyframesWithDuration:0.5 delay:0.8 options:0 animations:^{
        // End
        self.animationView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.animationView.alpha = 0;
    } completion:^(BOOL finished) {
        //[self performSegueWithIdentifier:@"beginGameSegue" sender:self];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WIBGameViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self.navigationController pushViewController:vc animated:NO];
    }];
}

@end
