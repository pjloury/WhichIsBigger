//
//  WIBAchievementDataSource.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/28/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "WIBAchievementDataSource.h"
#import "WIBAchievementCollectionViewCell.h"
#import "WIBGamePlayManager.h"

@implementation WIBAchievementDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WIBAchievementCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"achievement" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.descriptionLabel.text = @"HIGH SCORE";
        cell.achievementLabel.text = [NSString stringWithFormat:@"%ld",[WIBGamePlayManager sharedInstance].highScore];
        cell.descriptor = @"highScore";
    }
    else if (indexPath.item == 1) {
        cell.descriptionLabel.text = @"LONGEST STREAK";
        cell.achievementLabel.text = [NSString stringWithFormat:@"%ld",[WIBGamePlayManager sharedInstance].longestStreak];
        cell.descriptor = @"longestStreak";
    }
    else if (indexPath.item == 2) {
        cell.descriptionLabel.text = @"CAREER ACCURACY";
        cell.achievementLabel.text = [NSString stringWithFormat:@"%f%%",[WIBGamePlayManager sharedInstance].accuracy];
        cell.descriptor = @"accuracy";
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

@end
