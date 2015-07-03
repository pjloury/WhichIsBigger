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
#import "WIBConstants.h"

@interface WIBImageView ()

@property (nonatomic, strong) AsyncImageView *subImageView;

@end

@implementation WIBImageView

- (void)setup {    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameQuestionTimeUpHandler:) name:kGameQuestionTimeUpNotification object:nil];
    
    [self addTarget:self action:@selector(actionDidPressButton:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(actionDidReleaseButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.showsTouchWhenHighlighted = NO;
    self.backgroundColor = [UIColor blueColor];   
    
    self.clipsToBounds = YES;
    
    self.subImageView = [[AsyncImageView alloc] initWithFrame:self.bounds];
    
    if(![self.gameItem.photoURL containsString:@"http://"])
    {
        self.subImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.gameItem.photoURL]];
    }
    else
    {
        self.subImageView.imageURL = [NSURL URLWithString:self.gameItem.photoURL];
    }
    
    self.subImageView.contentMode = UIViewContentModeCenter;
    self.subImageView.userInteractionEnabled = NO;
    self.subImageView.exclusiveTouch = NO;
    self.subImageView.showActivityIndicator = YES;
    self.subImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.subImageView];

    
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = .3;
//    self.layer.shadowRadius = 2;
//    self.layer.shadowOffset = CGSizeZero;
//    
//    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.imageView.layer.borderWidth = 2;
//    self.contentMode = UIViewContentModeScaleAspectFill;
    
    //[self configureConstraints];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureConstraints {
    NSLayoutConstraint *aspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self addConstraint:aspectRatioConstraint];
}

- (void)roundViewEdges {
    self.imageView.layer.cornerRadius = self.frame.size.height/2;
    self.imageView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    self.subImageView.center = self.center;
    [super layoutSubviews];
    [self roundViewEdges];
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
    
    [self.delegate imageViewWasSelected:self];
}

- (void)actionDidReleaseButton:(id)sender {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = .1f;
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale1"];
}

@end
