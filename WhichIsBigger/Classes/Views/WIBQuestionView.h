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

@interface WIBQuestionView : CSAnimationView

@property (nonatomic, strong) IBOutlet CSAnimationView *comparsionSymbolAnimationView;
@property (nonatomic, strong) IBOutlet UILabel *comparsionSymbol;
@property (nonatomic, weak) WIBGameQuestion *question;
@property (getter=isGamePlayDisabled) BOOL gamePlayDisabled;
@property (nonatomic, weak) id<WIBGamePlayDelegate> gamePlayDelegate;
- (void)setup;
- (void)refreshWithQuestion:(WIBGameQuestion *)question;
- (void)startQuestionEntranceAnimationWithCompletion:(void (^)(BOOL finished))completion;
- (void)startQuestionExitAnimationWithCompletion:(void (^)(BOOL finished))completion;

@end


#pragma mark - WIBQuestionViewDelegate
@class WIBOptionView;
@class WIBGameOption;
@protocol WIBQuestionViewDelegate

- (void)optionView:(WIBOptionView *)optionView didSelectOption:(WIBGameOption *)option;

@end