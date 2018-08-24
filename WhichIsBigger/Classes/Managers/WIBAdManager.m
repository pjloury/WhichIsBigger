//
//  WIBAdManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/11/18.
//  Copyright © 2018 Angry Tortoise Productions. All rights reserved.
//

#import "WIBAdManager.h"

@interface WIBAdManager ()

@property BOOL test;

@end

@implementation WIBAdManager

NSString *const TestVideoInterstitialAdUnit = @"ca-app-pub-3940256099942544/5135589807";
NSString *const TestBannerAdUnit = @"ca-app-pub-3940256099942544/6300978111";

NSString *const PJInterstitialAdUnit = @"ca-app-pub-4490282633558794/5605799021(nonatomic) ";
NSString *const PJBannerAdUnit = @"ca-app-pub-4490282633558794/8329432662";

+ (WIBAdManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBAdManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBAdManager alloc] init];
        shared.test = NO;
        shared.interstitial = nil;
        shared.adType = kUndefined;
    });
    return shared;
}

- (NSString *)interstitialAdUnit {
    return self.test ? TestVideoInterstitialAdUnit: PJInterstitialAdUnit;
}

- (NSString *)bannerAdUnit {
    return self.test ? TestBannerAdUnit: PJBannerAdUnit;
}

- (void)loadGADInterstitial
{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID: self.interstitialAdUnit];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [interstitial loadRequest:request];
    self.interstitial = interstitial;
}

@end
