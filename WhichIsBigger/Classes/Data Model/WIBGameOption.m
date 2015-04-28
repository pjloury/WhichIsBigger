//
//  WIBGameOption.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameOption.h"

@implementation WIBGameOption

- (id)init
{
    self = [super init];
    return self;
}

- (NSNumber *)total
{
    return [NSNumber numberWithDouble: self.multiplier * self.item.baseQuantity.doubleValue];
}

@end
