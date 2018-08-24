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
#import "WIBGamePlayManager.h"

@interface WIBOptionView ()<WIBOptionViewDelegate, WIBPopDelegate>

// Views
@property (nonatomic, strong) IBOutlet WIBImageView *imageView;

@property (nonatomic, strong) IBOutlet CSAnimationView *pointsLabelAnimationView;
@property (nonatomic, strong) IBOutlet UILabel *pointsLabel;
@property (nonatomic, strong) IBOutlet UILabel *multiplierLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerLabel;
@property (nonatomic, strong) IBOutlet WIBOptionButton *popButton;

@end

@implementation WIBOptionView

- (void)optionWasSelected
{
    self.userInteractionEnabled = NO;
    self.popButton.userInteractionEnabled = NO;
}

- (void)refreshWithOption:(WIBGameOption *)option;
{
	self.alpha = 1.0;
	self.gameOption = option;
    self.userInteractionEnabled = YES;
    self.popButton.popDelegate = self;
    self.popButton.userInteractionEnabled = YES;
    self.answerLabel.textColor = [UIColor lightPurpleColor];
    self.answerLabel.hidden = YES;
    [self configureViews];
    
    self.imageView.state = WIBImageViewStateUnanswered;
//    self.multiplierLabel.textColor = [[[[WIBGamePlayManager sharedInstance] gameRound] questionType] tintColor];
}

- (void)configureViews
{
    self.clipsToBounds = NO;
    self.pointsLabel.alpha = 0.0;
    self.pointsLabel.backgroundColor = [UIColor clearColor];
    self.multiplierLabel.textColor = [[[[WIBGamePlayManager sharedInstance] gameRound] questionType] labelThemeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameQuestionTimeUpHandler:) name:kGameQuestionTimeUpNotification object:nil];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self.popButton action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 0.1;
    longPressRecognizer.allowableMovement = 50.0f;
    [self.popButton addGestureRecognizer:longPressRecognizer];
    self.popButton.delegate = self;
    [self.popButton refresh];
    
    [self configureImageView];
    [self configureLabels];

    self.backgroundColor = [UIColor clearColor];
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
    self.imageView.tintColor = self.gameOption.color;
}

- (void)configureLabels
{
    if (self.gameOption.multiplier == 1) {
        self.multiplierLabel.text = self.gameItem.name;
    } else {
        if ([self.gameItem.name characterAtIndex:self.gameItem.name.length-1] == 's') {
            self.multiplierLabel.text = [NSString stringWithFormat:@"%@ %@es",self.gameOption.multiplierString,self.gameItem.name];
        } else {
            self.multiplierLabel.text = [NSString stringWithFormat:@"%@ %@s",self.gameOption.multiplierString,self.gameItem.name];
        }
    }
}

- (void)correctResponse
{
    self.imageView.state = WIBImageViewStateCorrect;
}

- (void)incorrectResponse
{
    self.imageView.state = WIBImageViewStateIncorrect;
}

- (void)revealAnswerLabel
{
    self.answerLabel.hidden = NO;
    self.answerLabel.text = self.gameOption.totalString;
}

- (void)animateTimeOutLarger
{
    self.answerLabel.textColor = [UIColor correctAnswerGreenColor];
}

- (void)animateTimeOutSmaller
{
    self.answerLabel.textColor = [UIColor incorrectAnswerRedColor];
}

- (void)animatePointsLabel:(NSInteger) points
{
    if (points > 50) {
        UIFont *font = [UIFont fontWithName:@"Blogger-Sans" size:20.0];
        UIFont *bonusFont = [UIFont fontWithName:@"RifficFree-Bold" size:20.0];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *bonusAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor slowAnswerColor], NSForegroundColorAttributeName,
                                        bonusFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,nil];
        NSMutableAttributedString *bonusAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Speed Bonus!" attributes:bonusAttributes];
        
        NSDictionary *pointsAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor quickAnswerColor], NSForegroundColorAttributeName,
                                        font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,nil];
        NSMutableAttributedString *pointsAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"\n+%ld pts", points] attributes:pointsAttributes];
        [bonusAttributedString appendAttributedString:pointsAttributedString];
        self.pointsLabel.attributedText = bonusAttributedString;
    }
    else {
        self.pointsLabel.text = [NSString stringWithFormat:@"%+ld pts", points];
        self.pointsLabel.textColor = UIColor.quickAnswerColor;
    }
    
    self.pointsLabel.transform = CGAffineTransformMakeScale(1, 1);
    self.pointsLabel.alpha = 1;
    
    [UIView animateKeyframesWithDuration:[WIBGamePlayManager sharedInstance].fastAnimationSpeed delay:0 options:0 animations:^{
        self.pointsLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:[WIBGamePlayManager sharedInstance].animationSpeed delay:1.8 options:0 animations:^{
            self.pointsLabel.alpha = 0.0;
        }
                                  completion:nil];
    }];
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
    [self performSelector:@selector(popButtonLetGo) withObject:nil afterDelay:0.05];
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
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
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

- (void)removeAllAnimations {
    [self.pointsLabel.layer removeAllAnimations];
    self.pointsLabel.alpha = 0.0;
    self.pointsLabel.transform = CGAffineTransformMakeScale(1, 1);
}

@end
