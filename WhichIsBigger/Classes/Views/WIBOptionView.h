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
@protocol WIBQuestionViewDelegate;

@interface WIBOptionView : CSAnimationView

@property (nonatomic, weak) WIBGameOption *gameOption;
@property (nonatomic, weak) id<WIBQuestionViewDelegate> delegate;

- (void)refreshWithOption:(WIBGameOption *)option;
- (void)revealAnswerLabel;
- (void)correctResponse;
- (void)incorrectResponse;
- (void)configureViews;
- (void)animateTimeOutLarger;
- (void)animateTimeOutSmaller;
- (void)animatePointsLabel:(NSInteger) points;
- (void)popAnimation;

@end

@protocol WIBOptionViewDelegate

@required
- (void)optionWasSelected:(id)sender;
@end