//
//  WIBGameCompleteViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/29/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameCompleteViewController.h"
#import "WIBGameViewController.h"
#import "WIBGamePlayManager.h"
#import "WIBConstants.h"
@interface WIBGameCompleteViewController ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *answersCollectionView;

@end


@implementation WIBGameCompleteViewController

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"GAME COMPLETE!");
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *playAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(50,50,200,50)];
    [playAgainButton setTitle:@"Play Again!" forState:UIControlStateNormal];
    playAgainButton.titleLabel.textColor = [UIColor blueColor];
    [playAgainButton addTarget:self action:@selector(didPressNewGame:) forControlEvents:UIControlEventTouchDown];
    playAgainButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:playAgainButton];
    NSLog(@"%ld Questions Answered Correctly!",[[WIBGamePlayManager sharedInstance] numberCorrectAnswers]);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBER_OF_QUESTIONS;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"answer" forIndexPath:indexPath];
    [cell.contentView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenCheck"]]];
    return cell;
}

- (void)didPressNewGame:(id)sender
{
    NSLog(@"New game pressed!");
//    [self.navigationController popViewControllerAnimated:NO];
    [self presentViewController:[[WIBGameViewController alloc] init] animated:NO completion:nil];
}

@end
