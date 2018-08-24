//
//  WIBAdManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 8/11/18.
//  Copyright © 2018 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;

typedef enum {
    kUndefined,
    kLaunchAd,
    kNewRoundAd
} AdType;

@interface WIBAdManager : NSObject

+ (WIBAdManager *)sharedInstance;
- (void)loadGADInterstitial;
@property GADInterstitial *interstitial;
@property AdType adType;
@property (nonatomic) NSString *bannerAdUnit;
@property (nonatomic) NSString *interstitialAdUnit;

@end
