//
//  WIBTutorialViewController.h
//  WhichIsBigger
//
//  Created by PJ Loury on 8/21/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBTutorialViewController : UIPageViewController
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property NSUInteger pageIndex;
@property NSString *centerTitle;

@end