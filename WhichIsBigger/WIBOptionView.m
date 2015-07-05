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
#import "UIView+AutoLayout.h"
    

@interface WIBOptionView ()<WIBOptionViewDelegate>

// Views
@property (nonatomic, strong) IBOutlet WIBImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;


@end

@implementation WIBOptionView

- (void)refreshWithOption:(WIBGameOption *)option;
{
    self.gameOption = option;
    [self configureViews];
}

- (void)configureViews
{
    self.backgroundColor = [UIColor sexyLightPurpleColor];
    [self configureImageView];
    [self configureLabel];
}

- (void)configureImageView
{
    self.imageView.gameItem = self.gameOption.item;
    self.imageView.delegate = self;
    [self.imageView setup];
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
