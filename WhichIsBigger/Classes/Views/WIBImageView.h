//
//  WIBImageView.h
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WIBGameItem;

@interface WIBImageView : UIButton

- (instancetype)initWithGameItem:(WIBGameItem *)item;

@end