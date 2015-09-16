//
//  WIBImageView.m
//  WhichIsBigger
//
//  Created PJ Loury on 8/19/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBImageView.h"
#import "WIBGameItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface WIBImageView ()

@end

@implementation WIBImageView

- (void)setup
{
    self.userInteractionEnabled = YES;
    if (self.gameItem.categoryType == WIBCategoryTypePopulation)
    {
        self.contentMode = UIViewContentModeCenter;
    }
    else
    {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if (self.gameItem.photoURL)
    
    [self sd_setImageWithURL:[NSURL URLWithString:self.gameItem.photoURL]
            placeholderImage:[UIImage imageNamed:@"questionMark"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                
                if (!error)
                {
                    NSLog(@"width %f height %f", self.layer.contentsRect.size.width, self.layer.contentsRect.size.height);
                    //CGRect imageRect = AVMakeRectWithAspectRatioInsideRect(image.size,self.frame);
                }
                else
                {
                    self.image = [UIImage imageNamed:@"questionMark"];
                }
            }];
    
    if (self.multiplier > 1)
    {
        self.multiplierLabel.hidden = NO;
        self.multiplierLabel.text = [NSString stringWithFormat:@"x%d",self.multiplier];
    }
    else
    {
        self.multiplierLabel.hidden = YES;
    }
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = .4;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeZero;
    
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    
    //NSLog(@"width %f height %f", self.layer.contentsRect.size.width, self.layer.contentsRect.size.height);
    
    //self.backgroundColor = [UIColor colorWithRed:175/255 green:68/255 blue:255/255 alpha:0.17];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// This is currently rounding the entire view not just the visible image..
- (void)roundViewEdges
{
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
}



@end
