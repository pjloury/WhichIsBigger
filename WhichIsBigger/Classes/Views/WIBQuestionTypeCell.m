//
//  WIBQuestionTypeCell.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/7/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "WIBQuestionTypeCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WIBQuestionTypeCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor faintPurpleColor];
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = .15f;
    animation.fromValue = @(1);
    animation.toValue = @(1.1f);
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
