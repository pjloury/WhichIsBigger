//
//  WIBOptionButton.h
//  WhichIsBigger
//
//  Created by PJ Loury on 8/20/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBPopButton.h"
#import "WIBOptionView.h"

@protocol WIBPopDelegate

- (void)popButtonPressed;
- (void)popButtonLetGo;

@end

@interface WIBOptionButton : UIButton

@property (nonatomic, weak) id<WIBOptionViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;
@property (nonatomic, weak) id<WIBPopDelegate> popDelegate;
- (void)refresh;
- (void)longPressDetected:(UILongPressGestureRecognizer *)sender;

@end
