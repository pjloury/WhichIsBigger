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

- (id)initWithItem:(WIBGameItem *)item;

@property (nonatomic, strong) WIBGameItem *item;
@property (nonatomic) double multiplier;
@property (nonatomic, readonly) NSNumber *total;

@end
