//
//  WIBImageView.m
//  WhichIsBigger
//
//  Created PJ Loury on 8/19/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBImageView.h"
#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"
#import "UIImage+Additions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface WIBImageView ()

@end

@implementation WIBImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.layer.masksToBounds = NO;
    self.state = WIBImageViewStateUnanswered;
    return self;
}

- (void)setState:(WIBImageViewState)state
{
    switch (state) {
        case WIBImageViewStateUnanswered:
            self.layer.shadowColor = [UIColor grayColor].CGColor;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.layer.shadowOffset = CGSizeMake(4, 4);
            self.layer.shadowOpacity = 1;
            self.layer.shadowRadius = 1.0;
            break;
        case WIBImageViewStateCorrect:
            self.layer.borderWidth = 4.0f;
            self.layer.borderColor = [UIColor greenColor].CGColor;
            self.layer.shadowColor = [UIColor clearColor].CGColor;
            break;
        case WIBImageViewStateIncorrect:
            self.layer.borderWidth = 4.0f;
            self.layer.borderColor = [UIColor redColor].CGColor;
            self.layer.shadowColor = [UIColor clearColor].CGColor;
            break;
    }
}



- (void)setup
{
    self.userInteractionEnabled = YES;
    self.image = nil;
    
    if (self.gameItem.photoURL != nil && ![self.gameItem.photoURL isKindOfClass:[NSNull class]]) {
        NSLog(self.gameItem.photoURL);
        [self sd_setImageWithURL:[NSURL URLWithString:self.gameItem.photoURL]
                placeholderImage:[UIImage placeholderWithHeight:100] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error)
                        {
                            NSLog(@"width %f height %f", self.layer.contentsRect.size.width, self.layer.contentsRect.size.height);
                            UIImage *im;
                            if (image.size.height > image.size.width) {
                                im = [UIImage imageWithImage:image scaledToHeight:100 maxHeight:self.frame.size.height];
                            } else {
                                im = [UIImage imageWithImage:image scaledToWidth:100];
                            }
                            self.image = im;
                        }
                        else
                        {
                            self.image = [UIImage placeholderWithHeight:100];
                        }
                        self.layer.borderWidth = 1;
                    });
                }];
    }
    else {
        self.image = [UIImage placeholderWithHeight:100 maxHeight:self.frame.size.height];
    }
    
    if (self.multiplier > 1)
    {
        self.multiplierLabel.hidden = NO;
        self.multiplierLabel.text = [NSString stringWithFormat:@"x%d",self.multiplier];
    }
    else
    {
        self.multiplierLabel.hidden = YES;
    }
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
