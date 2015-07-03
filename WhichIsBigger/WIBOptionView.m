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

// Views
@property (nonatomic, strong) IBOutlet WIBImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

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
}

- (void)configureImageView {
    //[self.imageView removeFromSuperview];

    self.imageView.gameItem = self.gameOption.item;
    
    self.imageView.delegate = self;
    [self.imageView setup];
    //[self addSubview:self.imageView];
}

- (void)configureLabel {
    self.nameLabel.text = self.gameOption.multiplier > 1 ? [NSString stringWithFormat:@"%d %@",self.gameOption.multiplier,self.gameItem.name.capitalizedString]: self.gameItem.name.capitalizedString;
}

- (void)revealAnswerLabel {
    self.nameLabel.text = self.gameOption.totalString;
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
