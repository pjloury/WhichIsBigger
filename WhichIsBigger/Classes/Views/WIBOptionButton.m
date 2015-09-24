//
//  WIBOptionButton.m
//  WhichIsBigger
//
//  Created by PJ Loury on 8/20/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBOptionButton.h"

@implementation WIBOptionButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event]; 
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    // Only message the delegate if touch up occurs inside
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        if (self.userInteractionEnabled) {
            [self.delegate optionWasSelected:self];
        }
    }
    [super touchesEnded:touches withEvent:event];
}

@end
