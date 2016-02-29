//
//  WIBAchievementCollectionViewCell.h
//  WhichIsBigger
//
//  Created by PJ Loury on 2/28/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBAchievementCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;
@property NSString *descriptor;

@end
