//
//  WIBPopButton.m
//  WhichIsBigger
//
//  Created by PJ Loury on 7/4/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBPopButton.h"

@implementation WIBPopButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = .15f;
    animation.fromValue = @(1);
    animation.toValue = @(1.2f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale"];
    [super touchesBegan:touches withEvent:event]; // you need this
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = .1f;
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale1"];
    [super touchesEnded:touches withEvent:event];
}


@end
