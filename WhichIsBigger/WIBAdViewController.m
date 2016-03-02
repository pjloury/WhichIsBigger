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
    UINavigationController* nc = (UINavigationController*)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [nc.navigationBar setBarTintColor:[UIColor lightPurpleColor]];
    
    UILabel *whichIsBigger = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(nc.navigationBar.frame))];
    self.navigationItem.titleView = whichIsBigger;
    
    self.view.backgroundColor = [UIColor faintPurpleColor];
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
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
