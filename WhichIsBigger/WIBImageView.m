//
//  WIBImageView.m
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBImageView.h"
#import "WIBGameItem.h"

@interface WIBImageView ()

@property (nonatomic, weak) WIBGameItem *gameItem;

@end

@implementation WIBImageView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithGameItem:(WIBGameItem *)item {
    if (self = [self init]) {
        _gameItem = item;
    }
    return self;
}

- (void)setup {
    [self setImage:[UIImage imageNamed:@"sample"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"sample"] forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(actionDidPressButton:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(actionDidReleaseButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.showsTouchWhenHighlighted = NO;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = .3;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeZero;
    
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 2;
    self.contentMode = UIViewContentModeScaleAspectFill;
    [self configureConstraints];
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
    [super layoutSubviews];
    [self roundViewEdges];
}

- (void)actionDidPressButton:(id)sender {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = .15f;
    animation.fromValue = @(1);
    animation.toValue = @(1.3f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];// functionWithControlPoints:0.4 :0 :0 :1.0];
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (void)actionDidReleaseButton:(id)sender {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = .1f;
    //animation.fromValue = @(1);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    //animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0 :0 :1.0];
    [self.layer addAnimation:animation forKey:@"scale1"];
}



@end
