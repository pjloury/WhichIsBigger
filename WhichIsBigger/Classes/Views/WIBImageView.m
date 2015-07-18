//
//  WIBImageView.m
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBImageView.h"
#import "WIBGameItem.h"
#import "AsyncImageView.h"

@interface WIBImageView ()

@property (nonatomic, strong) AsyncImageView *subImageView;

@end

@implementation WIBImageView

- (void)setup
{
    self.userInteractionEnabled = YES;
    
    if(!self.subImageView)
    {
        self.subImageView = [[AsyncImageView alloc] initWithFrame:self.bounds];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameQuestionTimeUpHandler:) name:kGameQuestionTimeUpNotification object:nil];
        self.subImageView.showActivityIndicator = YES;
        self.subImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addTarget:self action:@selector(actionDidPressButton:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(actionDidReleaseButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:self.subImageView];
        
    }
    
	self.subImageView.imageURL = [NSURL URLWithString:self.gameItem.photoURL];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = .4;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeZero;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// This is currently rounding the entire view not just the visible image..
- (void)roundViewEdges {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
}

- (void)gameQuestionTimeUpHandler:(NSNotification *)note
{
    self.userInteractionEnabled = NO;
}

- (void)actionDidPressButton:(id)sender {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = .15f;
    animation.fromValue = @(1);
    animation.toValue = @(1.2f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (void)actionDidReleaseButton:(id)sender {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = .1f;
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale1"];
    [self.delegate imageViewWasSelected:self];
}

@end
