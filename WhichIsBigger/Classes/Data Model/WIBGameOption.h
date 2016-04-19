//
//  WIBGameOption.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameItem.h"

@interface WIBGameOption : NSObject

- (id)initWithItem:(WIBGameItem *)item multiplier:(int)multiplier;

@property (nonatomic, strong) WIBGameItem *item;
@property (nonatomic) int multiplier;
@property (nonatomic, readonly) NSString *multiplierString;
@property (nonatomic, readonly) NSNumber *total;
@property (nonatomic, copy) NSString *totalString;
@property (nonatomic) UIColor *color;

@end
