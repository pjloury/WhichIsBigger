//
//  WIBGameView.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WIBImageView.h"
@class WIBGameOption;

@interface WIBGameView : UIView

- (id)initWithGameOption:(WIBGameOption *)option;
- (void)setupUI;
@end
