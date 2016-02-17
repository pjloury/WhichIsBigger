//
//  WIBAdViewController.h
//  WhichIsBigger
//
//  Created by PJ Loury on 2/16/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBAdViewController : UIViewController<ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@property BOOL bannerIsVisible;

@end
