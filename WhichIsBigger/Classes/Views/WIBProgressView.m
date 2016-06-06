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

@end

@implementation WIBProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.fullBarWidth  = self.frame.size.width;
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.fullBarWidth  = self.frame.size.width;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void(^)())completion;
{
    //fullBarWidth claims to be 420;
    NSLog(@"Progress: %f", progress);
    
    CGFloat progressWidth = self.frame.size.width * progress;
    NSLog(@"Progress Width: %f", progressWidth);
    
    CGFloat progressDifference = progress - self.progress;
    NSLog(@"Progress difference: %f", progressDifference);
    
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
                                [self.delegate progressViewDidSurpassFullProgress:self];
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
