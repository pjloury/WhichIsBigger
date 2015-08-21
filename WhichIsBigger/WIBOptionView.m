//
//  WIBOptionView.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBOptionView.h"
#import "WIBOptionButton.h"
#import "WIBImageView.h"
#import "WIBGameOption.h"
#import "WIBGameItem.h"
#import "UIView+AutoLayout.h"

@interface WIBOptionView ()<WIBOptionViewDelegate>

// Views
@property (nonatomic, strong) IBOutlet WIBImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet WIBOptionButton *popButton;

@end

@implementation WIBOptionView

- (void)refreshWithOption:(WIBGameOption *)option;
{
	self.alpha = 1.0;
	self.gameOption = option;
    self.userInteractionEnabled = YES;
    self.popButton.userInteractionEnabled = YES;
    [self configureViews];
}

- (void)configureViews
{
    self.backgroundColor = [UIColor sexyLightPurpleColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameQuestionTimeUpHandler:) name:kGameQuestionTimeUpNotification object:nil];
    self.popButton.delegate = self;
    [self configureImageView];
    [self configureLabel];
    
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = .4;
//    self.layer.shadowRadius = 4;
//    self.layer.shadowOffset = CGSizeZero;
}

- (void)gameQuestionTimeUpHandler:(NSNotification *)note
{
    self.popButton.userInteractionEnabled = NO;
}

- (void)configureImageView
{
    self.imageView.gameItem = self.gameOption.item;
    [self.imageView setup];
}

- (void)configureLabel
{
    self.nameLabel.text = self.gameOption.multiplier > 1 ? [NSString stringWithFormat:@"%d %@",self.gameOption.multiplier,self.gameItem.name.capitalizedString]: self.gameItem.name;
}

- (void)revealAnswerLabel
{
    self.nameLabel.text = self.gameOption.totalString;
}

- (WIBGameItem *)gameItem
{
    return self.gameOption.item;
}

- (void)optionWasSelected:(id)sender
{
    [self.delegate optionView:self didSelectOption:self.gameOption];
}

@end
