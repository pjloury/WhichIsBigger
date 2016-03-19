//
//  WIBAdViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/16/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//


#import "WIBAdViewController.h"

@implementation WIBAdViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor faintPurpleColor];
        
    self.adBannerView.adUnitID = @"ca-app-pub-4490282633558794/8329432662";
    self.adBannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];
    [self.adBannerView loadRequest:request];
    
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBarTintColor:[UIColor lightPurpleColor]];
    
    UILabel *whichIsBigger = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(nc.navigationBar.frame))];
    self.navigationItem.titleView = whichIsBigger;

    whichIsBigger.font = [UIFont fontWithName:@"BloggerSans-Medium" size:28];
    whichIsBigger.textColor = [UIColor pastelPurpleColor];
    whichIsBigger.text = @"Which is Bigger ?";
    whichIsBigger.textAlignment = NSTextAlignmentCenter;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBannerView.superview == nil)
        {
            [self.view addSubview:_adBannerView];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
}


@end
