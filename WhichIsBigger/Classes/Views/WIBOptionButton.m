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
    [super touchesBegan:touches withEvent:event]; // you need this
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint))
    {
        [self.delegate optionWasSelected:self];
    }
    [super touchesEnded:touches withEvent:event];
}

@end
