//
//  WIBImageView.h
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBOptionView.h"

@class WIBGameItem;

typedef NS_ENUM(NSUInteger, WIBImageViewState) {
    WIBImageViewStateUnanswered,
    WIBImageViewStateCorrect,
    WIBImageViewStateIncorrect,
};

@interface WIBImageView : UIImageView

- (void)setup;

@property (nonatomic) WIBImageViewState state;
@property (nonatomic, weak) WIBGameItem *gameItem;
@property (nonatomic, assign) int multiplier;
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;
@end
