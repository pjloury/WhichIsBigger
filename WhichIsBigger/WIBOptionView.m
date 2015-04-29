//
//  WIBOptionView.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBOptionView.h"
#import "WIBImageView.h"
#import "WIBGameItem.h"
#import "WIBConstants.h"
#import "UIView+AutoLayout.h"

@interface WIBOptionView ()

@property (nonatomic, weak) WIBGameItem *gameItem;
@property (nonatomic, strong) WIBImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation WIBOptionView

- (instancetype)initWithGameItem:(WIBGameItem *)item {
    if (self = [super init]) {
        _gameItem = item;
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    [self configureImageView];
    [self configureLabel];
    [self configureConstraints];
}

- (void)configureLabel {
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"Kanye West";
    self.nameLabel.font = [UIFont fontWithName:HELVETICA_NEUE size:24];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
}

- (void)configureImageView {
    self.imageView = [[WIBImageView alloc] initWithGameItem:self.gameItem];
    [self addSubview:self.imageView];
}

- (void)configureConstraints {
    [self.imageView ic_centerHorizontallyInSuperView];
    [self.imageView ic_constraintForHeightAttributeEqualtToView:self multiplier:.5];
    [self.imageView ic_equalRelationConstraintForAttribute:NSLayoutAttributeCenterY toView:self multiplier:1 constant:-10];
    
    [self.nameLabel ic_centerHorizontallyInSuperView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
}

@end
