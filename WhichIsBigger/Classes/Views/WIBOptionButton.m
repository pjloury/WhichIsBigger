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
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended");
        [self.popDelegate popButtonLetGo];
        CGPoint touchPoint = [sender locationInView:self];
        if (CGRectContainsPoint(self.bounds, touchPoint)) {
            if (self.userInteractionEnabled) {
                [self.delegate optionWasSelected:self];
            }
        }
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        [self.popDelegate popButtonPressed];
    }
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
    
    [super touchesEnded:touches withEvent:event];
}

@end
