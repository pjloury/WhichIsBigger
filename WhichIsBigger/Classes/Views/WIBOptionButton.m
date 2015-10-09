//
//  WIBOptionButton.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/20/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBOptionButton.h"


@interface WIBOptionButton ()
@property BOOL longPressed;
@end

@implementation WIBOptionButton

- (void)refresh
{
    self.longPressed = NO;
}

- (void)longPressDetected:(UILongPressGestureRecognizer *)sender
{
    [self.popDelegate popButtonPressed];
    self.longPressed = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        if (self.userInteractionEnabled) {
            [self.delegate optionWasSelected:self];
        }
    }
    
    if(self.longPressed) {
        [self.popDelegate popButtonLetGo];
        self.longPressed = NO;
    }
    [super touchesEnded:touches withEvent:event];
}

@end
