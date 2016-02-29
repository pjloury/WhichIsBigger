//
//  WIBQuestionTypeUnlockedViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/29/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "WIBQuestionTypeUnlockedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WIBQuestionType.h"
#import "WIBGamePlayManager.h"
#import "KRConfettiView.h"

@interface WIBQuestionTypeUnlockedViewController () {
    KRConfettiView *confettiView;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;

@property (weak, nonatomic) IBOutlet UIView *shimmeringContentView;

@property (weak, nonatomic) IBOutlet UIView *questionTypeView;
@property (weak, nonatomic) IBOutlet UIImageView *questionTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *advanceButon;


@property UITapGestureRecognizer *tapRecognizer;

@end

@implementation WIBQuestionTypeUnlockedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupImageDownloadDidComplete:) name:kGroupImageDownloadCompleteNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continuePressed:)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.tapRecognizer.enabled = NO;
    self.advanceButon.userInteractionEnabled = NO;
    
    confettiView = [[KRConfettiView alloc] initWithFrame:self.view.frame];
    confettiView.colours = @[[UIColor colorWithRed:0.95 green:0.40 blue:0.27 alpha:1.0],
                             [UIColor colorWithRed:1.00 green:0.78 blue:0.36 alpha:1.0],
                             [UIColor colorWithRed:0.48 green:0.78 blue:0.64 alpha:1.0],
                             [UIColor colorWithRed:0.30 green:0.76 blue:0.85 alpha:1.0],
                             [UIColor colorWithRed:0.58 green:0.39 blue:0.55 alpha:1.0]];
    confettiView.intensity = 0.8;
    confettiView.type = Diamond;
   [self.view addSubview:confettiView];
    
    WIBQuestionType *questionType = [[WIBGamePlayManager sharedInstance] unlockedQuestionType];
    [[WIBGamePlayManager sharedInstance] beginRoundForType:questionType];
    
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.questionTypeView.bounds];
    self.questionTypeView.layer.shadowRadius = 8.0f;
    self.questionTypeView.layer.masksToBounds = NO;
    self.questionTypeView.layer.shadowColor = questionType.tintColor.CGColor;
    self.questionTypeView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    self.questionTypeView.layer.shadowOpacity = 0.8f;
    self.questionTypeView.layer.borderColor = questionType.tintColor.CGColor;
    self.questionTypeView.layer.borderWidth = 15.0f;

//    self.questionTypeView.layer.shadowPath = shadowPath.CGPath;
}

- (void)viewWillAppear:(BOOL)animated
{
    WIBQuestionType *questionType = [[WIBGamePlayManager sharedInstance] unlockedQuestionType];
    [self.questionTypeImageView sd_setImageWithURL:[NSURL URLWithString:questionType.image.url]];
    
    [self.questionTypeImageView sd_setImageWithURL:[NSURL URLWithString:questionType.image.url] completed:^
     (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
         image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
         self.questionTypeImageView.image = image;
     }];
    self.questionTypeImageView.tintColor = questionType.tintColor;
    self.questionTypeView.backgroundColor = questionType.backgroundColor;
    self.questionTypeView.layer.cornerRadius = 16.0f;
    
    [confettiView startConfetti];
    [self performSelector:@selector(finishConfetti) withObject:nil afterDelay:1.25];
    [self.shimmeringView setContentView:self.shimmeringContentView];
    [self.shimmeringView setShimmering:YES];
    
    self.questionTypeLabel.text = questionType.title;
    self.questionTypeLabel.textColor = questionType.tintColor;
    
    self.advanceButon.layer.cornerRadius = 10.0f;
    self.advanceButon.layer.borderWidth = 3.0f;
    self.advanceButon.layer.borderColor = [UIColor lightPurpleColor].CGColor;
}

- (void)finishConfetti
{
    [confettiView stopConfetti];
    [self performSelector:@selector(spinQuestionTypeView) withObject:nil afterDelay:2.0];
}

- (void)spinQuestionTypeView
{
    CABasicAnimation* animation = [CABasicAnimation
                                   animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = 1;
    animation.duration = 4.0;
    
    [self.shimmeringContentView.layer addAnimation:animation forKey:@"rotation"];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 500.0;
    self.shimmeringContentView.layer.transform = transform;
}

- (void)groupImageDownloadDidComplete:(NSNotification *)note
{
    self.tapRecognizer.enabled = YES;
    self.advanceButon.userInteractionEnabled = YES;
}

- (IBAction)continuePressed:(id)sender
{
    [self performSegueWithIdentifier:@"startUnlockedQuestionTypeSegue" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
