//
//  WIBProgressView.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/28/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "WIBProgressView.h"
#import "WIBGamePlayManager.h"

@interface WIBProgressView ()

@property (weak, nonatomic) IBOutlet UIView *progressMeter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarWidthConstraint;

@property CGFloat progress;

@property CGFloat fullBarWidth;
@property CGFloat previousPoints;

@end



@implementation WIBProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.fullBarWidth  = self.frame.size.width;
    return self;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void(^)())completion;
{
    CGFloat progressWidth = self.fullBarWidth * progress;
    CGFloat progressDifference = progress - self.progress;
    
    if (animated) {
        if (progressDifference > 0) {
            self.progressBarWidthConstraint.constant = progressWidth;
            [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed*3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished){
                if (completion) {
                    completion();
                }
            }
            ];
        }
        else {
            self.progressBarWidthConstraint.constant = self.fullBarWidth;
            [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self layoutIfNeeded];
            }
                             completion:^(BOOL finished) {
                                 self.progressBarWidthConstraint.constant = 0;
                                 [self layoutIfNeeded];
                                 [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed delay:[WIBGamePlayManager sharedInstance].animationSpeed options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                     self.progressBarWidthConstraint.constant = progressWidth;
                                     [self layoutIfNeeded];
                                 } completion:^(BOOL finished) {
                                     if (completion) {
                                         completion();
                                     }
                                        
                                 }];
                             }];
        }
    }
    else {
        self.progressBarWidthConstraint.constant = progressWidth;
        [self layoutIfNeeded];
    }
    self.progress = progress;
}

@end