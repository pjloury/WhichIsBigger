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
    
    [self setInitialProgressWidth];
    
    return self;
}

- (void)setInitialProgressWidth
{
    self.fullBarWidth  = self.frame.size.width;
    
    self.previousPoints = ([[WIBGamePlayManager sharedInstance] currentLevelPoints] - [WIBGamePlayManager sharedInstance].score);
    CGFloat previousPercentage = (CGFloat) self.previousPoints/(CGFloat) POINTS_PER_LEVEL;
    NSLog(@"%f",previousPercentage);
    
    CGFloat startingWidth = self.fullBarWidth * previousPercentage;
    self.progressBarWidthConstraint.constant = startingWidth;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void(^)())completion;
{
    CGFloat endingWidth = self.fullBarWidth * progress;
    
    if (self.previousPoints > 0) {
        [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed*3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarWidthConstraint.constant = endingWidth;
            [self layoutIfNeeded];
        } completion:^(BOOL finished){
            if (completion) {
                completion();
            }
        }
        ];
    }
    else {
        [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.progressBarWidthConstraint.constant = self.fullBarWidth;
            [self.progressMeter layoutIfNeeded];
        }
                         completion:^(BOOL finished) {
                             self.progressBarWidthConstraint.constant = 0;
                             [self layoutIfNeeded];
                             [UIView animateWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                 self.progressBarWidthConstraint.constant = endingWidth;
                                 [self layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                                    
                             }];
                         }];
    }

    
}

@end
