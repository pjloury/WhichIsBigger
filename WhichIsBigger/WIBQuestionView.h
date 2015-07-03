//
//  WIBQuestionView.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/28/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBGameViewController.h"

@class WIBGameQuestion;
@protocol WIBGamePlayDelegate;
@interface WIBQuestionView : UIView
- (void)refreshWithQuestion:(WIBGameQuestion *)question;
@property (nonatomic, weak) id<WIBGamePlayDelegate> delegate;

// Newly exposed
@property (nonatomic, weak) WIBGameQuestion *question;
- (void)setup;

@end

// WIBQuestionViewDelegate
@class WIBOptionView;
@class WIBGameOption;
@protocol WIBQuestionViewDelegate

@required
- (void)optionView:(WIBOptionView *)optionView didSelectOption:(WIBGameOption *)option;


@end