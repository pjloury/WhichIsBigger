//
//  WIBImageView.h
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBOptionView.h"

@class WIBGameItem;


@interface WIBImageView : UIButton

// Newly Exposed
- (void)setup;
@property (nonatomic, weak) WIBGameItem *gameItem;

@property (nonatomic, weak) id<WIBOptionViewDelegate> delegate;

@end
