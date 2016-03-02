//
//  WIBQuestionTypeCell.h
//  WhichIsBigger
//
//  Created by PJ Loury on 2/7/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBQuestionTypeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CSAnimationView *animationView;
@property IBOutlet UIImageView *imageView;
@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *imageViewContainer;

@end
