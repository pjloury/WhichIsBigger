//
//  WIBGameViewController.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WIBQuestionView;
@class WIBGameOption;
@protocol WIBGamePlayDelegate <NSObject>
- (void)questionView:(WIBQuestionView *)questionView didSelectOption:(WIBGameOption *)option;
- (void)questionViewDidFinishRevealingAnswer:(WIBQuestionView *)questionView;

@end

@interface WIBGameViewController : UIViewController<WIBGamePlayDelegate>

@end
