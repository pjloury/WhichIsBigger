//
//  WIBOptionView.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBOptionView.h"
#import "WIBImageView.h"
#import "WIBGameOption.h"
#import "WIBGameItem.h"
#import "WIBConstants.h"
#import "UIView+AutoLayout.h"

@interface WIBOptionView ()<WIBOptionViewDelegate>

// Models
@property (nonatomic, weak) WIBGameOption *gameOption;
//@property (nonatomic, weak, readonly) WIBGameItem *gameItem;

// Views
@property (nonatomic, strong) WIBImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation WIBOptionView

- (instancetype)initWithGameOption:(WIBGameOption *)option {
    if (self = [super init]) {
        _gameOption = option;
        [self configureViews];
    }
    return self;
}

- (void)refreshWithOption:(WIBGameOption *)option;
{
    self.gameOption = option;
    [self configureViews];
}

- (void)configureViews {
    [self configureImageView];
    [self configureLabel];
    [self configureConstraints];
}

- (void)configureImageView {
    [self.imageView removeFromSuperview];
    self.imageView = [[WIBImageView alloc] initWithGameItem:self.gameOption.item];
    self.imageView.delegate = self;
    [self addSubview:self.imageView];
}

- (void)configureLabel {
    [self.nameLabel removeFromSuperview];
    self.nameLabel = [UILabel new];
    self.nameLabel.text = [NSString stringWithFormat:@"%d %@",self.gameOption.multiplier,self.gameItem.name.capitalizedString];
    self.nameLabel.font = [UIFont fontWithName:HELVETICA_NEUE_LIGHT size:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
}

- (void)configureConstraints {
    self.clipsToBounds = YES;
    [self.imageView ic_centerHorizontallyInSuperView];
    [self.imageView ic_constraintForHeightAttributeEqualtToView:self multiplier:.5];
    [self.imageView ic_equalRelationConstraintForAttribute:NSLayoutAttributeCenterY toView:self multiplier:1 constant:-10];
    
    [self.nameLabel ic_centerHorizontallyInSuperView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
}

- (WIBGameItem *)gameItem {
    return self.gameOption.item;
}

# pragma mark - OptionView Delegate
- (void)imageViewWasSelected:(WIBImageView *)imageView
{
    [self.delegate optionView:self didSelectOption:self.gameOption];
}

@end
