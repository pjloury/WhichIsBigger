//
//  WIBOptionView.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WIBQuestionView.h"
@class WIBGameOption;
@class WIBImageView;

@interface WIBOptionView : CSAnimationView
- (void)refreshWithOption:(WIBGameOption *)option;
- (void)revealAnswerLabel;
- (void)correctResponse;
- (void)incorrectResponse;

@property (nonatomic, weak) WIBGameOption *gameOption;
- (void)configureViews;

@property (nonatomic, weak) id<WIBQuestionViewDelegate> delegate;

@end

@protocol WIBOptionViewDelegate

@required
- (void)optionWasSelected:(id)sender;
@end