//
//  WIBAdViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/16/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//


#import "WIBAdViewController.h"
#import "WIBAdManager.h"

@implementation WIBAdViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor faintPurpleColor];
    self.adBannerView.adUnitID = [WIBAdManager sharedInstance].bannerAdUnit;
    self.adBannerView.adSize = kGADAdSizeBanner;
    self.adBannerView.rootViewController = self;
    self.adBannerView.delegate = self;
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    /*
    request.testDevices = @[
                            @"6b0ce7dd31b8109a6ca3f1ee4a064faa" // PJ's iPhone 6"
                            ];
     */
    [self.adBannerView loadRequest:request];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error;
{
    NSLog(error.description);
}

@end
