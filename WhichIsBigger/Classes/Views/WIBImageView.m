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

@interface WIBImageView ()

@end

@implementation WIBImageView

- (void)setup
{
    self.userInteractionEnabled = YES;
    [self sd_setImageWithURL:[NSURL URLWithString:self.gameItem.photoURL]
                      placeholderImage:[UIImage imageNamed:@"questionMark"]];
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
