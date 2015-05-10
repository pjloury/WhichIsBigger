//
//  WIBQuestionView.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/28/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBGameViewController.h"

// WIBQuestionView
@class WIBGameQuestion;
@protocol WIBGamePlayDelegate;
@interface WIBQuestionView : UIView
- (instancetype)initWithGameQuestion:(WIBGameQuestion *)question;
- (void)refreshWithQuestion:(WIBGameQuestion *)question;
@property (nonatomic, weak) id<WIBGamePlayDelegate> delegate;
@end

// WIBQuestionViewDelegate
@class WIBOptionView;
@class WIBGameOption;
@protocol WIBQuestionViewDelegate

@required
- (void)optionView:(WIBOptionView *)optionView didSelectOption:(WIBGameOption *)option;


@end