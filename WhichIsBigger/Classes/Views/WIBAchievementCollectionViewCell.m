//
//  WIBAchievementCollectionViewCell.m
//  WhichIsBigger
//
//  Created by PJ Loury on 2/28/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "WIBAchievementCollectionViewCell.h"

@implementation WIBAchievementCollectionViewCell

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? [UIColor lightGrayColor]: [UIColor whiteColor];
}


@end
