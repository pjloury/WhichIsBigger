//
//  WIBAdViewController.h
//  WhichIsBigger
//
//  Created by PJ Loury on 2/16/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface WIBAdViewController : UIViewController<GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *adBannerView;
@property BOOL bannerIsVisible;

@end
