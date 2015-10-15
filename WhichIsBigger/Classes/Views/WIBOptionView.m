//
//  WIBOptionView.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBOptionView.h"
#import "WIBOptionButton.h"
#import "WIBImageView.h"
#import "WIBGameOption.h"
#import "WIBGameItem.h"
#import "UIView+AutoLayout.h"

@interface WIBOptionView ()<WIBOptionViewDelegate, WIBPopDelegate>

// Views
@property (nonatomic, strong) IBOutlet WIBImageView *imageView;

@property (nonatomic, strong) IBOutlet UILabel *multiplierLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerLabel;
@property (nonatomic, strong) IBOutlet WIBOptionButton *popButton;

@end

@implementation WIBOptionView

- (void)refreshWithOption:(WIBGameOption *)option;
{
	self.alpha = 1.0;
	self.gameOption = option;
    self.userInteractionEnabled = YES;
    self.popButton.popDelegate = self;
    self.popButton.userInteractionEnabled = YES;
    self.answerLabel.hidden = YES;
    [self configureViews];
}

- (void)configureViews
{
    self.backgroundColor = [UIColor sexyLightPurpleColor];
    self.clipsToBounds = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameQuestionTimeUpHandler:) name:kGameQuestionTimeUpNotification object:nil];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self.popButton action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 0.4;
    longPressRecognizer.allowableMovement = 50.0f;
    [self.popButton addGestureRecognizer:longPressRecognizer];
    self.popButton.delegate = self;
    [self.popButton refresh];
    
    [self configureImageView];
    [self configureLabels];
    
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.layer.frame.size.width/10;
    self.layer.masksToBounds = YES;
    self.answerLabel.textColor = [UIColor lightPurpleColor];
    
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = .4;
//    self.layer.shadowRadius = 4;
//    self.layer.shadowOffset = CGSizeZero;
}

- (void)correctResponse
{
    self.imageView.layer.shadowColor = [UIColor greenColor].CGColor;
    self.imageView.layer.shadowOpacity = 1.0;
    self.imageView.layer.shadowRadius = 20;
}

- (void)incorrectResponse;
{
    self.imageView.layer.shadowColor = [UIColor redColor].CGColor;
    self.imageView.layer.shadowOpacity = 1.0;
    self.imageView.layer.shadowRadius = 20;
}

- (void)gameQuestionTimeUpHandler:(NSNotification *)note
{
    self.popButton.userInteractionEnabled = NO;
}

- (void)configureImageView
{
    self.imageView.gameItem = self.gameOption.item;
    self.imageView.multiplier = self.gameOption.multiplier;
    [self.imageView setup];
}

- (void)configureLabels
{
    if (self.gameOption.multiplier == 1)
    {
        self.multiplierLabel.text = self.gameItem.name;
    }
    else
    {
        if ([self.gameItem.name characterAtIndex:self.gameItem.name.length-1] == 's')
        {
            self.multiplierLabel.text = [NSString stringWithFormat:@"%@ %@es",self.gameOption.multiplierString,self.gameItem.name];
        }
        else
        {
            self.multiplierLabel.text = [NSString stringWithFormat:@"%@ %@s",self.gameOption.multiplierString,self.gameItem.name];
        }
    }
}

- (void)revealAnswerLabel
{
    self.answerLabel.hidden = NO;
    self.answerLabel.text = self.gameOption.totalString;
}

- (void)animateTimeOutLarger
{
    self.answerLabel.textColor = [UIColor greenColor];
}

- (void)animateTimeOutSmaller
{
    self.answerLabel.textColor = [UIColor redColor];
}

- (WIBGameItem *)gameItem
{
    return self.gameOption.item;
}

- (void)optionWasSelected:(id)sender
{
    [self.delegate optionView:self didSelectOption:self.gameOption];
}

- (void)popAnimation
{
    [self popButtonPressed];
    [self performSelector:@selector(popButtonLetGo) withObject:nil afterDelay:0.2];
}

# pragma mark - Pop Button Delegate
- (void)popButtonPressed
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = .15f;
    animation.fromValue = @(1);
    animation.toValue = @(1.2f);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale"];

}
- (void)popButtonLetGo
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = .1f;
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1];
    [self.layer addAnimation:animation forKey:@"scale1"];
}

@end
