//
//  WIBGameViewController.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WIBQuestionView;
@protocol WIBGamePlayDelegate <NSObject>

@required
- (void)questionView:(WIBQuestionView *)questionView didTapNextButton:(UIButton *)nextButton;

@end

@interface WIBGameViewController : UIViewController<WIBGamePlayDelegate>


@end
