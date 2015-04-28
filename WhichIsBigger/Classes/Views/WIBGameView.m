//
//  WIBGameView.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameView.h"
#import "WIBGameOption.h"

@interface WIBGameView()
@property (nonatomic, strong)  WIBGameOption *option;
@property (nonatomic, weak) IBOutlet UILabel *optionLabel;
@property (nonatomic, weak) IBOutlet UILabel *scaleLabel;
@property (nonatomic, strong) IBOutlet WIBImageView *imageView;
@end

@implementation WIBGameView

- (id)initWithGameOption:(WIBGameOption *)option
{
    self = [super init];
    if (self)
    {
        _option = option;
        [self setupUI];

    }
    return self;
}

- (void)setupUI
{
    self.optionLabel.text = self.option.item.name;
    self.scaleLabel.text = [NSString stringWithFormat:@"%f",self.option.multiplier];
    
    
}


- (void)setupImageView
{
    self.imageView = [WIBImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    [self addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]
                                ]];

}

@end
